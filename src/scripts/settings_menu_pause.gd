extends Control

var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene
@onready var mouse_slider = $VBoxContainer/HBoxContainer/HSlider
@onready var mouse_value = $VBoxContainer/HBoxContainer/MouseValue
@onready var pause_menu_buttons = $"../VBoxContainer"
@onready var settings = $"."

@onready var audio_slider = $VBoxContainer/HBoxContainer2/audioslider
@onready var audio_value = $VBoxContainer/HBoxContainer2/Audiovalue

@onready var music_slider = $VBoxContainer/HBoxContainer3/musicslider
@onready var music_value = $VBoxContainer/HBoxContainer3/Musicvalue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_slider.value = Globalsettings.mouse_sensitivity / 0.01
	mouse_value.text = str(mouse_slider.value)
	
	audio_slider.value = Globalsettings.audio_volume
	audio_value.text = str(audio_slider.value)
	
	music_slider.value = Globalsettings.music_volume
	music_value.text = str(music_slider.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Mouse
	Globalsettings.mouse_sensitivity = mouse_slider.value * 0.01
	mouse_value.text = str(mouse_slider.value)
	# Audio
	Globalsettings.audio_volume = audio_slider.value
	audio_value.text = str(audio_slider.value)
	# Music
	Globalsettings.music_volume = music_slider.value
	music_value.text = str(music_slider.value)
	# If player presses ESC during settings menu then act same as back button
	if Input.is_action_just_pressed("pause"):
		pause_menu_buttons.show()
		settings.hide()
		Globalsettings.save_settings()

func _on_back_pressed() -> void:
	pause_menu_buttons.show()
	settings.hide()
	Globalsettings.save_settings()


func _on_audioslider_value_changed(value: float) -> void:
	pass # Replace with function body.
