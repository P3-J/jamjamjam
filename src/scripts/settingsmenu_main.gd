extends Control

var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene
@onready var mouse_slider = $VBoxContainer/HBoxContainer/HSlider
@onready var mouse_value = $VBoxContainer/HBoxContainer/MouseValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_slider.value = Globalsettings.mouse_sensitivity / 0.01
	mouse_value.text = str(mouse_slider.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globalsettings.mouse_sensitivity = mouse_slider.value * 0.01
	mouse_value.text = str(mouse_slider.value)
	# If player presses ESC during settings menu then act same as back button
	if Input.is_action_just_pressed("pause"):
		Globalsettings.save_settings()
		get_tree().change_scene_to_packed(main_menu_scene)

func _on_back_pressed() -> void:
	Globalsettings.save_settings()
	get_tree().change_scene_to_packed(main_menu_scene)
