extends Node


# Constructor
func _init(show_full: bool = true) -> void:
	self.show_full_on_ready = show_full  # Store the initial state for use in _ready()

var show_full_on_ready: bool = true

func _ready():
	if show_full_on_ready:
		show_full_life()
	else:
		show_used_life()
		
func toggle_life():
	$Full.visible = !$Full.visible
	$Used.visible = !$Used.visible

func show_full_life():
	$Full.visible = true
	$Used.visible = false
	
func show_used_life():
	$Full.visible = false
	$Used.visible = true
