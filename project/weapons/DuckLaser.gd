extends Area

func _ready():
	$Timer.connect("timeout", self, "queue_free")
	$Timer.start()
	
	connect("body_entered", self, "_body_entered")

func _body_entered(node):
	if node.has_method("take_damage"):
		node.take_damage(1)
	var explosion = load("res://weapons/explosions/explosion.tscn").instance()
	explosion.transform = node.transform
	explosion.translate(Vector3(0, 2, 0))
	get_parent().add_child(explosion)
	queue_free()

func _physics_process(delta):
	translate_object_local(Vector3(0, 0, -80.0) * delta)
