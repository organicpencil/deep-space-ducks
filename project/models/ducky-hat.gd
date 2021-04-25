extends Spatial

func _ready():
	var hat_array = ["funhat.tscn", "blackhat.tscn", "cowboyhat.tscn", ""]
	var index = find_parent("ducky").get_parent().duck_type
	
	var hat = null
	if hat_array[index] != "":
		hat = load("res://models/hats/" + hat_array[index]).instance()
	
	if hat != null:
		if (hat_array[index] == "blackhat.tscn"):
			hat.translation = Vector3(0.0, 1.145, 0.0)
		elif (hat_array[index] == "funhat.tscn"):
			hat.translation = Vector3(0.004, 0.986, 0.02)
			hat.rotation = Vector3(-11.13, 0.065, -0.127)
			hat.scale = Vector3(0.8, 0.8, 0.8)
		else:
			hat.translation = Vector3(0.006, 0.993, -0.172)
			hat.rotation = Vector3(0.102, 89.9, -11.77)
		add_child(hat)
