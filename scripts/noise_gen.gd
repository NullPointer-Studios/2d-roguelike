extends TileMap

var fnl := FastNoiseLite.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	fnl.seed = randi()
	fnl.noise_type = FastNoiseLite.TYPE_PERLIN
	fnl.fractal_type = FastNoiseLite.FRACTAL_FBM
	fnl.fractal_octaves = 1
	fnl.domain_warp_fractal_lacunarity = 3
	generateMap()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func generateMap() -> void:
	for x in 300:
		for y in 250:
			var noiseVal := fnl.get_noise_2d(x,y)
			if noiseVal < 0.05:
				set_cell(0, Vector2i(x,y),0,Vector2(6,6))
			else:
				set_cell(0, Vector2i(x,y),0,Vector2(12,9))
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_key"):
		get_tree().reload_current_scene()
