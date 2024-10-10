extends EnemyBase
class_name EnemyGreen


# can call die, just like polymorphism ;)
func _ready() -> void:
	set_color()
	return
	die()

# writing over parent class
func set_color() -> void:
	body.material_override.set("albedo_color", "#278400")
