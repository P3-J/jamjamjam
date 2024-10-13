extends Node

@onready var main_music = $MainMusic
@onready var death_sound = $DeathSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.connect('game_starts', _start_main_music)
	Signalbus.connect('kill_player', _play_death_sound)

func _start_main_music() -> void:
	main_music.playing = true

func _play_death_sound() -> void:
	death_sound.playing = true
