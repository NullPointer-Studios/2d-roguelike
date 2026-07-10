extends PanelContainer

@onready var master_slider : HSlider = $VBoxContainer/volSlide1
@onready var music_slider : HSlider = $VBoxContainer/volSlide2
@onready var sfx_slider : HSlider = $VBoxContainer/volSlide3

@onready var fullscreen_checkbox : CheckBox = $VBoxContainer/toggleFullscreen
@onready var back_button : Button = $VBoxContainer/Back

signal back_requested

func _ready()-> void:
	master_slider.value = SettingsManager.audio["master_volume"]
	music_slider.value = SettingsManager.audio["music_volume"]
	sfx_slider.value = SettingsManager.audio["sfx_volume"]
	fullscreen_checkbox.button_pressed = SettingsManager.vid["fullscreen"]
	
	master_slider.value_changed.connect(on_master_volume_changed)
	music_slider.value_changed.connect(on_music_volume_changed)
	sfx_slider.value_changed.connect(on_sfx_volume_changed)
	fullscreen_checkbox.toggled.connect(on_fullscreen_toggled)
	back_button.pressed.connect(on_back_pressed)
	
func on_master_volume_changed(value: float) -> void:
	SettingsManager.audio["master_volume"] = value
	SettingsManager.save_settings()
	SettingsManager.apply_settings()

func on_music_volume_changed(value: float) -> void:
	SettingsManager.audio["music_volume"] = value
	SettingsManager.save_settings()
	SettingsManager.apply_settings()

func on_sfx_volume_changed(value: float) -> void:
	SettingsManager.audio["sfx_volume"] = value
	SettingsManager.save_settings()
	SettingsManager.apply_settings()
	
func on_fullscreen_toggled(value: bool) -> void:
	SettingsManager.vid["fullscreen"] = value
	SettingsManager.save_settings()
	SettingsManager.apply_settings()
	
func on_back_pressed() -> void:
	emit_signal("back_requested")
