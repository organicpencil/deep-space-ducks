extends RigidBody

var last_duck = self
var follow_offset = 1.0

func _unhandled_input(event):
	if event.is_action_pressed("test"):
		var duck = load("res://duckling/Duckling.tscn").instance()
		duck.follow_target_nodepath = last_duck.get_path()
		last_duck = duck
		get_parent().add_child(duck)
		duck.global_transform.origin = global_transform.origin

func _physics_process(delta):
	add_central_force(global_transform.basis * Vector3(0.0, 0.0, -60.0))
	#global_translate(global_transform.basis * Vector3(0.0, 0.0, 6.0 * delta))
	
	
	var v = 0.0
	if Input.is_action_pressed("left"):
		v += 3.0
		
	if Input.is_action_pressed("right"):
		v -= 3.0
		
	angular_velocity = Vector3(0, v, 0)
