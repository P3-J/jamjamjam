extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_entered(area: Area3D) -> void:
	if area.name == 'PickaxeArea':
		Signalbus.emit_signal('pickaxe_grab')
