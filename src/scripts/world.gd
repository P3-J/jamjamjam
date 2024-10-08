extends Node3D
@export var player: CharacterBody3D



func _ready() -> void:
	Signalbus.test_signal.connect(_on_signal_test)

	# instant signalbus access
	Signalbus.emit_signal("test_signal", "test")
	

func _on_signal_test(text: String):
	print(text)
