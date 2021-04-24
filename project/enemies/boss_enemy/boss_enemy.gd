extends RigidBody

var follow_target_nodepath

func _ready():
	rotate_y(rand_range(0.0, 6.0))
	$SpawnTimer.connect("timeout", self, "spawn")
	
	$VisibilityNotifier.connect("screen_entered", $Arrow, "hide")
	$VisibilityNotifier.connect("screen_exited", $Arrow, "show")
	
func spawn():
	var enemy = load("res://enemies/small_enemy/small_enemy.tscn").instance()
	enemy.follow_target_nodepath = follow_target_nodepath
	get_parent().add_child(enemy)
	enemy.global_transform.origin = global_transform.origin

func _physics_process(delta):
	var follow_target = get_node(follow_target_nodepath)
	if !follow_target:
		push_warning("No follow target for boss enemy")
		return

	var v = (global_transform.origin - follow_target.global_transform.origin).normalized()
	v *= 20.0
	$Arrow.global_transform.origin = follow_target.global_transform.origin + v
