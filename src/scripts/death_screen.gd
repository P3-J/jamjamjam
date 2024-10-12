extends Control

@onready var animation_player = $AnimationPlayer
@onready var death_timer = $"../../utils/death_timer"
@onready var crosshair = $"../Crosshair"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))
	Signalbus.connect("kill_player", _death_called)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _death_called():
	crosshair.hide()
	Globalsettings.input_disabled = true
	animation_player.active = true
	get_tree().paused = true
	animation_player.play("DeathScreenAnimation")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _on_death_timer_timeout() -> void:
	pass # Replace with function body.
	

func _on_animation_finished(anim_name: String):
	if anim_name == "DeathScreenAnimation":
		Globalsettings.input_disabled = false
		get_tree().paused = false
		get_tree().reload_current_scene()
		print("Animation is finished!")
