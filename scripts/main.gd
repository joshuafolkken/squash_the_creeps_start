class_name Main
extends Node

@export var mob_scene: PackedScene

@onready var _version_label: Label = $VersionLabel
@onready var _mob_spawn_location: PathFollow3D = $MobSpawnPath/MobSpawnLocation
@onready var _player: CharacterBody3D = $Player
@onready var _mob_timer: Timer = $MobTimer


func _ready() -> void:
	_version_label.text = ProjectSettings.get_setting("application/config/version")

	_init_test_color_rect()


func _init_test_color_rect() -> void:
	var test_color_rect := ColorRect.new()
	test_color_rect.name = "test_color_rect"
	add_child(test_color_rect)


func _spawn_mob() -> void:
	var mob: Mob = mob_scene.instantiate()
	_mob_spawn_location.progress_ratio = randf()
	mob.initialize(_mob_spawn_location.position, _player.position)
	add_child(mob)


func _on_mob_timer_timeout() -> void:
	_spawn_mob()


func _on_player_hit() -> void:
	_mob_timer.stop()
