extends CharacterBody3D

signal hit

const THRESHOLD_STOMP_NORMAL := 0.1

@export var speed := 14.0
@export var fall_acceleration := 75.0
@export var jump_impulse := 20
@export var bounce_impulse := 16

@onready var _pivot: Node3D = $Pivot
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var input_direction := PlayerInput.get_movement_direction()
	velocity = _calculate_velocity(input_direction, delta)
	move_and_slide()
	_pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func _calculate_velocity(direction: Vector3, delta: float) -> Vector3:
	var new_velocity := velocity

	new_velocity = _apply_movement(new_velocity, direction)
	new_velocity = _apply_gravity(new_velocity, delta)
	new_velocity = _apply_jump(new_velocity)
	new_velocity = _apply_collisions(new_velocity)

	return new_velocity


func _apply_movement(current_velocity: Vector3, direction: Vector3) -> Vector3:
	if direction != Vector3.ZERO:
		_pivot.basis = Basis.looking_at(direction)
		_animation_player.speed_scale = 4
	else:
		_animation_player.speed_scale = 1

	var result := current_velocity
	result.x = direction.x * speed
	result.z = direction.z * speed

	return result


func _apply_gravity(current_velocity: Vector3, delta: float) -> Vector3:
	var result := current_velocity

	if not is_on_floor():
		result.y -= fall_acceleration * delta

	return result


func _apply_jump(current_velocity: Vector3) -> Vector3:
	var result := current_velocity

	if is_on_floor() and PlayerInput.is_jump_triggered():
		result.y = jump_impulse

	return result


func _apply_collisions(current_velocity: Vector3) -> Vector3:
	var result := current_velocity

	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var collider: Node = collision.get_collider()

		if _is_stomping_mob(collider, collision):
			result = _bounce_on_mob(result, collider as Mob)

	return result


func _is_stomping_mob(collider: Node, collision: KinematicCollision3D) -> bool:
	return _is_mob_collision(collider) and _is_stomp_collision(collision)


func _is_mob_collision(collider: Node) -> bool:
	return collider is Mob and collider.is_in_group(GameConstants.GROUP_MOB)


func _is_stomp_collision(collision: KinematicCollision3D) -> bool:
	return Vector3.UP.dot(collision.get_normal()) > THRESHOLD_STOMP_NORMAL


func _bounce_on_mob(current_velocity: Vector3, mob: Mob) -> Vector3:
	mob.squash()

	var result := current_velocity
	result.y = bounce_impulse
	return result


func die() -> void:
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(_body: Node3D) -> void:
	die()
