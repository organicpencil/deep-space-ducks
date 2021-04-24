extends RigidBody

var follow_target_nodepath

func _ready():
	$ShootTimer.connect("timeout", self, "shoot")
	$ShootTimer.start()

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
	
	add_central_force(global_transform.basis * Vector3(0.0, 0.0, -80.0))
	
func _integrate_forces(state):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for enemy")
		return
		
	look_at(follow_target.global_transform.origin, Vector3(0, 1, 0))
