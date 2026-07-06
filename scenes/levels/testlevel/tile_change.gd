extends Area2D

@export var dest: String
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body):
	if body is Player:
		scene_manager.change_scene(get_owner(), dest)
