extends Node

signal ducky_changed
signal player_health_changed
signal player_energy_changed
signal win
signal lose

enum{DUCKY_FUNHAT, DUCKY_BLACKHAT, DUCKY_COWBOYHAT, DUCKY_BALD, DUCKY_NONE}

var player_path


func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
