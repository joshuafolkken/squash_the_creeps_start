class_name PlayerInput
extends Node


static func get_movement_direction() -> Vector3:
	return (
		Vector3(
			Input.get_axis("move_left", "move_right"),
			0,
			Input.get_axis("move_forward", "move_back"),
		)
		. normalized()
	)


static func is_jump_triggered() -> bool:
	return Input.is_action_just_pressed("jump")
