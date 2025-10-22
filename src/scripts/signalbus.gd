extends Node3D

#DONT DELETE
signal settings_changed()

# Game specific
signal game_starts()

# Player specifics
signal kill_player()
signal player_wins()
signal pickaxe_grab(is_grabbed: bool)
signal player_in_hook_area()
signal player_in_boost()

#region Audio SFX
signal play_death_sound()
signal play_pickaxe_throw_sound()
signal play_pickaxe_hooked_sound()
signal play_pickaxe_boost_sound()
signal play_rope_pull_sound(is_pulling: bool)
signal play_geyser_woosh()
signal play_lava_rise_sound(distance: float)
signal play_lava_hiss_sound(distance: float)
signal play_ring_boost_sound()
signal play_jump_sound()
signal play_dwarf_death_sound()
signal play_dwarf_laugh_win_sound()
signal _dont_play_sounds_on_reload()
#endregion

# Others
signal make_lava_rise()

var final_time = 0
# sorry these are not signals

@onready var minutes : int = 0
@onready var seconds : int = 0
@onready var milliseconds : int = 0



## pure magic
