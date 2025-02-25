class_name Mob
extends CharacterBody3D

const DIRECTION_RANDOM_ANGLE := PI / 4
const MIN_SPEED_RANGE := 1
const MAX_SPEED_RANGE := 50
const MIN_DEFAULT_SPEED := 10
const MAX_DEFAULT_SPEED := 18

@export_range(MIN_SPEED_RANGE, MAX_SPEED_RANGE) var min_speed := MIN_DEFAULT_SPEED
@export_range(MIN_SPEED_RANGE, MAX_SPEED_RANGE) var max_speed := MAX_DEFAULT_SPEED


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
