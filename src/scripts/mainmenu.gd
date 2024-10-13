extends Control

var settings_scene = ResourceLoader.load("res://src/scenes/settings_menu_main.tscn") as PackedScene
var game_scene =  ResourceLoader.load("res://src/scenes/world.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_leaderboard_connection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _setup_leaderboard_connection():
	SilentWolf.configure({
	"api_key": "KeVYLxn01Q3dbzKH2MksU0fmymsWw6X9xG407EV2",
	"game_id": "jamjam",
	"log_level": 1
	})

	SilentWolf.configure_scores({
		"open_scene_on_close": "res://src/scenes/main_menu"
	})


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(game_scene)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_packed(settings_scene)
