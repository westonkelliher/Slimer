extends CharacterBody2D

@export var SPEED := 300.0
@export var ACC := 2000.0
@export var SPRITE_SCALE := 3.0

var move_velocity := Vector2.ZERO
var attack_velocity := Vector2.ZERO 

enum Dir {Up, Down, Left, Right}
var dir := Dir.Down
enum AtkDir {Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight}
var atk_dir := Dir.Down

enum State {Still, Straight, Diagonal, Windup, Swing, Recovery}
var state := State.Still
var is_attacking := false

func _physics_process(delta: float) -> void:
	check_for_attack_start()
	handle_movement(delta)
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
		if atk_dir == AtkDir.Left or atk_dir == AtkDir.UpLeft or atk_dir == AtkDir.DownLeft:
			$Sprite.scale.x = -SPRITE_SCALE
		else:
			$Sprite.scale.x = SPRITE_SCALE
		is_attacking = true
		move_velocity *= 0.25

func get_attack_direction() -> AtkDir:
	var move_dir := get_move_direction()
	if move_dir.x > 0:
		if move_dir.y > 0:
			return AtkDir.DownRight
		elif move_dir.y < 0:
			return AtkDir.UpRight
		else:
			return AtkDir.Right
	elif move_dir.x < 0:
		if move_dir.y > 0:
			return AtkDir.DownLeft
		elif move_dir.y < 0:
			return AtkDir.UpLeft
		else:
			return AtkDir.Left
	else:
		if move_dir.y > 0:
			return AtkDir.Down
		elif move_dir.y < 0:
			return AtkDir.Up
		else:
			# TODO: soft attack directions (spin attack?)
			return move_dir_to_attack_dir()
			

func move_dir_to_attack_dir() -> AtkDir:
	match dir:
		Dir.Up:
			return AtkDir.Up
		Dir.Down:
			return AtkDir.Down
		Dir.Left:
			return AtkDir.Left
		Dir.Right:
			return AtkDir.Right
	return AtkDir.Down

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
	var acc := ACC
	if is_attacking:
		acc *= 0.5
	move_velocity = move_velocity.move_toward(move_dir*SPEED, acc*delta)
	choose_animation(move_dir)

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
