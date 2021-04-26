extends "res://levels/level.gd"


var enemies_remaining = 0
var beacons = 4

func _ready():
	var enemy = spawn_big_enemy()
	enemy.connect("dead", self, "_wave_2")
	
	spawn_beacon()
	
func spawn_beacon():
	if beacons > 0:
		beacons -= 1
		var b = preload("res://models/beacon/beacon.tscn").instance()
		add_child(b)
		b.connect("placed", self, "spawn_beacon")
		var pos = $Player.transform.origin + Vector3(rand_range(-100, 100), 0, rand_range(-200, -400))
		b.transform.origin = pos
		
	else:
		Global.emit_signal("win")

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
	pass
