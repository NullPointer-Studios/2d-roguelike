class_name sceneManager extends Node

var player: Player

func change_scene(from, dest: String) -> void:
	player = from.player
	player.get_parent().remove_child(player)
	
	from.get_tree().call_deferred("change_scene_to_file", dest)
