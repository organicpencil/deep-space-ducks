extends "res://levels/level.gd"

var enemies_remaining = 0

func _ready():
	._ready()
	var enemy = spawn_big_enemy()
	enemy.connect("dead", self, "_wave_2")

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
	
	if enemies_remaining == 1:
		$ParallaxBackground2/OneRemaining.visible = true
	
	if enemies_remaining == 0:
		print("You win!")
		Global.emit_signal("win")
