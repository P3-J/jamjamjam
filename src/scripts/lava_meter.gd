extends Control

@onready var lava_meter = $LavaMeter
@onready var player_indicator = $PlayerPos
var exit: Node3D
var lava: Node3D
var player
var min_height = 0
var min_height_offset = -10
var max_height = 85

func _ready() -> void:
	lava = get_tree().get_first_node_in_group("lava")
	exit = get_tree().get_first_node_in_group("exit")

	assert(lava, "there is no node in group 'lava' in this level")
	assert(exit, "there is no node in group 'exit' in this level")

	min_height = lava.global_transform.origin.y + min_height_offset
	max_height = exit.global_transform.origin.y

func _process(_delta: float) -> void:
	
	if (!lava or !player or !exit):
		print("Missing lava, exit or player for the lava meter to function")
		return

	var lava_height = lava.global_transform.origin.y - min_height
	var player_height = player.global_transform.origin.y - min_height

	var lava_percentage = round((lava_height / (max_height - min_height)) * 10000) / 100
	lava_meter.value = lava_percentage

	var player_percentage = round((player_height / (max_height - min_height)) * 10000) / 100

	var max_pos = lava_meter.position.y
	var min_pos = max_pos + lava_meter.size.y
	player_indicator.position.y = min_pos - (((min_pos - max_pos) / 100) * (player_percentage))
	player_indicator.position.y -= 26
