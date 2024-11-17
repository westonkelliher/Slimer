extends RigidBody2D

@export var SPEED := 300.0
@export var ACC := 6000.0

func _physics_process(delta: float) -> void:
	handle_movement(delta)


func get_move_direction() -> Vector2:
	var move_dir := Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		move_dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		move_dir.x += 1.0
	if Input.is_action_pressed("move_up"):
		move_dir.y -= 1.0
	if Input.is_action_pressed("move_down"):
		move_dir.y += 1.0
	return move_dir.normalized()
	

func handle_movement(delta: float) -> void:
	var move_dir := get_move_direction()
	var current_dir := linear_velocity.normalized()
	# braking force
	apply_force(-current_dir*ACC)
	# running force
	var remaining_speed := SPEED - linear_velocity.length()
	apply_force(move_dir*(ACC + min(ACC, remaining_speed/delta)))
	
	
