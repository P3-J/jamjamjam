extends Control

@onready var mouse_slider = $VBoxContainer/HBoxContainer/HSlider
@onready var mouse_value = $VBoxContainer/HBoxContainer/MouseValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_slider.value = Globalsettings.mouse_sensitivity
	mouse_value.text = str(Globalsettings.mouse_sensitivity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globalsettings.mouse_sensitivity = mouse_slider.value
	mouse_value.text = str(Globalsettings.mouse_sensitivity)
	Globalsettings.save_settings()
