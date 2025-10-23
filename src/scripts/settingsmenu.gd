extends Control

@onready var mouse_slider = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer/HSlider
@onready var mouse_value = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer/MouseValue
@onready var audio_slider = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer2/audioslider
@onready var audio_value = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer2/Audiovalue
@onready var music_slider = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer3/musicslider
@onready var music_value = $TextureRect/HBoxContainer/HBoxContainer/HBoxContainer3/Musicvalue

signal settings_changed()

func _ready() -> void:
	hide()
	
	mouse_slider.value = Globalsettings.mouse_sensitivity / 0.01
	mouse_value.text = str(mouse_slider.value)
	mouse_slider.value_changed.connect(_on_mouse_changed)

	audio_slider.value = Globalsettings.audio_volume
	audio_value.text = str(audio_slider.value)
	audio_slider.value_changed.connect(_on_audio_changed)

	music_slider.value = Globalsettings.music_volume
	music_value.text = str(music_slider.value)
	music_slider.value_changed.connect(_on_music_changed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		MenuManager.back()
		Globalsettings.save_settings()


func _on_mouse_changed(value: float) -> void:
	Globalsettings.mouse_sensitivity = value * 0.01
	mouse_value.text = str(value)
	Signalbus.settings_changed.emit()

func _on_audio_changed(value: float) -> void:
	Globalsettings.audio_volume = value
	audio_value.text = str(value)
	Signalbus.settings_changed.emit()

func _on_music_changed(value: float) -> void:
	Globalsettings.music_volume = value
	music_value.text = str(value)
	Signalbus.settings_changed.emit()


# BACK BUTTON
func _on_back_pressed() -> void:
	Globalsettings.save_settings()
	MenuManager.back()

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		# Go fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		# Go back to windowed
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
