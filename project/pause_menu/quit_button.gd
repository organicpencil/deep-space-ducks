extends Button


func _ready():
	pass

func _pressed():
	$"../Click".play()
	get_tree().paused = false
	get_tree().change_scene("res://main_menu/main_menu.tscn")
