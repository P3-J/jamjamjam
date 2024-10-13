extends Node

@onready var main_music = $MainMusic
@onready var death_sound = $DeathSound
@onready var pickaxe_sound = $PickAxeGrab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.connect('game_starts', _start_main_music)
	Signalbus.connect('kill_player', _play_death_sound)
	Signalbus.connect('pickaxe_grab', _play_pickaxe_grab_sound)

func _process(delta: float) -> void:
	main_music.volume_db = lerp(-20, 20, Globalsettings.music_volume / 100.0)
	death_sound.volume_db = lerp(-20, 20, Globalsettings.audio_volume / 100.0)
	pickaxe_sound.volume_db = lerp(-20, 20, Globalsettings.audio_volume / 100.0)

func _start_main_music() -> void:
	main_music.playing = true

func _play_death_sound() -> void:
	death_sound.playing = true

func _play_pickaxe_grab_sound() -> void:
	pickaxe_sound.playing = true
