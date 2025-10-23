extends Control

@export var next_scene_path: String
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/Label

func _ready() -> void:
	progress_bar.value = 0
	load_next_scene_async()

func load_next_scene_async() -> void:
	# Start threaded loading
	ResourceLoader.load_threaded_request(next_scene_path)

	var progress := []
	var status := ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS

	# Update progress bar until finished
	while status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
		if progress.size() > 0:
			progress_bar.value = progress[0] * 100.0
		await get_tree().process_frame  # Let UI update

	# When done
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		label.text = "Starting..."
		var scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		await get_tree().process_frame  # brief delay so "Starting..." can display
		get_tree().change_scene_to_packed(scene)
		MenuManager.reset()
		queue_free()
	else:
		label.text = "Error loading scene!"
		push_error("Failed to load scene: %s" % next_scene_path)
