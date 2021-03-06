extends Control

var NEXT_SCENE = preload("res://levels/level_1.tscn")

func _ready():
	$StartTexture/AnimationPlayer.play("start_pulse")
	$AnimationPlayer.connect("animation_finished", self, "_start_game")

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().quit()
		return
		
	if event.is_pressed() and !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("transition")

func _start_game(anim):
	get_tree().change_scene_to(NEXT_SCENE)
