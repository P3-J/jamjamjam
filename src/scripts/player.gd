extends CharacterBody3D


var speed = 5.0
var jump_speed = 10.0  
var gravity = -30.0  
var max_fall_speed = -60.0  


func _physics_process(delta: float) -> void:

	var direction := Vector3()

	if Input.is_action_pressed("up"):
		direction.z -= 1
	if Input.is_action_pressed("down"):
		direction.z += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	if not is_on_floor():
		velocity.y += gravity * delta
		# clamp velocity independent of gravity
		if velocity.y < max_fall_speed:
			velocity.y = max_fall_speed

	move_and_slide()

	if is_on_floor() and velocity.y < 0:
		velocity.y = 0

