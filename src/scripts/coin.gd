extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if (body is CharacterBody3D):
		Signalbus.emit_signal("picked_up_coin", 1)
		self.queue_free()
