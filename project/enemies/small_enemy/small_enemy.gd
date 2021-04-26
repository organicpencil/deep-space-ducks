extends RigidBody

var follow_target_nodepath
var health = 1
var max_health = 1

signal dead

var EXPLOSIONS = [preload("res://sfx/explode_1.tscn"), preload("res://sfx/explode_2.tscn"), preload("res://sfx/explode_3.tscn")]

func _ready():
	$ShootTimer.connect("timeout", self, "_shoot")
	$ShootTimer.start()
	
func take_damage(amount : int):
	if health > 0:
		health = int(max(health - amount, 0))
		if health == 0:
			emit_signal("dead")
			get_parent().add_child(EXPLOSIONS[randi() % EXPLOSIONS.size()].instance())
			queue_free()

func _shoot():
	if $VisibilityNotifier.is_on_screen():
			var laser = preload("res://weapons/EnemyLaser.tscn").instance()
			get_parent().add_child(laser)
			laser.global_transform.origin = global_transform.origin
			laser.global_transform.basis = global_transform.basis
			laser.scale.x *= 0.5
			
			laser.rotate_y(rand_range(deg2rad(-15), deg2rad(15)))
			
			get_parent().add_child(preload("res://sfx/light_laser_sound.tscn").instance())
		
	$ShootTimer.wait_time = rand_range(0.5, 2.0)
	$ShootTimer.start()

func _physics_process(delta):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for enemy")
		return
	
	if global_transform.origin.distance_to(follow_target.global_transform.origin) > 20.0:
		add_central_force(global_transform.basis * Vector3(0.0, 0.0, -40.0))
	
	$"rocket-enemy".rotate_object_local(Vector3(1, 0, 0), 0.05)
	
func _integrate_forces(state):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for enemy")
		return
		
	look_at(follow_target.global_transform.origin, Vector3(0, 1, 0))
