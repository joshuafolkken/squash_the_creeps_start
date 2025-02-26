# gdlint: disable=unused-argument

extends GdUnitTestSuite

const MAIN_SCENE_PATH := "res://scenes/main.tscn"

var _runner: GdUnitSceneRunner
var _main_scene: Main


func before_test() -> void:
	_runner = scene_runner(MAIN_SCENE_PATH)
	_main_scene = _runner.scene()


func _simulate_action_press(action: String) -> void:
	_runner.simulate_action_press(action)
	await _runner.await_input_processed()
	_runner.simulate_action_release(action)


@warning_ignore("unused_parameter")


func test_movement(
	action: String,
	axis: String,
	increases: bool,
	test_parameters := [
		["move_left", "x", false],
		["move_right", "x", true],
		["move_forward", "z", false],
		["move_back", "z", true],
	]
) -> void:
	var player := _main_scene._player
	var initial_position := player.position

	await _simulate_action_press(action)

	var final_position := player.position
	var movement_delta := final_position[axis] - initial_position[axis]

	if increases:
		assert_float(movement_delta).is_greater(0.0)
	else:
		assert_float(movement_delta).is_less(0.0)
