extends Node3D

var mouse_sensitivity: float
var input_enabled: bool = true

# File path to save settings
const SETTINGS_PATH = "user://settings.cfg"

func _ready() -> void:
	load_settings()  # Load settings when the game starts

# Method to save settings to a file
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("Settings", "mouse_sensitivity", mouse_sensitivity)
	config.save(SETTINGS_PATH)

# Method to load settings from a file
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		mouse_sensitivity = config.get_value("Settings", "mouse_sensitivity", 0.001)  # Default to 0.01 if not set
