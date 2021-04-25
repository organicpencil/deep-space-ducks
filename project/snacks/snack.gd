extends Area


func _ready():
	connect("body_entered", self, "_body_entered")
	
	$VisibilityNotifier.connect("screen_entered", $Direction, "hide")
	$VisibilityNotifier.connect("screen_exited", $Direction, "show")

func _process(delta):
	rotate_y(-0.025)

func _body_entered(node):
	if node.name == "Player":
		if node.health > 0:
			node.health = node.max_health
			Global.emit_signal("player_health_changed", node.health, node.max_health)
			node.spawn_duckling()
			queue_free()

func _physics_process(delta):
	var player = get_node(Global.player_path)

	var v = (global_transform.origin - player.global_transform.origin).normalized()
	v *= 20.0
	$Direction.global_transform.origin = player.global_transform.origin + v
