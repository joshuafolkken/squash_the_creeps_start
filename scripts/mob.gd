class_name Mob
extends CharacterBody3D

signal squashed

const DIRECTION_RANDOM_ANGLE := PI / 4

const SPEED_LIMITS = {
	MIN = 1,
	MAX = 50,
	DEFAULT_MIN = 10,
	DEFAULT_MAX = 18,
}

@export_range(SPEED_LIMITS.MIN, SPEED_LIMITS.MAX) var min_speed := SPEED_LIMITS.DEFAULT_MIN
@export_range(SPEED_LIMITS.MIN, SPEED_LIMITS.MAX) var max_speed := SPEED_LIMITS.DEFAULT_MAX


func _physics_process(_delta: float) -> void:
	move_and_slide()


func initialize(spawn_position: Vector3, player_position: Vector3) -> void:
	_init_position_and_rotation(spawn_position, player_position)
	_init_velocity()


func _init_position_and_rotation(start_position: Vector3, target_position: Vector3) -> void:
	look_at_from_position(start_position, target_position, Vector3.UP)
	rotate_y(randf_range(-DIRECTION_RANDOM_ANGLE, DIRECTION_RANDOM_ANGLE))


func _init_velocity() -> void:
	var speed := randi_range(min_speed, max_speed)
	var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	velocity = direction * speed


func _on_visible_on_screen_enabler_3d_screen_exited() -> void:
	queue_free()


func squash() -> void:
	squashed.emit()
	queue_free()
