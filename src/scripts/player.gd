extends CharacterBody3D
@onready var head: Node3D
@onready var jump_timer: Timer

var speed = 10.0
var jump_speed = 10.0  
var gravity = -25.0  
var max_fall_speed = -60.0  

var mouse_sensitivity = 0.01
var y_rotation = 0.0  

var can_still_jump: bool = true
var jumped: bool = false


func _ready() -> void:
	head = get_node("head")
	jump_timer = get_node("utils/jump_timer")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	var direction := Vector3()

	direction = _player_movement(direction)
	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity = global_transform.basis * velocity  

	if is_on_floor():
		# reset the ability to jump.
		if (!jump_timer.is_stopped()):
			jump_timer.stop()
			can_still_jump = true

		jumped = false

	if Input.is_action_just_pressed("jump") and not jumped and can_still_jump:
		jumped = true
		velocity.y = jump_speed
		can_still_jump = false


	if not is_on_floor():

		if (jump_timer.is_stopped()):
			jump_timer.start()

		velocity.y += gravity * delta
		if velocity.y < max_fall_speed:
			velocity.y = max_fall_speed

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
	print("epic")
	can_still_jump = false
