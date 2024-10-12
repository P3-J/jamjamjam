extends Control

var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene

@onready var settings = $SettingsMenu
@onready var pause_menu_buttons = $VBoxContainer
@onready var crosshair = $"../Crosshair"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_mode = Input.get_mouse_mode()
	
	match mouse_mode:
		Input.MOUSE_MODE_VISIBLE:
			print("Mouse Mode: VISIBLE")
		Input.MOUSE_MODE_HIDDEN:
			print("Mouse Mode: HIDDEN")
		Input.MOUSE_MODE_CAPTURED:
			print("Mouse Mode: CAPTURED")
		Input.MOUSE_MODE_CONFINED:
			print("Mouse Mode: CONFINED")
			
	if !Globalsettings.input_disabled:
		if Input.is_action_just_pressed("pause"):
			if visible:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				crosshair.show()
				hide()
				get_tree().paused = false
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_tree().paused = true
				crosshair.hide()
				show()
	if Globalsettings.input_disabled:
		if Input.is_action_just_pressed("pause"):
				crosshair.show()
				Globalsettings.input_disabled = false
				get_tree().paused = false
				get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	crosshair.show()
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_respawn_button_pressed() -> void:
	crosshair.show()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_start_button_pressed() -> void:
	crosshair.show()
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_settings_button_pressed() -> void:
	pause_menu_buttons.hide()
	settings.show()
