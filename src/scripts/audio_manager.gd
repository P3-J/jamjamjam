extends Node

@onready var main_music = $MainMusic
@onready var death_sound = $DeathSound
@onready var pickaxe_sound = $PickAxeGrab
@onready var pickaxe_throw: AudioStreamPlayer = $PickaxeThrow
@onready var pickaxe_hooked: AudioStreamPlayer = $PickaxeHooked
@onready var pickaxe_boost_hit: AudioStreamPlayer = $PickaxeBoostHit
@onready var rope_pull: AudioStreamPlayer = $RopePull
@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var geyser_woosh: AudioStreamPlayer = $GeyserWoosh
@onready var boiling_lava: AudioStreamPlayer = $BoilingLava
@onready var lava_hiss: AudioStreamPlayer = $LavaHiss
@onready var dwarf_death: AudioStreamPlayer = $DwarfDeath
@onready var jump: AudioStreamPlayer = $Jump
@onready var ring_boost: AudioStreamPlayer = $RingBoost

@export var _lava_hiss_interval: float = 2.0

var is_rope_pull_playing: bool = false
var _lava_hiss_accum: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signalbus.connect('game_starts', _start_main_music)
	Signalbus.connect('kill_player', _play_death_sound)
	Signalbus.connect('pickaxe_grab', _play_pickaxe_grab_sound)
	Signalbus.connect('play_pickaxe_throw_sound', _play_pickaxe_throw_sound)
	Signalbus.connect('play_pickaxe_hooked_sound', _play_pickaxe_hooked_sound)
	Signalbus.connect('play_pickaxe_boost_sound', _play_pickaxe_boost_hit_sound)
	Signalbus.connect('play_rope_pull_sound', _play_rope_pull_sound)
	Signalbus.connect('make_lava_rise', _play_background_music)
	Signalbus.connect('play_geyser_woosh', _play_geyser_woosh)
	Signalbus.connect('play_lava_rise_sound', _play_lava_rise_sound)
	Signalbus.connect('play_lava_hiss_sound', _play_lava_hiss_sound)
	Signalbus.connect('play_dwarf_death_sound', _play_dwarf_death_sound)
	Signalbus.connect('play_jump_sound', _play_jump_sound)
	Signalbus.connect('play_ring_boost_sound', _play_ring_boost_sound)
	Signalbus.connect('_dont_play_sounds_on_reload', _on_dont_play_sounds_on_reload)
	# seed RNG so randi() is different each run
	randomize()

func _process(delta: float) -> void:
	# roll a number between 0 and 20 every second and decide whether to play the lava hiss sound
	_lava_hiss_accum += delta
	if _lava_hiss_accum >= _lava_hiss_interval:
		_lava_hiss_accum = 0.0
		# don't retrigger while it's playing
		if not lava_hiss.playing:
			var rand = randi() % 20
			if rand <= 2:
				lava_hiss.pitch_scale = randf_range(0.8, 1.2)
				lava_hiss.play()

func _start_main_music() -> void:
	main_music.play()

func _play_death_sound() -> void:
	death_sound.play()

func _play_pickaxe_grab_sound(is_grabbed: bool) -> void:
	pickaxe_hooked.playing = is_grabbed

func _play_pickaxe_throw_sound() -> void:
	pickaxe_throw.pitch_scale = randf_range(0.8, 1.2)
	pickaxe_throw.play()

func _play_pickaxe_hooked_sound() -> void:
	pickaxe_hooked.playing = true

func _play_pickaxe_boost_hit_sound() -> void:
	pickaxe_boost_hit.pitch_scale = randf_range(0.8, 1.2)
	pickaxe_boost_hit.play()

func _play_rope_pull_sound(is_pulling: bool) -> void:
	if !is_rope_pull_playing:
		rope_pull.playing = is_pulling
		is_rope_pull_playing = is_pulling

func _play_background_music() -> void:
	background_music.playing = true

func _on_rope_pull_finished() -> void:
	is_rope_pull_playing = false

func _play_geyser_woosh() -> void:
	geyser_woosh.play()

func _play_lava_rise_sound(distance: float) -> void:
	var volume_db = clamp(-distance, -40, 0)
	boiling_lava.volume_db = volume_db

func _play_lava_hiss_sound(distance: float) -> void:
	var volume_db = clamp(-distance * 1.5, -40, 0)
	lava_hiss.volume_db = volume_db

func _play_dwarf_death_sound() -> void:
	dwarf_death.pitch_scale = randf_range(0.8, 1.2)
	dwarf_death.play()

func _play_jump_sound() -> void:
	jump.pitch_scale = randf_range(0.9, 1.1)
	jump.play()

func _play_ring_boost_sound() -> void:
	ring_boost.pitch_scale = randf_range(0.8, 1.2)
	ring_boost.play()

func _on_dont_play_sounds_on_reload() -> void:
	# Stop all sounds to prevent them from playing on scene reload
	main_music.stop()
	death_sound.stop()
	pickaxe_sound.stop()
	pickaxe_throw.stop()
	pickaxe_hooked.stop()
	pickaxe_boost_hit.stop()
	rope_pull.stop()
	background_music.stop()
	geyser_woosh.stop()
	boiling_lava.stop()
	lava_hiss.stop()
	dwarf_death.stop()
	jump.stop()
	ring_boost.stop()
