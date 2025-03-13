class_name Main
extends Node

enum GameState {
	PLAYING,
	GAME_OVER,
}

@export var mob_scene: PackedScene

var _current_state := GameState.PLAYING

@onready var _mob_spawn_location: PathFollow3D = $MobSpawnPath/MobSpawnLocation
@onready var _player: CharacterBody3D = $Player
@onready var _mob_timer: Timer = $MobTimer
@onready var _score_label: ScoreLabel = $UserInterface/ScoreLabel
@onready var _retry: ColorRect = $UserInterface/Retry


func _ready() -> void:
	_retry.hide()


func _spawn_mob() -> void:
	if not mob_scene:
		push_error("mob_scene is not available")
		return

	var mob: Mob = mob_scene.instantiate()
	_mob_spawn_location.progress_ratio = randf()
	mob.initialize(_mob_spawn_location.position, _player.position)
	add_child(mob)

	mob.squashed.connect(_score_label.on_mob_squashed)


func _on_mob_timer_timeout() -> void:
	_spawn_mob()


func _on_player_hit() -> void:
	_current_state = GameState.GAME_OVER
	_mob_timer.stop()
	_retry.show()


func _reset_game() -> void:
	get_tree().reload_current_scene()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if _current_state == GameState.GAME_OVER:
			_reset_game()
