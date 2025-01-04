extends Node

const LIFE_SIZE = Vector2(24, 24)
var life_scene = preload("res://scenes/life.tscn")

var life_count = 0
var lives = [] # Array to store life instances

func initialize_lives(n_life: int):
	life_count = n_life
	lives.clear() # Clear any existing lives
	
	# Scale factor (e.g., 2x)
	var scale_factor = Vector2(2, 2)

	# Create and position the life instances
	for i in range(life_count):
		var life = life_scene.instantiate()
		life.scale = scale_factor
		life.position = Vector2(i * LIFE_SIZE.x * scale_factor.x, 0)
		lives.append(life) # Store the life instance
		add_child(life)

func lose_life():
	if life_count <= 0:
		return
		
	# Find the life to remove (the rightmost active life)
	var life_to_remove = lives[life_count - 1]
	life_to_remove.show_used_life()
	life_count -= 1

func reset_lives():
	# Reset all existing lives to full
	for life in lives:
		life.show_full_life()
	life_count = lives.size()
