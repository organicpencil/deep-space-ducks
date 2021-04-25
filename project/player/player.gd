extends RigidBody

var behind
var follow_offset = 1.0

func _unhandled_input(event):
	if event.is_action_pressed("test"):
		var duck = load("res://duckling/duckling.tscn").instance()
		duck.master_duck = self
		duck.ahead = self
		if behind:
			behind.ahead = duck
			duck.behind = behind
			
		behind = duck
		
		get_parent().add_child(duck)
		duck.global_transform.origin = global_transform.origin
		
	if event.is_action_pressed("deploy"):
		if behind:
			behind.find_target()
			
	if event.is_action_pressed("deploy_all"):
		while behind:
			var target = behind.find_target(true)
			if !target:
				break
				
			yield(get_tree().create_timer(0.1), "timeout")

func _physics_process(delta):
	var boost = 1.0
	if Input.is_action_pressed("boost"):
		boost = 3.0
		
	add_central_force(global_transform.basis * Vector3(0.0, 0.0, -40.0) * boost)

	var v = 0.0
	
	if Input.is_action_pressed("left"):
		v += 3.0
		
	if Input.is_action_pressed("right"):
		v -= 3.0
		
	angular_velocity = Vector3(0, v, 0) / boost
