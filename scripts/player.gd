extends CharacterBody3D

const GRAVITY_ACCELERATION := 75.0
const DEFAULT_SPEED = 14.0

@export var fall_acceleration := GRAVITY_ACCELERATION
@export var speed := DEFAULT_SPEED

var _target_velocity := Vector3.ZERO

@onready var _pivot: Node3D = $Pivot


func _physics_process(delta: float) -> void:
	var input_direction := PlayerInput.get_movement_direction()
	_update_target_velocity(input_direction, delta)
	velocity = _target_velocity
	move_and_slide()


func _update_target_velocity(direction: Vector3, delta: float) -> void:
	if direction != Vector3.ZERO:
		_pivot.basis = Basis.looking_at(direction)

	_target_velocity.x = direction.x * speed
	_target_velocity.z = direction.z * speed

	if not is_on_floor():
		_target_velocity.y -= fall_acceleration * delta
