extends CharacterBody2D

@export var SPEED := 200.0
@export var ACC := 1300.0
@export var SPRITE_SCALE := 2.0

var move_velocity := Vector2.ZERO
var attack_velocity := Vector2.ZERO 

enum Dir {Up, Down, Left, Right}
var dir := Dir.Down
enum AtkDir {Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight}

enum State {Still, Straight, Diagonal, Windup, Swing, Recovery}
var state := State.Still
var is_attacking := false

func _physics_process(delta: float) -> void:
	check_for_attack_start()
	handle_movement(delta)
	#TODO: handle_attack_movement()
	apply_forces(delta)

func apply_forces(delta: float) -> void:
	position += move_velocity*delta

func check_for_attack_start() -> void:
	var atk_dir := get_attack_direction()
	if Input.is_action_just_pressed("main_attack"):
		match atk_dir:
			AtkDir.Up:
				$Sprite.play("slashing_up")
			AtkDir.Down:
				$Sprite.play("slashing_down")
			AtkDir.Left:
				$Sprite.play("slashing_side")
			AtkDir.Right:
				$Sprite.play("slashing_side")
			AtkDir.UpLeft:
				$Sprite.play("jab_up")
			AtkDir.UpRight:
				$Sprite.play("jab_up")
			AtkDir.DownLeft:
				$Sprite.play("jab_down")
			AtkDir.DownRight:
				$Sprite.play("jab_down")
		#
		if is_atk_dir_left(atk_dir):
			$Sprite.scale.x = -SPRITE_SCALE
		else:
			$Sprite.scale.x = SPRITE_SCALE
		#
		if is_atk_dir_diagonal(atk_dir):
			move_velocity *= 1.5
		else:
			move_velocity *= 0.25
		#
		is_attacking = true

func is_atk_dir_left(ad: AtkDir) -> bool:
	return (ad == AtkDir.Left or ad == AtkDir.UpLeft or ad == AtkDir.DownLeft)
func is_atk_dir_diagonal(ad: AtkDir) -> bool:
	return (ad == AtkDir.UpLeft or ad == AtkDir.DownLeft or ad == AtkDir.UpRight or ad == AtkDir.DownRight)

func get_attack_direction() -> AtkDir:
	var move_vec := get_move_vector()
	if move_vec.x > 0:
		if move_vec.y > 0:
			return AtkDir.DownRight
		elif move_vec.y < 0:
			return AtkDir.UpRight
		else:
			return AtkDir.Right
	elif move_vec.x < 0:
		if move_vec.y > 0:
			return AtkDir.DownLeft
		elif move_vec.y < 0:
			return AtkDir.UpLeft
		else:
			return AtkDir.Left
	else:
		if move_vec.y > 0:
			return AtkDir.Down
		elif move_vec.y < 0:
			return AtkDir.Up
		else:
			# TODO: soft attack directions (spin attack?)
			return move_dir_to_attack_dir()
			

func move_dir_to_attack_dir() -> AtkDir:
	match get:
		Dir.Up:
			return AtkDir.Up
		Dir.Down:
			return AtkDir.Down
		Dir.Left:
			return AtkDir.Left
		Dir.Right:
			return AtkDir.Right
	return AtkDir.Down


func get_move_vector() -> Vector2:
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
	var move_vec := get_move_vector()
	var current_dir := velocity.normalized()
	var acc := ACC
	var speed := SPEED
	#if is_attacking:
		#acc *= 0.5
		#speed *= 2.0
	move_velocity = move_velocity.move_toward(move_vec*speed, acc*delta)
	choose_animation(move_vec)

func choose_animation(direction: Vector2) -> void:
	if is_attacking:
		return
	#
	if direction.x > 0:
		dir = Dir.Right
		$Sprite.play("walking_side")
	elif direction.x < 0:
		dir = Dir.Left
		$Sprite.play("walking_side")
	elif direction.y > 0:
		dir = Dir.Down
		$Sprite.play("walking_down")
	elif direction.y < 0:
		dir = Dir.Up
		$Sprite.play("walking_up")
	else:
		if dir == Dir.Up:
			$Sprite.play("resting_up")
		if dir == Dir.Down:
			$Sprite.play("resting_down")
		else:
			$Sprite.play("resting_side")
	#
	if dir == Dir.Left:
		$Sprite.scale.x = -SPRITE_SCALE
	else:
		$Sprite.scale.x = SPRITE_SCALE


func _on_sprite_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
