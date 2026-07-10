extends CharacterBody2D

@export var move_speed := 200.0

func _ready():
	print("PLAYER SCRIPT READY")

func _physics_process(_delta):
	var input_direction := Vector2.ZERO
	
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	input_direction = input_direction.normalized()
	velocity = input_direction * move_speed
	
	move_and_slide()
