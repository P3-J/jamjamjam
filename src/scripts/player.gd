extends CharacterBody3D

var speed = 5.0
var jump_speed = 10.0  
var gravity = -30.0  
var max_fall_speed = -60.0  

var mouse_sensitivity = 0.01
@onready var head: Node3D
var y_rotation = 0.0  

func _ready() -> void:
    head = get_node("head")
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * mouse_sensitivity)

        y_rotation = clamp(y_rotation - event.relative.y * mouse_sensitivity, -1.5, 1.0) 
        head.rotation.x = y_rotation

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
    velocity = global_transform.basis * velocity  

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_speed

    if not is_on_floor():
        velocity.y += gravity * delta
        if velocity.y < max_fall_speed:
            velocity.y = max_fall_speed

    move_and_slide()

    if is_on_floor() and velocity.y < 0:
        velocity.y = 0
