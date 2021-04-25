extends StaticBody

var ahead
var behind
var follow_offset = 0.5
var _target
var master_duck

func _ready():
	$ShootTimer.connect("timeout", self, "_shoot")
	
func _shoot():
	var laser = preload("res://weapons/DuckLaser.tscn").instance()
	get_parent().add_child(laser)
	laser.global_transform.origin = global_transform.origin
	laser.global_transform.basis = global_transform.basis

func set_target(target):
	if behind:
		behind.ahead = ahead
		
	if ahead:
		ahead.behind = behind
		
	ahead = null
	behind = null
	
	if _target:
		_target.disconnect("tree_exiting", self, "_clear_target")
		
	_target = target
	if _target:
		_target.connect("tree_exiting", self, "_clear_target")
		
	if !target:
		$ShootTimer.stop()
		return_to_master()
	else:
		$ShootTimer.start()
		
func _clear_target():
	if _target:
		_target.disconnect("tree_exiting", self, "_clear_target")
		_target = null
		$ShootTimer.stop()
		return_to_master()
		
func return_to_master():
	if ahead:
		return
		
	var duck = _find_last_duck(master_duck)
	duck.behind = self
	ahead = duck
	behind = null
	
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

func _physics_process(delta):
	var follow_target
	if _target:
		follow_target = _target
	else:
		follow_target = ahead
	
	look_at(follow_target.transform.origin, Vector3(0, 1, 0))
	var v = follow_target.transform.basis * Vector3(0, 0, 1)
	
	if !_target:
		transform.origin = transform.origin.linear_interpolate(follow_target.transform.origin + (v * follow_target.follow_offset), 0.15)
	else:
		translate(global_transform.basis * Vector3(0.0, 0.0, -40.0) * delta)
