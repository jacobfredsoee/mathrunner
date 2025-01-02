extends Node

const INITIAL_SPEED = 300.0
const MAX_SPEED = 800.0
const ACCELERATION = 5.0 # Speed increase per second
const SCORE_PER_SECOND = 1.0
const SPEED_MULTIPLIER_STEP = 100.0 # Every 100 speed increase adds 1x to multiplier

var game_running: bool = false
var last_ground_x: float = 0.0
var ground_width: float
var current_speed: float
var score: float = 0.0

var problems := []

var problem_screen = preload("res://scenes/problem.tscn")


func _ready() -> void:
	# Get the width from the sprite or collision shape
	ground_width = $Ground/Sprite2D.texture.get_width()
	
	last_ground_x = $Ground.position.x

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if not game_running: # Only start game and reset speed if not already running
			game_running = true
			current_speed = INITIAL_SPEED
	
	if not game_running:
		return

	# Gradually increase speed up to maximum
	current_speed = min(current_speed + ACCELERATION * delta, MAX_SPEED)

	$Player.position.x += current_speed * delta
	$Camera2D.position.x += current_speed * delta

	manage_ground($Camera2D.position.x)
	remove_problems()
	generate_problem()
	move_problems(delta)
	manage_score(delta)

func report_score(correct: bool, value: int):
	if correct:
		$Player/CorrectSound.play()
		score += value
	else:
		$Player/IncorrectSound.play()
		score -= value

func manage_score(delta: float):
	var speed_multiplier = max(1.0, (current_speed - INITIAL_SPEED) / SPEED_MULTIPLIER_STEP + 1.0)
	score += SCORE_PER_SECOND * delta * speed_multiplier
	$HUD.set_score(int(score))

func generate_problem() -> void:
	if problems.is_empty():
		var a = randi_range(1, 10)
		var b = randi_range(1, 10)
		
		var current_problem = problem_screen.instantiate()
		current_problem.initialize(str(a, " + ", b, " = ?"), a + b, $Player.position.x)
		problems.append(current_problem)
		add_child(current_problem)

func move_problems(delta: float):
	for problem in problems:
		problem.move(delta, current_speed)

func remove_problems():
	for problem in problems:
		if problem.get_position().x < $Player.position.x - 100:
			problem.queue_free()
			problems.erase(problem)
		

func manage_ground(camera_x: float) -> void:
	# Spawn new ground when camera approaches the end of the last ground
	if camera_x + get_viewport().size.x > last_ground_x:
		spawn_ground()
	
	cleanup_old_ground(camera_x)

func spawn_ground() -> void:
	var new_ground = $Ground.duplicate()
	new_ground.position.x = last_ground_x + ground_width
	add_child(new_ground)
	last_ground_x = new_ground.position.x

func cleanup_old_ground(camera_x: float) -> void:
	for ground in get_tree().get_nodes_in_group("ground"):
		if ground.position.x + ground_width < camera_x - get_viewport().size.x:
			ground.queue_free()
