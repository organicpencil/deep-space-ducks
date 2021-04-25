extends StaticBody

var ahead
var behind
var follow_offset = 2.0
var _target_ref
var master_duck

func _ready():
	$ShootTimer.connect("timeout", self, "_shoot")
	
func _shoot():
	var laser = preload("res://weapons/DuckLaser.tscn").instance()
	get_parent().add_child(laser)
	laser.global_transform.origin = global_transform.origin
	laser.global_transform.basis = global_transform.basis
	laser.scale.x *= 0.5
	
func find_target(random=false):
	if !is_inside_tree():
		return
		
	var baddies = get_tree().get_nodes_in_group("baddies")
	var pos = get_viewport().get_camera().project_position(get_viewport().get_mouse_position(), 50.0)
	
	var nearest = null
	var neardist = 0.0
	
	if random:
		if baddies.size() > 0:
			nearest = baddies[randi() % baddies.size()]
	else:
		for b in baddies:
			var dist = b.global_transform.origin.distance_to(pos)
			if nearest == null or dist < neardist:
				nearest = b
				neardist = dist
	
	set_target(nearest)
	return nearest

func set_target(target):
	if behind:
		behind.ahead = ahead
		
	if ahead:
		ahead.behind = behind
		
	ahead = null
	behind = null
	
	var _target
	if _target_ref:
		_target = _target_ref.get_ref()
		
	if _target:
		_target.disconnect("tree_exiting", self, "find_target")
		
	_target_ref = weakref(target)
	if target:
		target.connect("tree_exiting", self, "find_target", [true])
		$ShootTimer.start()
	else:
		return_to_master()
	
func return_to_master():
	if ahead:
		return
		
	var duck = _find_last_duck(master_duck)
	duck.behind = self
	ahead = duck
	behind = null
	$ShootTimer.stop()
	
func _find_last_duck(duck):
	if duck.behind:
		return _find_last_duck(duck.behind)
	else:
		return duck
	
func _exit_tree():
	if behind:
		behind.ahead = ahead
		ahead.behind = behind
		behind = null
		ahead = null

func _physics_process(delta):
	var follow_target
	if ahead:
		follow_target = ahead
	elif _target_ref and _target_ref.get_ref():
		follow_target = _target_ref.get_ref()
	else:
		return_to_master()
		follow_target = ahead
	
	if follow_target == null or !is_instance_valid(follow_target):
		find_target(true)
		return
		
	look_at(follow_target.transform.origin, Vector3(0, 1, 0))
	var v = follow_target.transform.basis * Vector3(0, 0, 1)
	
	if ahead:
		var new_pos = transform.origin.linear_interpolate(follow_target.transform.origin + (v * follow_target.follow_offset), 0.2)
		var movement = new_pos - transform.origin
		if movement.length() > 40.0 * delta:
			movement *= ((40.0 * delta) / movement.length())
			
		transform.origin += movement
	else:
		translate(global_transform.basis * Vector3(0.0, 0.0, -40.0) * delta)
