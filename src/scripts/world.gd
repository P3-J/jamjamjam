extends Node3D

@export var time_to_start: float = 2.0  # You can change this value as needed
@export var start_area: TriggerArea
@export var level_name: String

var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globalsettings.on_level = level_name
	pass

func start_game():
	Signalbus.emit_signal('make_lava_rise')
	Signalbus.emit_signal('game_starts')

func _on_area_3d_body_exited(body):
	start_game()
