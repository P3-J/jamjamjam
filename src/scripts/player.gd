extends CharacterBody3D

var winning_menu_scene =  ResourceLoader.load("res://src/scenes/winning_menu.tscn") as PackedScene
var lava_meter_scene =  ResourceLoader.load("res://src/scenes/lava_meter.tscn") as PackedScene

@onready var head: Node3D
@onready var jump_timer: Timer
@onready var hookray: RayCast3D
@onready var pickaxe: Node3D
@onready var hook_start_time: Timer
@onready var body: MeshInstance3D
@onready var crosshair: TextureRect = $UI/Crosshair
@onready var ui_node = $UI
@onready var player_anim: AnimationPlayer
@onready var timer_text: RichTextLabel
@onready var running_audio_stream = AudioStreamPlayer.new()

@onready var normal_crosshair_texture = load("res://src/assets/crosshair_normal.png")
@onready var highlighted_crosshair_texture = load("res://src/assets/crosshair_highlighted.png")

var speed = 10.0
var hook_speed = 15.0
var air_speed = 10.0
var jump_speed = 14.0  
var gravity = -25.0  
var max_fall_speed = -80.0  

var mouse_sensitivity: float = Globalsettings.mouse_sensitivity
var y_rotation = 0.0  

var has_died: bool = false
var can_still_jump: bool = true
var jumped: bool = false

var can_hook: bool = false
var holding_hook_button: bool = false
var can_move_towards_hook: bool = false

var start_time: int = 0
var is_stopwatch_running: bool = false

var minutes : int = 0
var seconds : int = 0
var milliseconds : int = 0


var pickaxe_reset_pos: Vector3

func _ready() -> void:
	setup_ui()
	setup_sound_stream()
	head = get_node("head")
	jump_timer = get_node("utils/jump_timer")
	hookray = get_node("head/hookray")
	hook_start_time = get_node("utils/hook_start_time")
	body = get_node("playermesh")
	player_anim = get_node("player_anim")
	timer_text = get_node("UI/timer_text")

	pickaxe = get_node("head/Pickaxe")
	pickaxe_reset_pos = pickaxe.position


	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signalbus.connect('kill_player', _on_player_kill)
	Signalbus.connect('game_starts', _on_game_starts)
	Signalbus.player_wins.connect(reached_end)

func _physics_process(delta: float) -> void:
	var direction := Vector3()

	direction = _player_movement(direction)
	direction = direction.normalized()
	direction = global_transform.basis * direction

	if is_on_floor():
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		if velocity.x <= 0 and velocity.z <= 0:
			player_anim.stop()

		jump_timer.stop()
		can_still_jump = true
		jumped = false

	else:
		velocity.x = lerp(velocity.x, direction.x * air_speed, 0.05)
		velocity.z = lerp(velocity.z, direction.z * air_speed, 0.05)

		player_anim.stop()

		velocity.y += gravity * delta
		if velocity.y < max_fall_speed:
			velocity.y = max_fall_speed

		if jump_timer.is_stopped():
			jump_timer.start()

	if Input.is_action_just_pressed("jump") and not jumped and can_still_jump:
		jumped = true
		velocity.y = jump_speed
		can_still_jump = false

	if (holding_hook_button and can_hook):

		var collider: Node3D = hookray.get_collider()
		send_hook_towards(collider, delta)

		if (hook_start_time.is_stopped()):
			hook_start_time.start()
			return
		
		if (can_move_towards_hook):
			hook_towards(collider)

	move_and_slide()

	if is_on_floor() and velocity.y < 0:
		velocity.y = 0
	
	if is_on_floor() && velocity > Vector3.ZERO && !running_audio_stream.playing:
		running_audio_stream.stream_paused = false
		running_audio_stream.playing = true
	
	if velocity == Vector3.ZERO || not is_on_floor():
		running_audio_stream.stream_paused = true


func _process(_delta: float) -> void:
	update_time()


	check_for_hook_collision()
	mouse_sensitivity = Globalsettings.mouse_sensitivity


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if (can_hook and holding_hook_button and can_move_towards_hook):
			return
		rotate_y(-event.relative.x * mouse_sensitivity)
		y_rotation = clamp(y_rotation - event.relative.y * mouse_sensitivity, -1.5, 1.4) 
		head.rotation.x = y_rotation
	
	if Input.is_action_just_pressed("hook"):
		holding_hook_button = true
	if Input.is_action_just_released("hook"):
		holding_hook_button = false
		pickaxe.scale = Vector3(2,2,2)
		reset_pickaxe_position()

	
func check_for_hook_collision():
	if (!hookray.is_colliding()):
		reset_pickaxe_position()
		crosshair.texture = normal_crosshair_texture
		can_hook = false
		can_move_towards_hook = false
		return

	var collider = hookray.get_collider()
	if (!collider.is_in_group("hook")):
		return
	can_hook = true
	crosshair.texture = highlighted_crosshair_texture

func reset_pickaxe_position():
	pickaxe.position = pickaxe_reset_pos



func hook_towards(collider):
	var direction = (collider.global_position - global_transform.origin).normalized() 
	velocity = direction * hook_speed

func send_hook_towards(collider, delta):
	pickaxe.scale = Vector3(2,2,2)
	pickaxe.global_position = pickaxe.global_position.move_toward(collider.global_position, 15 * delta)


	
	
func _player_movement(direction: Vector3) -> Vector3:
	if Input.is_action_pressed("up"):
		direction.z -= 1
		_sway_head()
	if Input.is_action_pressed("down"):
		direction.z += 1
		_sway_head()
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	return direction

func _sway_head():
	player_anim.play("head_sway")


func _on_jump_timer_timeout() -> void:
	can_still_jump = false


func _on_hook_start_time_timeout() -> void:
	can_move_towards_hook = true
	
	
func _on_player_kill() -> void:
	if !has_died:
		has_died = true
		Signalbus.kill_player.emit()

func setup_ui() -> void:
	var winning_menu = winning_menu_scene.instantiate()
	winning_menu.visible = false
	ui_node.add_child(winning_menu)
	var lava_meter = lava_meter_scene.instantiate()
	ui_node.add_child(lava_meter)



func update_time():
	if is_stopwatch_running:
		var current_time = Time.get_ticks_msec() 
		var elapsed_time = (current_time - start_time) / 1000.0 
		timer_text.text = format_time(elapsed_time) 

func start_speedrun_timer():
	start_time = Time.get_ticks_msec()
	is_stopwatch_running = true


func format_time(elapsed_time: float) -> String:
	minutes = int(elapsed_time / 60)
	seconds = int(elapsed_time) % 60
	milliseconds = int((elapsed_time - int(elapsed_time)) * 1000)

	var minute_str = str(minutes).pad_zeros(2)
	var second_str = str(seconds).pad_zeros(2)
	var millisecond_str = str(milliseconds).pad_zeros(3)
	return minute_str + ":" + second_str + ":" + millisecond_str


func reached_end():
	Signalbus.minutes = minutes
	Signalbus.milliseconds = milliseconds
	Signalbus.seconds = seconds
	
	get_tree().change_scene_to_file("res://src/scenes/score_screen.tscn")


func setup_sound_stream() -> void:
	running_audio_stream.stream = load('res://src/assets/sounds/running.wav')
	self.add_child(running_audio_stream)

func _on_game_starts() -> void:
	start_speedrun_timer()
