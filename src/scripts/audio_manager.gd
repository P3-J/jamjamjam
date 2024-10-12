extends Node

@onready var main_music = $MainMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.connect('game_starts', _start_main_music)
	Signalbus.connect('player_wins', _stop_main_music)

func _start_main_music() -> void:	
	main_music.playing = true

func _stop_main_music() -> void:
	main_music.playing = false
