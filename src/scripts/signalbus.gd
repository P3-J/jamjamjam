extends Node3D

#DONT DELETE

# Game specific
signal game_starts()

# Player specifics
signal kill_player()
signal player_wins()
signal pickaxe_grab()
signal player_in_hook_area()
signal player_in_boost()

# Others
signal make_lava_rise()

var final_time = 0
# sorry these are not signals

@onready var minutes : int = 0
@onready var seconds : int = 0
@onready var milliseconds : int = 0



## pure magic
