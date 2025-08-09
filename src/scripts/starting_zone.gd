extends Area3D

func _ready() -> void:
	pass

func start_game():
	Signalbus.emit_signal('make_lava_rise')
	Signalbus.emit_signal('game_starts')

func _on_body_exited(body: Node3D) -> void:
	start_game()
