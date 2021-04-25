extends Node

var enemies_remaining = 0

func _ready():
	yield(get_tree(), "idle_frame")
	var enemy = spawn_big_enemy()
	enemy.connect("dead", self, "_wave_2")
	
	Global.connect("win", $ParallaxBackground2/Win, "show")
	Global.connect("lose", $ParallaxBackground2/Lose, "show")
	Global.connect("player_health_changed", self, "_player_health_changed")
	
func _player_health_changed(health, max_health):
	var cont = $ParallaxBackground2/HeartContainer
	for c in cont.get_children():
		c.queue_free()
		
	var heart = preload("res://hud/heart.tscn")
	for i in range(0, max_health):
		var h = heart.instance()
		if health <= i:
			h.modulate = Color(0, 0, 0, 1)
			
		cont.add_child(h)
	
func spawn_big_enemy():
	var v = Vector3(0, 0, 100)
	var b = Basis(Vector3(0, 1, 0), randf() * 6.0)
	v = b * v + $Player.global_transform.origin
	
	var enemy = preload("res://enemies/boss_enemy/boss_enemy.tscn").instance()
	enemy.follow_target_nodepath = $Player.get_path()
	add_child(enemy)
	enemy.global_transform.origin = v
	return enemy

func _wave_2():
	yield(get_tree().create_timer(3.0), "timeout")
	var enemy = spawn_big_enemy()
	enemy.connect("dead", self, "_wave_3")
	enemies_remaining += 1
	
	enemy = spawn_big_enemy()
	enemy.connect("dead", self, "_wave_3")
	enemies_remaining += 1
	
func _wave_3():
	enemies_remaining -= 1
	if enemies_remaining == 0:
		var enemy = spawn_big_enemy()
		enemy.connect("dead", self, "_wave_4")
		enemies_remaining += 1
		
		enemy = spawn_big_enemy()
		enemy.connect("dead", self, "_wave_4")
		enemies_remaining += 1
		
func _wave_4():
	enemies_remaining -= 1
	if enemies_remaining == 0:
		var enemy = spawn_big_enemy()
		enemy.connect("dead", self, "_wave_5")
		enemies_remaining += 1
		
		enemy = spawn_big_enemy()
		enemy.connect("dead", self, "_wave_5")
		enemies_remaining += 1
		
		enemy = spawn_big_enemy()
		enemy.connect("dead", self, "_wave_5")
		enemies_remaining += 1

func _wave_5():
	enemies_remaining -= 1
	if enemies_remaining == 0:
		print("You win!")
		Global.emit_signal("win")
