extends Area


func _ready():
	connect("body_entered", self, "_body_entered")

func _process(delta):
	rotate_y(-0.025)

func _body_entered(node):
	if node.name == "Player":
		node.spawn_duckling()
		queue_free()
