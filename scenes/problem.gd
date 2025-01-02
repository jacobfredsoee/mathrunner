extends Node

var correct_answer: int
const HEAD_START_RANGE = 1500
var is_top_correct: bool
var answer_chosen: bool = false

func initialize(new_formular: String, answer: int, position: float) -> void:
	correct_answer = answer
	set_formular(new_formular)
	randomize_answers()
	set_position(position)

func randomize_answers() -> void:
	# Randomly decide if top or bottom gets correct answer
	is_top_correct = randf() < 0.5
	
	# Generate wrong answer within ±5 of correct answer, but not equal
	var wrong_answer = correct_answer
	while wrong_answer == correct_answer:
		wrong_answer = correct_answer + randi_range(-5, 5)
	
	if is_top_correct:
		set_top_answer(correct_answer)
		set_bottom_answer(wrong_answer)
	else:
		set_top_answer(wrong_answer)
		set_bottom_answer(correct_answer)

func set_top_answer(value: int):
	$AnswerTop/Label.text = str(value)
	
func set_bottom_answer(value: int):
	$AnswerBottom/Label.text = str(value)

func set_formular(value: String):
	$Formular.text = value

func set_position(value: float):
	$AnswerTop.position.x = value + HEAD_START_RANGE
	$AnswerBottom.position.x = value + HEAD_START_RANGE
	$Formular.position.x = value

func move(delta: float, speed: float):
	$AnswerTop.position.x -= speed * delta * 0.25
	$AnswerBottom.position.x -= speed * delta * 0.25
	$Formular.position.x += speed * delta

func get_position() -> Vector2:
	return $AnswerBottom.position

func _on_answer_top_body_entered(_body: Node2D) -> void:
	if answer_chosen:
		return
	answer_chosen = true
	get_tree().root.get_node("Main").report_score(is_top_correct, correct_answer)
	hide_wrong_answer()
func _on_answer_bottom_body_entered(_body: Node2D) -> void:
	if answer_chosen:
		return
	answer_chosen = true
	get_tree().root.get_node("Main").report_score(!is_top_correct, correct_answer)
	hide_wrong_answer()

func hide_wrong_answer():
	if is_top_correct:
		$AnswerBottom.visible = false
		$AnswerTop.scale = Vector2(1.5, 1.5)
	else:
		$AnswerTop.visible = false
		$AnswerBottom.scale = Vector2(1.5, 1.5)
