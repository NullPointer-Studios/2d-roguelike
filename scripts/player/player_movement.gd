class_name Player extends CharacterBody2D

#preloads the scene at compile time
const PROJECTILE_SCENE := preload("res://scenes/player/projectile.tscn")

@export var move_speed := 200.0

#0.25 seconds b/w shots if arrow is held (single-fire mode)
@export var fire_rate := 0.25

#burst mode setting
@export var burst_shot_count := 3
@export var burst_interval := 0.08
@export var burst_cooldown := 0.75

#shotgun mode setting
@export var shotgun_shot_count := 3
@export var shotgun_spread_deg := 30.0
@export var shotgun_cooldown := 0.6

enum FireMode { SINGLE, BURST, SHOTGUN }

#default fire mode
var current_mode: FireMode = FireMode.SINGLE

#allow user to shoot as soon as they load in
var _shoot_cooldown := 0.0

#direction is locked at burst start
var _burst_shots_remaining := 0
var _burst_next_shot_in := 0.0
var _burst_direction := Vector2.ZERO

func _ready():
	print("PLAYER SCRIPT READY")

func _physics_process(delta):
	var input_direction := Vector2.ZERO
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed
	move_and_slide()

	#selecting fire mode
	if Input.is_action_just_pressed("fire_mode_single"):
		current_mode = FireMode.SINGLE
	elif Input.is_action_just_pressed("fire_mode_burst"):
		current_mode = FireMode.BURST
	elif Input.is_action_just_pressed("fire_mode_shotgun"):
		current_mode = FireMode.SHOTGUN

	#shoot scripts
	_shoot_cooldown = max(_shoot_cooldown - delta, 0.0)

	#continue an in-progress burst regardless of input state
	if _burst_shots_remaining > 0:
		_burst_next_shot_in -= delta
		if _burst_next_shot_in <= 0.0:
			_spawn_projectile(_burst_direction.angle(), _burst_direction)
			_burst_shots_remaining -= 1
			_burst_next_shot_in = burst_interval

	var shoot_dir := _get_shoot_direction() #get direction being held
	#fire if arrow being held and the cooldown has reset
	if shoot_dir != Vector2.ZERO and _shoot_cooldown <= 0.0:
		match current_mode:
			FireMode.SINGLE:
				_fire_single(shoot_dir)
			FireMode.BURST:
				_fire_burst(shoot_dir)
			FireMode.SHOTGUN:
				_fire_shotgun(shoot_dir)

#note:no diagnoals so there is priority
func _get_shoot_direction() -> Vector2:
	if Input.is_action_pressed("shoot_up"): return Vector2.UP
	if Input.is_action_pressed("shoot_down"): return Vector2.DOWN
	if Input.is_action_pressed("shoot_left"): return Vector2.LEFT
	if Input.is_action_pressed("shoot_right"): return Vector2.RIGHT
	return Vector2.ZERO

func _fire_single(direction: Vector2):
	_spawn_projectile(direction.angle(), direction)
	_shoot_cooldown = fire_rate

func _fire_burst(direction: Vector2):
	_spawn_projectile(direction.angle(), direction)
	_burst_direction = direction
	_burst_shots_remaining = burst_shot_count - 1
	_burst_next_shot_in = burst_interval
	#cooldown spans the rest of the burst plus the post-burst pause
	_shoot_cooldown = (burst_shot_count - 1) * burst_interval + burst_cooldown

func _fire_shotgun(direction: Vector2):
	var base_angle := direction.angle()
	var spread_rad := deg_to_rad(shotgun_spread_deg)
	for i in shotgun_shot_count:
		var offset := 0.0
		if shotgun_shot_count > 1:
			var t := float(i) / float(shotgun_shot_count - 1)
			offset = lerp(-spread_rad * 0.5, spread_rad * 0.5, t)
		_spawn_projectile(base_angle + offset, direction)
	_shoot_cooldown = shotgun_cooldown

#spawn projectile traveling at angle_rad
func _spawn_projectile(angle_rad: float, spawn_dir: Vector2):
	var projectile := PROJECTILE_SCENE.instantiate() #create new projectile scene
	projectile.dir = angle_rad
	projectile.spawnPos = global_position + spawn_dir * 20 #spawn 20 pixels in front of player so its not inside lol
	get_parent().add_child(projectile) #the level is the parent; projectile and player are siblings
