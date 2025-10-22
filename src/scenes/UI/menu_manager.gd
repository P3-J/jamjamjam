extends Node
class_name Menu_manager

# Stack of currently opened menus
var stack: Array[Control] = []

# Open a menu
func open(menu: Control) -> void:
	if stack.size() > 0:
		stack.back().hide()  # Hide previous menu
	stack.append(menu)
	menu.show()

# Go back to the previous menu
func back() -> void:
	if stack.size() > 1:
		var closing = stack.pop_back()
		closing.hide()
		stack.back().show()

# Close all menus
func reset() -> void:
	for m in stack:
		m.hide()
	stack.clear()
