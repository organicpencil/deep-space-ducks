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
		
	if event.is_action_pressed("spawn_enemy"):
		var v = Vector3(0, 0, 100)
		var b = Basis(Vector3(0, 1, 0), randf() * 6.0)
		v = b * v + global_transform.origin
		
		var enemy = preload("res://enemies/boss_enemy/boss_enemy.tscn").instance()
		enemy.follow_target_nodepath = get_path()
		get_parent().add_child(enemy)
		enemy.global_transform.origin = v
		
	if event.is_action_pressed("deploy"):
		if behind:
			var baddies = get_tree().get_nodes_in_group("baddies")
			var pos = get_viewport().get_camera().project_position(get_viewport().get_mouse_position(), 50.0)
			
			var nearest = null
			var neardist = 0.0
			
			for b in baddies:
				var dist = b.global_transform.origin.distance_to(pos)
				if nearest == null or dist < neardist:
					nearest = b
					neardist = dist
			
			var duck = behind
			duck.set_target(nearest)

func _physics_process(delta):
	add_central_force(global_transform.basis * Vector3(0.0, 0.0, -60.0))
	
	var v = 0.0
	
	if Input.is_action_pressed("left"):
		v += 3.0
		
	if Input.is_action_pressed("right"):
		v -= 3.0
		
	angular_velocity = Vector3(0, v, 0)
