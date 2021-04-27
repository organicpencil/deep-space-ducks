extends "res://levels/level.gd"


var beacons = 4

func _ready():
	spawn_beacon()
	
func spawn_beacon():
	if beacons > 0:
		for i in range(0, (5-beacons)*2):
			spawn_big_enemy()
			
		beacons -= 1
		var b = preload("res://models/beacon/beacon.tscn").instance()
		add_child(b)
		b.connect("placed", self, "spawn_beacon")
		var pos = $Player.transform.origin + Vector3(rand_range(-200, 200), 0, rand_range(-200, -400))
		b.transform.origin = pos
		
		$ParallaxBackground2/Beacons.text = "Beacons: %d/4" % (3-beacons)

	else:
		Global.emit_signal("win")
