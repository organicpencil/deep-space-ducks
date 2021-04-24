extends StaticBody

var follow_target_nodepath
var follow_offset = 0.5

func _physics_process(delta):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for ducking")
		return
	
	look_at(follow_target.transform.origin, Vector3(0, 1, 0))
	var v = follow_target.transform.basis * Vector3(0, 0, 1)
	transform.origin = transform.origin.linear_interpolate(follow_target.transform.origin + (v * follow_target.follow_offset), 0.1)
