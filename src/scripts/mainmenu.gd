extends Control

var settings_scene = ResourceLoader.load("res://src/scenes/settings_menu_main.tscn") as PackedScene

@onready var animation = $"../start"
@onready var animation_colorect = $"../start/ColorRect"
@onready var animation_label = $"../start/ColorRect/Label"
@onready var settings = $"../SettingsMenu"
@onready var level_selector: Control = $"../levelselector"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuManager.open(self)
	while !Globalsettings.splash_screen_called:
		Globalsettings.splash_screen_called = true
		animation.active = true
		animation.play("fade_in")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation.is_playing():
		if Input.is_action_just_pressed("pause"):
			animation.stop()
			animation.active = false
			animation_colorect.hide()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_play_pressed() -> void:
	MenuManager.open(level_selector)


func _on_settings_pressed() -> void:
	MenuManager.open(settings)
