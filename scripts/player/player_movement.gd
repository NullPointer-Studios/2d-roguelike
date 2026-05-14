extends CharacterBody2D

#preloads the scene at compile time 
const PROJECTILE_SCENE := preload("res://scenes/player/projectile.tscn")

@export var move_speed := 200.0

#0.25 seconds b/w shots if arrow is held
@export var fire_rate := 0.25

#allow user to shoot as soon as they load in
var _shoot_cooldown := 0.0

func _ready():
	print("PLAYER SCRIPT READY")

func _physics_process(delta):
	var input_direction := Vector2.ZERO
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed
	#print("input:", input_direction, " velocity:", velocity, " position:", position)
	move_and_slide()

	#shoot scripts
	_shoot_cooldown = max(_shoot_cooldown - delta, 0.0)
	var shoot_dir := _get_shoot_direction() #get direction being held
	#fire if arrow being held and the cooldown has reset
	if shoot_dir != Vector2.ZERO and _shoot_cooldown <= 0.0:
		_shoot(shoot_dir)
		_shoot_cooldown = fire_rate #reset the cooldown --> user must wait before next shot

#note: no diagnoals so there is priority (up > down > left > right) if pressed in tandem
func _get_shoot_direction() -> Vector2:
	# `Vector2.UP`, `Vector2.DOWN`, etc. are built-in unit-vector constants.
	# Note: in Godot, Y points DOWN on screen, so `Vector2.UP` is (0, -1).
	if Input.is_action_pressed("shoot_up"): return Vector2.UP
	if Input.is_action_pressed("shoot_down"): return Vector2.DOWN
	if Input.is_action_pressed("shoot_left"): return Vector2.LEFT
	if Input.is_action_pressed("shoot_right"): return Vector2.RIGHT
	return Vector2.ZERO

#spawn projectile in desired direction
func _shoot(direction: Vector2):
	var projectile := PROJECTILE_SCENE.instantiate() #create new projectile scene
	projectile.dir = direction.angle() 
	projectile.spawnPos = global_position + direction * 20 #spawn 20 pixels in front of player so its not inside lol
	get_parent().add_child(projectile) #the level is the parent; projectile and player are siblings
