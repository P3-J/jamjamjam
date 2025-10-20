extends Area3D

@export var rise_per_sec: float = 1.0 

@onready var timer = $Timer

var is_rising: bool = false

func _ready() -> void:
	Signalbus.connect('make_lava_rise', _on_lava_start_rising)

func _process(delta: float) -> void:
	if is_rising:
		global_transform.origin.y += rise_per_sec * delta

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player'):
		Signalbus.emit_signal('kill_player')

func _on_lava_start_rising() -> void:
	is_rising = true
