extends CharacterBody3D
@onready var head: Node3D
@onready var jump_timer: Timer
@onready var death_screen = $UI/DeathScreen
@onready var death_timer: Timer = $utils/death_timer
@onready var crosshair = $UI/Crosshair

var speed = 10.0
var air_speed = 10.0
var jump_speed = 10.0  
var gravity = -25.0  
var max_fall_speed = -60.0  

var mouse_sensitivity: float = Globalsettings.mouse_sensitivity
var y_rotation = 0.0  


var input_enabled: bool = true
var has_been_called: bool = false
var can_still_jump: bool = true
var jumped: bool = false
# audio lava, channels
# signs tutorial

func _ready() -> void:
	head = get_node("head")
	jump_timer = get_node("utils/jump_timer")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signalbus.connect('kill_player', _on_player_kill)
	death_timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))


func _process(delta: float) -> void:
	mouse_sensitivity = Globalsettings.mouse_sensitivity


func _physics_process(delta: float) -> void:
	var direction := Vector3()

	direction = _player_movement(direction)
	direction = direction.normalized()

	direction = global_transform.basis * direction





	if is_on_floor():
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

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

	move_and_slide()

	if is_on_floor() and velocity.y < 0:
		velocity.y = 0



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

		y_rotation = clamp(y_rotation - event.relative.y * mouse_sensitivity, -1.5, 1.0) 
		head.rotation.x = y_rotation


func _player_movement(direction: Vector3) -> Vector3:
	if Input.is_action_pressed("up"):
		direction.z -= 1
	if Input.is_action_pressed("down"):
		direction.z += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1
	
	return direction


func _on_jump_timer_timeout() -> void:
	can_still_jump = false

func _on_player_kill() -> void:
	while !has_been_called:
		has_been_called = true
		Signalbus.kill_player.emit()
		death_timer.start()
		Globalsettings.input_enabled = false
		get_tree().paused = true


func _on_death_timer_timeout() -> void:
	get_tree().paused = false
	Globalsettings.input_enabled = true
	get_tree().reload_current_scene()
