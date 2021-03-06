extends StaticBody

var follow_target_nodepath
var health = 1
var max_health = 1
const snacks = [preload("res://snacks/cereal_snack.tscn"),
		preload("res://snacks/hamburger_snack.tscn"),
		preload("res://snacks/pizza_snack.tscn")]

signal dead

func _ready():
	rotate_y(rand_range(0.0, 6.0))
	$SpawnTimer.connect("timeout", self, "spawn")
	
	#$VisibilityNotifier.connect("screen_entered", $Arrow, "hide")
	#$VisibilityNotifier.connect("screen_exited", $Arrow, "show")
	$Arrow.hide()
	
func take_damage(amount : int):
	if health > 0:
		health = int(max(health - amount, 0))
		if health == 0:
			emit_signal("dead")
			var snack = snacks[randi() % 3].instance()
			get_parent().add_child(snack)
			snack.transform.origin = transform.origin
			queue_free()
	
func spawn():
	var enemy = load("res://enemies/small_enemy/small_enemy.tscn").instance()
	enemy.follow_target_nodepath = follow_target_nodepath
	get_parent().add_child(enemy)
	enemy.global_transform.origin = global_transform.origin

"""
func _physics_process(delta):
	var follow_target = get_node(follow_target_nodepath)

	var v = (global_transform.origin - follow_target.global_transform.origin).normalized()
	v *= 20.0
	$Arrow.global_transform.origin = follow_target.global_transform.origin + v
"""
