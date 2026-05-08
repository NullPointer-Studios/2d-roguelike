extends CharacterBody2D

#how fast bullets travel
@export var SPEED = 400

var dir : float #direction
var spawnPos : Vector2 #initial position

func _ready():
	global_position = spawnPos

func _physics_process(_delta):
	velocity = Vector2(SPEED, 0.0).rotated(dir)
	move_and_slide()
