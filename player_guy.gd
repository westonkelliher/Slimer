extends CharacterBody2D

@export var SPEED := 300.0
@export var ACC := 3000.0
@export var SPRITE_SCALE := 3.0

enum Direction {Up, Down, Left, Right}
var direction := Direction.Down

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	apply_forces(delta)

func apply_forces(delta: float) -> void:
	position += velocity*delta

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
	var current_dir := velocity.normalized()
	velocity = velocity.move_toward(move_dir*SPEED, ACC*delta)
	choose_animation(move_dir)

func choose_animation(dir: Vector2) -> void:
	if dir.x > 0:
		direction = Direction.Right
		$Sprite.play("walking_side")
	elif dir.x < 0:
		direction = Direction.Left
		$Sprite.play("walking_side")
	elif dir.y > 0:
		direction = Direction.Down
		$Sprite.play("walking_down")
	elif dir.y < 0:
		direction = Direction.Up
		$Sprite.play("walking_up")
	else:
		if direction == Direction.Up:
			$Sprite.play("resting_up")
		if direction == Direction.Down:
			$Sprite.play("resting_down")
		else:
			$Sprite.play("resting_side")
			
	#
	if direction == Direction.Left:
		$Sprite.scale.x = -SPRITE_SCALE
	else:
		$Sprite.scale.x = SPRITE_SCALE
		
		
		
