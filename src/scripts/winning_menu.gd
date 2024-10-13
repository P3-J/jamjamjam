extends Control

var game_scene =  ResourceLoader.load("res://src/scenes/world.tscn") as PackedScene
var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene

func _ready():
	Signalbus.connect('player_wins', _show_winning_screen)

func _process(_delta: float) -> void:
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		

func _show_winning_screen() -> void:
	visible = true
	get_tree().paused = true

func _on_restart_pressed() -> void:
	visible = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(game_scene)

func _on_back_to_main_pressed() -> void:
	visible = false
	get_tree().change_scene_to_packed(main_menu_scene)
