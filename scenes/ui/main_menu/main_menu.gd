extends Control

@export var test_level : PackedScene

@onready var settings_scene = $SettingsScene

var goBackList = [];
var currentMenu : int;

func _ready() -> void:
	PauseManager.can_pause = false
	settings_scene.back_requested.connect(swap_menu_to_previous)
	$MenuScene/MainMenuContainer/QuitButton.pressed.connect(on_quit_game_button_pressed)
	$MenuScene/MainMenuContainer/PlayButton.pressed.connect(on_play_button_pressed)

func swap_menu_request(menuIndex: int, returnIndex: int) -> void:
	if(menuIndex >= get_child_count() or menuIndex < 0):
		return;
	currentMenu = menuIndex;
	
	var child = get_child(currentMenu);
	child.visible = true;
	
	if(returnIndex >= 0):
		goBackList.append(returnIndex);
		get_child(returnIndex).visible = false;

func swap_menu_to_previous() -> void:
	if(goBackList.is_empty()):
		return;
	
	get_child(currentMenu).visible = false;
	swap_menu_request(goBackList[goBackList.size() -1], -1);
	goBackList.pop_back();
	

func on_swap_scene(newScene : PackedScene) -> void:
		get_tree().change_scene_to_packed(newScene)
		
func on_play_button_pressed() -> void:
	print("play button pressed")
	if test_level:
		PauseManager.can_pause = true
		print("test level is set")
		on_swap_scene(test_level)
	else:
		print("test level is NULL")

func on_quit_game_button_pressed() -> void:
	get_tree().quit();
