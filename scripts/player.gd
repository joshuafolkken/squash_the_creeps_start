extends CharacterBody3D

@export var speed := 14
@export var fall_acceleration := 75

var target_velocity := Vector3.ZERO

@onready var _pivot: Node3D = $Pivot


func _physics_process(delta: float) -> void:
	var input_direction := _get_input_direction()
	_update_target_velocity(input_direction, delta)
	velocity = target_velocity
	move_and_slide()


func _get_input_direction() -> Vector3:
	return (
		Vector3(
			Input.get_axis("move_left", "move_right"),
			0,
			Input.get_axis("move_forward", "move_back"),
		)
		. normalized()
	)


func _update_target_velocity(direction: Vector3, delta: float) -> void:
	if direction != Vector3.ZERO:
		_pivot.basis = Basis.looking_at(direction)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta
