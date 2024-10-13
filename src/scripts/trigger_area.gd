extends Area3D
class_name TriggerArea

var player_entered = false
var on_player_entered: Callable

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		on_player_entered.call()
