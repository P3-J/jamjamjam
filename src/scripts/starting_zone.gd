extends Area3D

@onready var crystal = $Crystall1

func _ready() -> void:
	pass

func start_game():
	Signalbus.emit_signal('make_lava_rise')
	Signalbus.emit_signal('game_starts')

func _on_body_entered(body: Node3D) -> void:
	if (body.name != "player"):
		return
	#crystal.queue_free()
	start_game()
