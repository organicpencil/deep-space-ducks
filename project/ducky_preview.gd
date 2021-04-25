extends TextureRect


func _ready():
	Global.connect("ducky_changed", self, "_ducky_changed")

func _ducky_changed(ducky_type):
	match ducky_type:
		Global.DUCKY_NONE:
			texture = preload("res://duckling/nothing.png")
			
		Global.DUCKY_BALD:
			texture = preload("res://duckling/ducky.png")
			
		Global.DUCKY_FUNHAT:
			texture = preload("res://duckling/ducky_funhat.png")
			
		Global.DUCKY_COWBOYHAT:
			texture = preload("res://duckling/ducky_cowboyhat.png")
			
		Global.DUCKY_BLACKHAT:
			texture = preload("res://duckling/ducky_blackhat.png")
