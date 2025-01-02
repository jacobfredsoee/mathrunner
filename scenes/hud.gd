extends CanvasLayer

func set_formular(formular: String):
	$Formular.text = formular

func set_score(score: int):
	$Score.text = str("Score: ", score)
