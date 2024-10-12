extends Node3D

@export var time_to_start: float = 2.0  # You can change this value as needed

var timer: Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_and_start_timer()


func add_and_start_timer() -> void:
	# Create a new Timer node
	timer = Timer.new()

	# Set the wait time and one-shot property (for single use)
	timer.wait_time = time_to_start
	timer.one_shot = true

	# Add the timer as a child of the current node (so it's part of the scene tree)
	add_child(timer)

	# Connect the timeout signal of the timer to the function that will handle the timeout
	timer.timeout.connect(_on_timer_timeout)

	# Start the timer
	timer.start()


func _on_timer_timeout() -> void:
	Signalbus.emit_signal('game_starts')
	Signalbus.emit_signal('make_lava_rise')
