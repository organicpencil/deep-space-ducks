extends Spatial

export(NodePath) var screen
export(NodePath) var crtz
var next_motivation = 2

func _ready():
	screen = get_node(screen)
	crtz = get_node(crtz)
	Global.connect("lose", self, "lose")
	Global.connect("victory", self, "victory")
	Global.connect("ultimate_victory", self, "ultimate_victory")
	Global.connect("motivate", self, "motivate")

func _process(_delta):
	#rotate_object_local(Vector3(0, 1, 0), -0.03)
	pass

func lose():
	$Timer.wait_time = $LoseSound.stream.get_length()
	$Timer.start()
	$LoseSound.play()

func victory():
	$Timer.wait_time = $VictorySound.stream.get_length()
	$Timer.start()

func ultimate_victory():
	show()
	$Timer.wait_time = $VictorySound.stream.get_length()
	$Timer.start()

	$VictorySound.play()

func motivate():
	var sound = get_node("Motivation%d" % next_motivation)
	next_motivation += 1
	if next_motivation > 10:
		next_motivation = 2

	$Timer.wait_time = sound.stream.get_length()
	$Timer.start()
	sound.play()

func _on_Small_CRT_Button_pressed():
	if (self.name == "Small CRT"):
		hide()
	else:
		show()

func _on_Big_CRT_Button_pressed():
	if (self.name == "Big CRT"):
		hide()
	else:
		show()
