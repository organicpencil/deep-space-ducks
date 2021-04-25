extends Area


func _ready():
	$Timer.connect("timeout", self, "queue_free")
	$Timer.start()
	
	connect("body_entered", self, "_body_entered")

func _body_entered(node):
	queue_free()
	node.queue_free()

func _physics_process(delta):
	translate_object_local(Vector3(0, 0, -80.0) * delta)
