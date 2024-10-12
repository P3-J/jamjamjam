extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	print('Player enter?')
	if body.is_in_group('player'):
		Signalbus.emit_signal('player_wins')
