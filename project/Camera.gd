extends Camera

func _process(delta):
	var t = get_node("../Player").translation
	t.y = translation.y
	translation = translation.linear_interpolate(t, 0.2)
	
	var offset = Vector2(translation.x, translation.z) * -20.0
	get_node("../ParallaxBackground").scroll_offset = offset
	get_node("../ParallaxBackground2").scroll_offset = offset
