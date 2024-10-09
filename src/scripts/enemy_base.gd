extends CharacterBody3D
class_name EnemyBase

@onready var body: MeshInstance3D = get_node("enemybodybase")

func _ready() -> void:
	set_color()

func set_color() -> void:
	body.material_override.set("albedo_color", "#ff783b")

func die() -> void:
	self.queue_free()
	
	
