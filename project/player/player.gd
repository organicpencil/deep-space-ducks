extends RigidBody

var behind setget set_behind
var follow_offset = 4.0

var health = 10
var max_health = 10
var energy = 0.0
var max_energy = 10.0
var turn_rotation_z = 0

signal dead

var HIT = [preload("res://sfx/duck_hit_1.tscn"), preload("res://sfx/duck_hit_2.tscn")]

func _ready():
	Global.player_path = get_path()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	Global.emit_signal("player_health_changed", health, max_health)

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
		while amount > 0 and energy >= 1.0:
			energy -= 1.0
			amount -= 1
			
		if amount == 0:
			# TODO: Shield hit sound
			pass
		else:
			get_parent().add_child(HIT[randi() % HIT.size()].instance())
			
		health = int(max(health - amount, 0))
		Global.emit_signal("player_health_changed", health, max_health)
		if health == 0:
			emit_signal("dead")
			Global.emit_signal("lose")
			#queue_free()

func _unhandled_input(event):
	if health == 0:
		return
		
	#if event.is_action_pressed("test"):
	#	spawn_duckling()
		
	if event.is_action_pressed("deploy"):
		if behind:
			get_parent().add_child(preload("res://sfx/deploy_sound.tscn").instance())
			behind.find_target()
			
	if event.is_action_pressed("deploy_all"):
		while behind:
			get_parent().add_child(preload("res://sfx/deploy_sound.tscn").instance())
			var target = behind.find_target(true)
			if !target:
				break
				
			yield(get_tree().create_timer(0.1), "timeout")
			
	if event.is_action_pressed("recall"):
		get_tree().call_group("duckies", "return_to_master")
		
func _physics_process(delta):
	if health == 0:
		angular_velocity = Vector3()
		$"big-beak/AnimationPlayer".stop()
		return
		
	var energy_recharge = 0.0
	var ducky = behind
	while ducky:
		energy_recharge += 0.1
		ducky = ducky.behind
		
	energy = min(energy + (energy_recharge * delta), max_energy)
	
	if Input.is_action_pressed("shoot"):
		if $ShootTimer.is_stopped():
			$ShootTimer.start()
			var laser = preload("res://weapons/DuckLaser.tscn").instance()
			get_parent().add_child(laser)
			laser.global_transform.origin = global_transform.origin
			laser.global_transform.basis = global_transform.basis
			
			laser.rotate_y(rand_range(deg2rad(-5), deg2rad(5)))
			
			get_parent().add_child(preload("res://sfx/heavy_laser_sound.tscn").instance())
	
	var boost = 1.0
	if Input.is_action_pressed("boost") and energy >= 1.0 * delta:
		boost = 3.0
		energy -= 1.0 * delta
		
		if !$Thrust.is_playing():
			$Thrust.play()
			
	else:
		$Thrust.stop()
		
	if Input.is_action_pressed("forward") or Input.is_action_pressed("boost"):
		add_central_force(global_transform.basis * Vector3(0.0, 0.0, -40.0) * boost)
		$"big-beak/AnimationPlayer".play("Swim", 0.2)
		$"big-beak/AnimationPlayer".playback_speed = boost * 2
	else:
		$"big-beak/AnimationPlayer".play("Base", 0.2)
		$"big-beak/AnimationPlayer".playback_speed = 1.0

	var v = 0.0
	v += Input.get_action_strength("left") * 4.0
	v -= Input.get_action_strength("right") * 4.0

	if Input.is_action_pressed("left"):
		turn_rotation_z = -30
	elif Input.is_action_pressed("right"):
		turn_rotation_z = 30
	else:
		turn_rotation_z = 0

	angular_velocity = Vector3(0, v, 0) / boost
	get_child(1).rotation_degrees = Vector3(rotation_degrees.x, -180, turn_rotation_z)
	Global.emit_signal("player_energy_changed", energy, max_energy)
