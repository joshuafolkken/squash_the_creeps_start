extends GdUnitTestSuite

const MAIN_SCENE_PATH := "res://scenes/main.tscn"

var _runner: GdUnitSceneRunner


func before_test() -> void:
	_runner = scene_runner(MAIN_SCENE_PATH)


func test_example() -> void:
	var color_rect: ColorRect = _runner.find_child("test_color_rect")
	assert_object(color_rect.color).is_equal(Color.WHITE)


func test_version_label() -> void:
	var version_label: Label = _runner.find_child("VersionLabel")
	assert_str(version_label.text).is_not_null()
