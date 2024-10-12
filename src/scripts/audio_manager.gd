extends Node

@onready var main_music_stream = $MainMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.connect('game_starts', _start_main_music)

func _start_main_music() -> void:
	main_music_stream.playing = true
