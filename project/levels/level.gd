extends Node

signal send_transmission
export(String, FILE, "*.tscn") var next_scene

func _ready():
	assert(next_scene != "")
	yield(get_tree(), "idle_frame")
	
	Global.connect("win", $ParallaxBackground2/Win, "show")
	Global.connect("win", self, "_win")
	Global.connect("lose", $ParallaxBackground2/Lose, "show")
	Global.connect("player_health_changed", self, "_player_health_changed")
	Global.connect("player_energy_changed", self, "_player_energy_changed")

func _input(event):
	if event.is_action_pressed("pause"):
		$Click.play()
		$ParallaxBackground2/PauseMenu.show()
		get_tree().paused = true
	
func _win():
	get_tree().change_scene(next_scene)
	
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
		
func _player_energy_changed(energy, max_energy):
	$ParallaxBackground2/PlayerEnergy.value = (energy / max_energy) * 100.0
	
func spawn_big_enemy():
	var v = Vector3(0, 0, 100)
	var b = Basis(Vector3(0, 1, 0), randf() * 6.0)
	v = b * v + $Player.global_transform.origin
	
	var enemy = preload("res://enemies/boss_enemy/boss_enemy.tscn").instance()
	enemy.follow_target_nodepath = $Player.get_path()
	add_child(enemy)
	enemy.global_transform.origin = v
	return enemy
