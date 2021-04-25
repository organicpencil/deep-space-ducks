extends Area


func _ready():
	connect("body_entered", self, "_body_entered")

func _process(delta):
	rotate_y(-0.025)

func _body_entered(node):
	if node.name == "Player":
		if node.health > 0:
			node.health = node.max_health
			Global.emit_signal("player_health_changed", node.health, node.max_health)
			node.spawn_duckling()
			queue_free()
