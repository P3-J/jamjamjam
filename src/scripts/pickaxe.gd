extends Node3D
@onready var pickaxe_animation_player: AnimationPlayer = $PickaxeAnimationPlayer
var boost_anim_playing = false
@onready var boost_particles: GPUParticles3D = $BoostParticles

func _ready() -> void:
	play_idle_animation()

func play_idle_animation() -> void:
	if not boost_anim_playing:
		pickaxe_animation_player.play("idle")
	
func play_run_animation() -> void:
	if not boost_anim_playing:
		pickaxe_animation_player.play("run")

func play_jump_animation() -> void:
	if not boost_anim_playing:
		pickaxe_animation_player.play("jump")

func play_boost_animation() -> void:
	boost_anim_playing = true
	pickaxe_animation_player.play("boost")

func no_animation() -> void:
	if not boost_anim_playing:
		pickaxe_animation_player.play("RESET")

func _on_pickaxe_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boost":
		boost_anim_playing = false
		boost_particles.emitting = true
