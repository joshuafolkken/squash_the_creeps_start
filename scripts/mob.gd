extends CharacterBody3D

const DIRECTION_RANDOM_ANGLE = PI / 4

@export_range(1, 50) var min_speed := 10
@export_range(1, 50) var max_speed := 18


func _physics_process(_delta: float) -> void:
	move_and_slide()


func initialize(spawn_position: Vector3, target_position: Vector3) -> void:
	position = spawn_position
	_set_initial_direction(target_position)
	_set_initial_speed()


func _set_initial_direction(target_position: Vector3) -> void:
	look_at(target_position, Vector3.UP)
	rotate_y(randf_range(-DIRECTION_RANDOM_ANGLE, DIRECTION_RANDOM_ANGLE))


func _set_initial_speed() -> void:
	var speed := randi_range(min_speed, max_speed)
	var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	velocity = direction * speed


func _on_visible_on_screen_enabler_3d_screen_exited() -> void:
	queue_free()
