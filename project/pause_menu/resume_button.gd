extends Button


func _ready():
	pass

func _pressed():
	$"../Click".play()
	get_tree().paused = false
	get_parent().hide()
