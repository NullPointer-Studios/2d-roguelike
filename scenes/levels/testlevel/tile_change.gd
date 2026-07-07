extends Area2D

#path of the destination scene. Manual for now
@export var dest: String
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body):
	if body is Player:
		#the path of the caller is given along with the destination path
		scene_manager.change_scene(get_owner(), dest)
