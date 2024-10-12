extends Control

@onready var label = $Label
@onready var animation_player = $AnimationPlayer  # Reference to the AnimationPlayer
@onready var background = $AnimationPlayer/TextureRect
@onready var crosshair = $"../Crosshair"


func _ready() -> void:
	Signalbus.connect("kill_player", call_death_screen)


func call_death_screen():
		print("Death screen called")
		# Play the animation
		crosshair.hide()
		background.show()
		animation_player.play("YouDiedAnimation")
		# Connect to listen for the animation finished signal if you need to trigger something else afterward
		animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "YouDiedAnimation":
		background.hide()
		crosshair.show()
		get_tree().paused = false
		print("Animation finished!")
