class_name Main
extends Node

enum GameState {
	PLAYING,
	GAME_OVER,
}

const RETRY_ACTION := "ui_accept"

@export var mob_scene: PackedScene

var _current_state := GameState.PLAYING

@onready var _mob_spawn_location: PathFollow3D = $MobSpawnPath/MobSpawnLocation
@onready var _player: CharacterBody3D = $Player
@onready var _mob_timer: Timer = $MobTimer
@onready var _score_label: ScoreLabel = $UserInterface/ScoreLabel
@onready var _retry: ColorRect = $UserInterface/Retry
@onready var _language_button: LanguageButton = $UserInterface/LanguageButton

# For debugging: Uncomment this line to clear settings
# func _init() -> void:
# 	Settings.clear()


func _ready() -> void:
	_retry.hide()
	_score_label.show_score()

	_language_button.language_changed.connect(_on_language_changed)
	_language_button.error_reported.connect(_on_language_error)


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
	if event.is_action_pressed(RETRY_ACTION) and _current_state == GameState.GAME_OVER:
		_reset_game()


func _on_language_changed(_locale_code: String) -> void:
	_score_label.show_score()


func _on_language_error(message: String) -> void:
	push_warning("[Main] Language error: " + message)
	# _show_error_message(message)
