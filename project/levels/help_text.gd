extends Label


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("help_text"):
		visible = !visible
