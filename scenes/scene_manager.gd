class_name sceneManager extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
var player: Player

func change_scene(from, dest: String) -> void:
	player = from.player
	player.get_parent().remove_child(player)
	
	animation.play("out")
	await animation.animation_finished
	from.get_tree().call_deferred("change_scene_to_file", dest)
	animation.play_backwards("out")
