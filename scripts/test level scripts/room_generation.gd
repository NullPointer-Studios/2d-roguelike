extends Node2D
var SquareRock = preload("res://scenes/objects/Rock/SquareRock.tscn")
var HorizontalRock = preload("res://scenes/objects/Rock/HorizontalRock.tscn")
func _ready():
	print("ROOM GENERATOR IS RUNNING")
	generate_room()


func generate_room():
	# Get markers
	var A = get_parent().get_node("ObstacleSpawn/ObsA")
	var B = get_parent().get_node("ObstacleSpawn/ObsB")
	var C = get_parent().get_node("ObstacleSpawn/ObsC")
	var D = get_parent().get_node("ObstacleSpawn/ObsD")

	# Pick a random layout pattern
	var pattern = randi() % 3

	match pattern:

		# all square rocks
		0:
			spawn(SquareRock, A)
			spawn(SquareRock, B)
			spawn(SquareRock, C)
			spawn(SquareRock, D)

		# horizontal rock in B-C
		1:
			spawn(SquareRock, A)

			spawn_horizontal(B, C)

			spawn(SquareRock, D)

		# horizontal rock in A-B
		2:
			spawn_horizontal(A, B)

			spawn(SquareRock, C)
			spawn(SquareRock, D)


# Spawn a normal 1x1 obstacle
func spawn(scene: PackedScene, marker: Node):
	var obj = scene.instantiate()
	add_child(obj)
	obj.global_position = marker.global_position


# Spawn a horizontal rock spanning 2 markers
func spawn_horizontal(left_marker: Node, right_marker: Node):
	var obj = HorizontalRock.instantiate()
	add_child(obj)

	# Place at midpoint between the two markers
	obj.global_position = (left_marker.global_position + right_marker.global_position) / 2
