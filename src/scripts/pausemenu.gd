extends Control

var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene

@onready var settings = $SettingsMenu
@onready var pause_menu_buttons = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			show()
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_respawn_button_pressed() -> void:
	get_tree().paused = false
	Signalbus.respawn_called.emit()


func _on_start_button_pressed() -> void:
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_settings_button_pressed() -> void:
	pause_menu_buttons.hide()
	settings.show()
