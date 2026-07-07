extends Node2D
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#the same player from the previous scene is loaded
	if scene_manager.player:
		player = scene_manager.player
		add_child(player)
