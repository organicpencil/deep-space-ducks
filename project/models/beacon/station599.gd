extends Spatial

func _process(delta):
	rotation_degrees = Vector3(rotation_degrees.x, lerp(rotation_degrees.y, rotation_degrees.y + 0.5, delta * 2), 0)
