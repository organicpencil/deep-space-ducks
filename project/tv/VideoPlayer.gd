extends TextureRect

func _ready():
	connect("finished", self, "play")
