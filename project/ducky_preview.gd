extends TextureRect


func _ready():
	Global.connect("ducky_changed", self, "_ducky_changed")

func _ducky_changed(ducky_type):
	match ducky_type:
		Global.DUCKY_NONE:
			texture = preload("res://duckling/nothing.png")
			hide()
			
		Global.DUCKY_BALD:
			texture = preload("res://duckling/ducky.png")
			show()
			
		Global.DUCKY_FUNHAT:
			texture = preload("res://duckling/ducky_funhat.png")
			show()
			
		Global.DUCKY_COWBOYHAT:
			texture = preload("res://duckling/ducky_cowboyhat.png")
			show()
			
		Global.DUCKY_BLACKHAT:
			texture = preload("res://duckling/ducky_blackhat.png")
			show()
