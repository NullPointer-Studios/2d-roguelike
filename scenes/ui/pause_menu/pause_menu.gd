extends Control

#Container var
@onready var pause_container = $PauseContainer
@onready var settings_container = $SettingsContainer

#Pause Container var
@onready var resume : Button = $PauseContainer/Resume
@onready var settings: Button = $PauseContainer/Settings
@onready var quit : Button = $PauseContainer/Quit

#Settings Container var
@onready var master_vol : HSlider = $SettingsContainer/volSlide1
@onready var music_vol : HSlider = $SettingsContainer/volSlide2
@onready var sfx_vol : HSlider = $SettingsContainer/volSlide3
@onready var fullscreen_checkbox : CheckBox = $SettingsContainer/toggleFullscreen
@onready var back : Button = $SettingsContainer/Back

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume.pressed.connect(on_resume_pressed)
	settings.pressed.connect(on_settings_pressed)
	back.pressed.connect(on_back_pressed)
	quit.pressed.connect(on_quit_pressed)

func on_resume_pressed():
	PauseManager.toggle_pause()
	
func on_settings_pressed():
	pause_container.hide()
	settings_container.show()
	
func on_back_pressed():
	settings_container.hide()
	pause_container.show()

func on_quit_pressed():
	PauseManager.can_pause = false
	PauseManager.is_paused = false
	get_tree().paused = false
	PauseManager.hide_pause_menu()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
	
func reset_pause_menu() -> void:
	pause_container.show()
	settings_container.hide()
