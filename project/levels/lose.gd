extends Label


func _ready():
	pass

func _input(event):
	if event.is_action_pressed("restart"):
		if visible:
			get_tree().change_scene(get_parent().get_parent().filename)
