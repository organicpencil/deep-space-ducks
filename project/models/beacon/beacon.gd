extends Area

var placed = false
signal placed

func _ready():
	connect("body_entered", self, "_body_entered")
	
	$VisibilityNotifier.connect("screen_entered", $Direction, "hide")
	$VisibilityNotifier.connect("screen_exited", $Direction, "show")

func _process(delta):
	$Beacon.rotate_y(-0.025)

func _body_entered(node):
	if node.name == "Player":
		if node.health > 0:
			if !placed:
				placed = true
				$Beacon.set_surface_material(0, null)
				$VisibilityNotifier.queue_free()
				$Direction.queue_free()
				emit_signal("placed")

func _physics_process(delta):
	if !placed:
		var player = get_node(Global.player_path)

		var v = (global_transform.origin - player.global_transform.origin).normalized()
		v *= 20.0
		$Direction.global_transform.origin = player.global_transform.origin + v
