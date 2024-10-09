extends Node3D

func _ready() -> void:
	Signalbus.test_signal.connect(_on_signal_test)

	Signalbus.emit_signal("test_signal", "test")
	

func _on_signal_test(text: String):
	print(text)
