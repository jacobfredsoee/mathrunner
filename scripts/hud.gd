extends CanvasLayer

@onready var healthbar = $Healthbar

func _ready() -> void:
	$GameOverScreen.visible = false

func set_formular(formular: String):
	$Formular.text = formular

func set_score(score: int):
	$Score.text = str("Score: ", score)

func loose_life():
	healthbar.loose_life()

func initialize_lives(n_lives: int) -> void:
	$Healthbar.initialize_lives(n_lives)

func show_game_over():
	$GameOverScreen.visible = true
