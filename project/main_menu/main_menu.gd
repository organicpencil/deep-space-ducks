extends Control

var LEVEL = preload("res://Level.tscn")

func _ready():
	$StartTexture/AnimationPlayer.play("start_pulse")
	$AnimationPlayer.connect("animation_finished", self, "_start_game")

func _input(event):
	if event.is_pressed():
		$AnimationPlayer.play("transition")

func _start_game(anim):
	get_tree().change_scene_to(LEVEL)
