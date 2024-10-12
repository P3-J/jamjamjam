extends Area3D
class_name FallingRock

@export var falling_speed = 5
@export var trigger_area: TriggerArea = null

@onready var initial_global_transform = global_transform

var is_falling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trigger_area.on_player_entered = _on_trigger_triggered


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_falling:
		global_transform.origin.y -= falling_speed * delta
	
	if global_transform.origin.y < 0:
		is_falling = false
		global_transform = initial_global_transform


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		Signalbus.emit_signal('kill_player')

func _on_trigger_triggered():
	is_falling = true