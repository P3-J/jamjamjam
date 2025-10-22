extends Control

var main_menu_scene = ResourceLoader.load("res://src/scenes/UI/main_menu.tscn") as PackedScene

@onready var settings = $"../SettingsMenu"
@onready var pause_menu_buttons = $VBoxContainer

func _ready() -> void:
	hide()  # Start hidden

func _process(_delta: float) -> void:
	if !Globalsettings.input_disabled:
		if Input.is_action_just_pressed("pause"):
			if visible:
				_close_pause_menu()
			else:
				_open_pause_menu()
	else:
		if Input.is_action_just_pressed("pause"):
			_reset_game_state()

func _open_pause_menu() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	MenuManager.open(self)

func _close_pause_menu() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	MenuManager.reset()

func _reset_game_state() -> void:
	Globalsettings.input_disabled = false
	get_tree().paused = false
	get_tree().reload_current_scene()


# BUTTON CALLBACKS
func _on_start_button_pressed() -> void:
	_close_pause_menu()

func _on_settings_button_pressed() -> void:
	MenuManager.open(settings)

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	MenuManager.reset()
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_respawn_button_pressed() -> void:
	get_tree().paused = false
	MenuManager.reset()
	get_tree().reload_current_scene()
