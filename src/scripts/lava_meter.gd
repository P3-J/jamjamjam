extends Control

@onready var lava_meter = $LavaMeter
@onready var player_indicator = $PlayerPos
var lava
var player
var min_height = -30
var max_height = 45

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var nodes = get_tree().get_root().get_node('world')
	nodes = nodes.get_children()
	for node in nodes:
		if node.name == 'Lava':
			lava = node 
		if node.name == 'controllableCharacters':
			player = node.get_node('player')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var lava_height = lava.global_transform.origin.y - min_height
	var player_height = player.global_transform.origin.y - min_height

	var lava_percentage = round((lava_height / (max_height - min_height)) * 10000) / 100
	lava_meter.value = lava_percentage

	var player_percentage = round((player_height / (max_height - min_height)) * 10000) / 100

	var max_pos = lava_meter.position.y
	var min_pos = max_pos + lava_meter.size.y
	player_indicator.position.y = min_pos - (((min_pos - max_pos) / 100) * (player_percentage))
	player_indicator.position.y -= 26
