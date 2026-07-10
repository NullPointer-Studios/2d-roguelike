extends Node

@export var pause_menu_scene : PackedScene = preload("res://scenes/ui/pause_menu/pause_menu.tscn")
var pause_menu_instance = null
var is_paused : bool = false
var can_pause : bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("pause") and can_pause):
		toggle_pause()

func toggle_pause() -> void:
	if (is_paused):
		hide_pause_menu()
		is_paused = false
		get_tree().paused = false
	else:
		show_pause_menu()
		is_paused = true
		get_tree().paused = true

func show_pause_menu() -> void:
	if not is_instance_valid(pause_menu_instance):
		pause_menu_instance = pause_menu_scene.instantiate()
		pause_menu_instance.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().root.add_child(pause_menu_instance)
	pause_menu_instance.get_node("PauseControl").reset_pause_menu()
	pause_menu_instance.show()

func hide_pause_menu() -> void:
	if is_instance_valid(pause_menu_instance):
		pause_menu_instance.hide()
