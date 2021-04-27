extends Spatial

export(NodePath) var screen
export(NodePath) var screen_texture
export(NodePath) var subtitles
export(NodePath) var dialog_player

var current_dialog = 0
var currently_playing = false
var incoming_transmission = false

var preloaded_images = [preload("res://background/DeepSpaceDucks-01.png"),
						preload("res://tv/Corg Dominion-01.png"),
						preload("res://tv/EmergencyTransmission-01.png"),
						preload("res://tv/EndTransmission-01.png")]
var dialog_text1 = """ Ducks, my sensors tell me we are being attacked. The Corg Dominion is upon us! Go out and repel the assault. Don’t let them destroy me. The fate of the universe rests on your... uh... Quack. This is why you get paid the big ducks!"""
var dialog_text2 = """ GoooOOOoood! Mission details will be sent to your cyber retinal display (CRD). I’ll upload my Gordon motivational tape for you. Usually. I sell it for the low price of $5.99, but for you it's free."""
var dialog_text3 = """ Great job ducks! The colony is safe! Also, thank the Zods my favorite radio station was on that ship 13561.246 Paradise... Anyway... The Corg dominion is weak, now is time to take out their home planet and rocket factory to protect our people. The coordinates to their planet will be on your CRD.  On the way to the planet drop beacons in the glowing areas. That’s how I’ll stay in contact with you."""
var dialog_text4 = """ Thank you for laying down those beacons, ducks... You’ve walked right into the trap… Now the Corg dominion has access to every deep space duck’s CRD. Ah, you want an explanation? Well, the Corg’s gave me an offer I couldn't refuse and the money was just too good."""
var dialog_text5 = "Looks like me and the Corg will be feasting on roast duck tonight!"
var dialogs = [dialog_text1, dialog_text2, dialog_text3, dialog_text4, dialog_text5]
var dialog_sounds = [preload("res://tv/sounds/Mission_1_Intro.mp3"),
						preload("res://tv/sounds/Mission1_Response.mp3"),
						preload("res://tv/sounds/Mission_2.mp3"),
						preload("res://tv/sounds/EndOf Mission_2_Backstab.mp3"),
						preload("res://tv/sounds/BossBattleTransmission.mp3"),
						preload("res://tv/sounds/BossBattleTransmission_ ExtraLaugh.mp3")]

func _ready():
	screen = get_node(screen)
	screen_texture = get_node(screen_texture)
	subtitles = get_node(subtitles)
	dialog_player = get_node(dialog_player)
	
	if (name == "Large CRT"):
		dialog_player.set_volume_db(-100)
	incoming_transmission()
	
func incoming_transmission():
	screen_texture.set_texture(preloaded_images[2])
	subtitles.text = "INCOMING EMERGENCY TRANSMISSION!"
	incoming_transmission = true

func play_next_dialog():
	if (incoming_transmission == false):
		return
	# Set Texture To Zordawn the Corg
	screen_texture.set_texture(preloaded_images[1])
	if (current_dialog < 5):
		subtitles.text = dialogs[current_dialog]
		dialog_player.set_stream(dialog_sounds[current_dialog])
		current_dialog += 1
		incoming_transmission = false
		dialog_player.play()

func _on_Small_CRT_Button_pressed():
	if (self.name == "Small CRT"):
		hide()
		play_next_dialog()
	else:
		show()
		play_next_dialog()

func _on_PowerButton_power_clicked():
	if (self.name == "Big CRT"):
		hide()
	else:
		show()
		screen_texture.set_texture(preloaded_images[0])

func _on_Dialog_Sound_finished():
	print("stop playing")
	dialog_player.stop()
	screen_texture.set_texture(preloaded_images[3])
	subtitles.text = "TRANSMISSION ENDED. Click the red button to close the transmission."
	pass
