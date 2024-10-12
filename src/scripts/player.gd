extends CharacterBody3D
@onready var head: Node3D
@onready var jump_timer: Timer
@onready var hookray: RayCast3D
@onready var pickaxe: Node3D
@onready var hook_start_time: Timer
@onready var body: MeshInstance3D

var speed = 10.0
var hook_speed = 15.0
var air_speed = 10.0
var jump_speed = 10.0  
var gravity = -25.0  
var max_fall_speed = -80.0  

var mouse_sensitivity = Globalsettings.mouse_sensitivity
var y_rotation = 0.0  

var can_still_jump: bool = true
var jumped: bool = false

var can_hook: bool = false
var holding_hook_button: bool = false
var can_move_towards_hook: bool = false


var pickaxe_reset_pos: Vector3

func _ready() -> void:
	head = get_node("head")
	jump_timer = get_node("utils/jump_timer")
	hookray = get_node("head/hookray")
	hook_start_time = get_node("utils/hook_start_time")
	body = get_node("playermesh")

	pickaxe = get_node("head/Pickaxe")
	pickaxe_reset_pos = pickaxe.position

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


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


func _process(delta: float) -> void:
	check_for_hook_collision()


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
		reset_pickaxe_position()

	
func check_for_hook_collision():
	if (!hookray.is_colliding()):
		reset_pickaxe_position()
		can_hook = false
		can_move_towards_hook = false
		return
	can_hook = true

func reset_pickaxe_position():
	pickaxe.position = pickaxe_reset_pos

func hook_towards(collider):
	var direction = (collider.global_position - global_transform.origin).normalized() 
	velocity = direction * hook_speed

func send_hook_towards(collider, delta):
	pickaxe.global_position = pickaxe.global_position.move_toward(collider.global_position, 15 * delta)


	
	
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


func _on_hook_start_time_timeout() -> void:
	print("timed out")
	can_move_towards_hook = true
