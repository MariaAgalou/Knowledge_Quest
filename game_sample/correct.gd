extends Button

func _on_pressed() -> void:
	var dialogue_box = get_tree().get_first_node_in_group("answer")
	if dialogue_box:
		dialogue_box.hide_text()
		dialogue_box.show_text("Correct! Please close the window.")

func _on_window_close_requested() -> void:
	var popup = get_tree().get_first_node_in_group("Window")
	popup.hide()
