extends RigidBody

var follow_target_nodepath
var health = 1
var max_health = 1

signal dead

func _ready():
	$ShootTimer.connect("timeout", self, "shoot")
	$ShootTimer.start()
	
func take_damage(amount : int):
	if health > 0:
		health = int(max(health - amount, 0))
		if health == 0:
			emit_signal("dead")
			queue_free()

func shoot():
	if $VisibilityNotifier.is_on_screen():
		# TODO - Create bullet
		pass
		
	$ShootTimer.wait_time = rand_range(0.5, 2.0)
	$ShootTimer.start()

func _physics_process(delta):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for enemy")
		return
	
	if global_transform.origin.distance_to(follow_target.global_transform.origin) > 20.0:
		add_central_force(global_transform.basis * Vector3(0.0, 0.0, -40.0))
	
func _integrate_forces(state):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for enemy")
		return
		
	look_at(follow_target.global_transform.origin, Vector3(0, 1, 0))
