extends Area3D
class_name TriggerArea

var player_entered = false
var on_player_entered: Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		on_player_entered.call()
