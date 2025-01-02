extends CharacterBody2D

const GRAVITY = 2500.0
const JUMP_VELOCITY = -1200.0


func _physics_process(delta: float) -> void:
	if not get_parent().game_running:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump.
	if is_on_floor():
		$AnimatedSprite2D.play("running")
		if Input.is_action_just_pressed("ui_accept"):
			$AudioStreamPlayer.play()
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jumping")
	else:
		$AnimatedSprite2D.play("jumping")

	move_and_slide()
