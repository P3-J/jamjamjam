extends Node3D

@onready var onoff_timer = $onoff
@onready var particles = $particles

var player_body: Node3D;
var working = false;

func _on_boostarea_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_body = body
		if working:
			Signalbus.emit_signal("player_in_boost", true)


func _on_boostarea_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_body = null
		Signalbus.emit_signal("player_in_boost", false)


func _on_onoff_timeout() -> void:
	working = !working
	particles.emitting = working
	
	if !player_body:
		return
	
	if !working:
		Signalbus.emit_signal("player_in_boost", false)
		return
	Signalbus.emit_signal("player_in_boost", true)
	
