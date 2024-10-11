extends Control

var game_scene =  ResourceLoader.load("res://src/scenes/world.tscn") as PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(game_scene)
