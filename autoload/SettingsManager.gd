extends Node

var audio = {"master_volume" : 1.0, "music_volume" : 1.0, "sfx_volume" : 1.0}
var vid = {"fullscreen" : false, "width" : 1920, "height" : 1080}

# File that stores settings on launch
const path : String = "user://settings.cfg"

var config : ConfigFile = ConfigFile.new()

func _ready():
	try_load_settings()
	apply_settings()

func try_load_settings() -> void:
	if FileAccess.file_exists(path):
		load_from_file();
	else:
		save_settings();

func load_from_file() -> void:
	config.load(path)
	vid = config.get_value("VIDEO", "vid_set", vid)
	audio = config.get_value("AUDIO", "audio_set", audio)
	
func save_settings() -> void:
	config.set_value("VIDEO", "vid_set", vid)
	config.set_value("AUDIO", "audio_set", audio)
	config.save(path)

func apply_settings() -> void:
	if vid["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	AudioServer.set_bus_volume_db(0, linear_to_db(audio["master_volume"]))
