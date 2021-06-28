extends Button

export(NodePath) var help_text
export(NodePath) var health_bar
export(NodePath) var player_energy

func _ready():
	help_text = get_node(help_text)
	health_bar = get_node(health_bar)
	player_energy = get_node(player_energy)

func _on_PowerButton_power_clicked():
	help_text.show()
	health_bar.show()
	player_energy.show()
	get_tree().paused = false
	if (name == "Small CRT Button"):
		show()

func _on_Small_CRT_Button_pressed():
	help_text.hide()
	health_bar.hide()
	player_energy.hide()
	get_tree().paused = true
	if (name == "Big CRT Button"):
		show()
