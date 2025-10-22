extends ItemList


var id_and_name = {}

func _ready():
	var names = get_scene_names("res://src/levels")
	add_names_to_list(names)

func get_scene_names(path: String) -> Array[String]:
	var names: Array[String] = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				var name = file_name.get_basename()
				names.append(name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: " + path)
	return names


func add_names_to_list(names: Array[String]):
	var i = 0
	for x in names:
		add_item(x, null, true)
		id_and_name[i] = x
		i += 1
		
func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	get_tree().change_scene_to_file("res://src/levels/" + id_and_name[index] + ".tscn")
	MenuManager.reset()
