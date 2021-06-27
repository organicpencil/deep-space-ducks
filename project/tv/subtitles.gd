extends ViewportContainer

func _on_QuackButton_quack_clicked():
	if is_visible():
		hide()
	else:
		set_visible(true)
