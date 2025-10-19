extends Control

@onready var mouse_slider = $VBoxContainer/HBoxContainer/HSlider
@onready var mouse_value = $VBoxContainer/HBoxContainer/MouseValue
@onready var audio_slider = $VBoxContainer/HBoxContainer2/audioslider
@onready var audio_value = $VBoxContainer/HBoxContainer2/Audiovalue
@onready var music_slider = $VBoxContainer/HBoxContainer3/musicslider
@onready var music_value = $VBoxContainer/HBoxContainer3/Musicvalue

func _ready() -> void:
	hide()  # Start hidden
	mouse_slider.value = Globalsettings.mouse_sensitivity / 0.01
	mouse_value.text = str(mouse_slider.value)
	
	audio_slider.value = Globalsettings.audio_volume
	audio_value.text = str(audio_slider.value)
	
	music_slider.value = Globalsettings.music_volume
	music_value.text = str(music_slider.value)

func _process(_delta: float) -> void:
	# Update settings in real time
	Globalsettings.mouse_sensitivity = mouse_slider.value * 0.01
	mouse_value.text = str(mouse_slider.value)
	Globalsettings.audio_volume = audio_slider.value
	audio_value.text = str(audio_slider.value)
	Globalsettings.music_volume = music_slider.value
	music_value.text = str(music_slider.value)

	# Close menu if player presses pause
	if Input.is_action_just_pressed("pause"):
		MenuManager.back()
		Globalsettings.save_settings()

# BACK BUTTON
func _on_back_pressed() -> void:
	Globalsettings.save_settings()
	MenuManager.back()
