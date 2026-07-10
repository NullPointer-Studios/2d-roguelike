extends Button

@export var switchToNode : Node;
@export var currentNode : Node;
signal swapMenuRequest(swapIndex: int, returnIndex: int);

func _ready()-> void:
	pressed.connect(on_swapper_button_pressed);
	

func on_swapper_button_pressed() -> void:
	emit_signal("swapMenuRequest", switchToNode.get_index(), currentNode.get_index());
