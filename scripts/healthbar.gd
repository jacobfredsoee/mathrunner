extends Node

const LIFE_SIZE = Vector2(24, 24)
var life_scene = preload("res://scenes/life.tscn")

var life_count = 0

func initialize_lives(n_life: int):
	life_count = n_life
	
	# Scale factor (e.g., 2x)
	var scale_factor = Vector2(2, 2)

	# Create and position the life instances
	for i in range(life_count):
		var life = life_scene.instantiate()
		life.scale = scale_factor
		life.position = Vector2(i * LIFE_SIZE.x * scale_factor.x, 0)
		add_child(life)

func loose_life():
	life_count -= 1
	
	# Loop through all life instances
	for i in get_child_count():
		var life = get_child(i)
		# Set life as used if its index is >= current life count
		if i >= life_count:
			life.show_used_life()
		else:
			life.show_full_life()
