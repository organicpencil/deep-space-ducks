extends RigidBody

var behind setget set_behind
var follow_offset = 4.0

var health = 5
var max_health = 5

signal dead

func set_behind(ducky):
	behind = ducky
	if behind:
		Global.emit_signal("ducky_changed", behind.duck_type)
	else:
		Global.emit_signal("ducky_changed", Global.DUCKY_NONE)

func spawn_duckling():
	var duck = load("res://duckling/duckling.tscn").instance()
	duck.master_duck = self
	duck.ahead = self
	if behind:
		behind.ahead = duck
		duck.behind = behind
		
	set_behind(duck)
	
	get_parent().add_child(duck)
	duck.global_transform.origin = global_transform.origin

func take_damage(amount : int):
	if health > 0:
		health = int(max(health - amount, 0))
		Global.emit_signal("player_health_changed", health, max_health)
		if health == 0:
			emit_signal("dead")
			#queue_free()

func _unhandled_input(event):
	if health == 0:
		return
		
	if event.is_action_pressed("test"):
		spawn_duckling()
		
	if event.is_action_pressed("deploy"):
		if behind:
			behind.find_target()
			
	if event.is_action_pressed("deploy_all"):
		while behind:
			var target = behind.find_target(true)
			if !target:
				break
				
			yield(get_tree().create_timer(0.1), "timeout")
			
	if event.is_action_pressed("recall"):
		get_tree().call_group("duckies", "return_to_master")
		
	if event.is_action_pressed("shoot"):
		var laser = preload("res://weapons/DuckLaser.tscn").instance()
		get_parent().add_child(laser)
		laser.global_transform.origin = global_transform.origin
		laser.global_transform.basis = global_transform.basis

func _physics_process(delta):
	if health == 0:
		angular_velocity = Vector3()
		$"big-beak/AnimationPlayer".stop()
		return
		
	if Input.is_action_pressed("shoot"):
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
			var laser = preload("res://weapons/DuckLaser.tscn").instance()
			get_parent().add_child(laser)
			laser.global_transform.origin = global_transform.origin
			laser.global_transform.basis = global_transform.basis
	
	var boost = 1.0
	if Input.is_action_pressed("boost"):
		boost = 3.0
		
	if Input.is_action_pressed("forward") or Input.is_action_pressed("boost"):
		add_central_force(global_transform.basis * Vector3(0.0, 0.0, -40.0) * boost)
		$"big-beak/AnimationPlayer".play("Swim", 0.2)
		$"big-beak/AnimationPlayer".playback_speed = boost * 2
	else:
		$"big-beak/AnimationPlayer".play("Base", 0.2)
		$"big-beak/AnimationPlayer".playback_speed = 1.0

	var v = 0.0
	
	if Input.is_action_pressed("left"):
		v += 3.0
		
	if Input.is_action_pressed("right"):
		v -= 3.0
		
	angular_velocity = Vector3(0, v, 0) / boost
