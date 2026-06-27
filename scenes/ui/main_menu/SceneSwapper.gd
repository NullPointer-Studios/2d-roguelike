extends Button

@export var switchToScene : PackedScene;

signal swapScene(newScene: PackedScene);

func _ready()-> void:
	pressed.connect(on_swapper_button_pressed);
	
func on_swapper_button_pressed() -> void:
	emit_signal("swapScene", switchToScene)
