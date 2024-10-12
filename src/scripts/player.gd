extends CharacterBody3D

var winning_menu_scene =  ResourceLoader.load("res://src/scenes/winning_menu.tscn") as PackedScene

@onready var head: Node3D
@onready var jump_timer: Timer
@onready var hookray: RayCast3D
@onready var pickaxe: Node3D
@onready var hook_start_time: Timer
@onready var body: MeshInstance3D
@onready var crosshair: TextureRect = $UI/Crosshair
@onready var ui_node = $UI
@onready var player_anim: AnimationPlayer

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


var pickaxe_reset_pos: Vector3

func _ready() -> void:
	setup_ui();
	head = get_node("head")
	jump_timer = get_node("utils/jump_timer")
	hookray = get_node("head/hookray")
	hook_start_time = get_node("utils/hook_start_time")
	body = get_node("playermesh")
	player_anim = get_node("player_anim")

	pickaxe = get_node("head/Pickaxe")
	pickaxe_reset_pos = pickaxe.position

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signalbus.connect('kill_player', _on_player_kill)

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


func _process(_delta: float) -> void:
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
		pickaxe.scale = Vector3(1,1,1)
		reset_pickaxe_position()

	
func check_for_hook_collision():
	if (!hookray.is_colliding()):
		reset_pickaxe_position()
		crosshair.texture = load("res://src/assets/crosshair_normal.png")
		can_hook = false
		can_move_towards_hook = false
		return
	can_hook = true
	crosshair.texture = load("res://src/assets/crosshair_highlighted.png")

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
	print("timed out")
	can_move_towards_hook = true
	
	
func _on_player_kill() -> void:
	if !has_died:
		has_died = true
		Signalbus.kill_player.emit()
		print('player should die!')

func setup_ui() -> void:
	var winning_menu = winning_menu_scene.instantiate()
	winning_menu.visible = false
	ui_node.add_child(winning_menu)
