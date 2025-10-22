extends Node3D

var mouse_sensitivity: float
var input_disabled = false
var splash_screen_called = false
var audio_volume: float
var music_volume: float


const SETTINGS_PATH = "user://settings.cfg"

func _ready() -> void:
	load_settings()  

	_setup_leaderboard_connection()


func _setup_leaderboard_connection():
	SilentWolf.configure({
	"api_key": "KeVYLxn01Q3dbzKH2MksU0fmymsWw6X9xG407EV2",
	"game_id": "jamjam",
	"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://src/scenes/main_menu"
	})


func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("Settings", "mouse_sensitivity", mouse_sensitivity)
	config.set_value("Settings", "audio_volume", audio_volume)
	config.set_value("Settings", "music_volume", music_volume)
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		mouse_sensitivity = config.get_value("Settings", "mouse_sensitivity", 0.001)
		audio_volume = config.get_value("Settings", "audio_volume", 100)
		music_volume = config.get_value("Settings", "music_volume", 100)

