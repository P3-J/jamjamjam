extends Area3D	

@export var boosts: bool = false

func _ready() -> void:		
	global_rotation_degrees = Vector3(0, global_rotation_degrees.y -270, 0)


func _on_area_entered(area: Area3D) -> void:
	if area.name == 'PickaxeArea':
		Signalbus.emit_signal('pickaxe_grab', true)


func _on_area_exited(area: Area3D) -> void:
	if area.name == 'PickaxeArea':
		Signalbus.emit_signal('pickaxe_grab', false)


func _on_body_entered(body: Node3D) -> void:
	if body.name == 'player':
		Signalbus.emit_signal('player_in_hook_area', boosts)
		if boosts:
			Signalbus.emit_signal('play_ring_boost_sound')
			self.queue_free()
