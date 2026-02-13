extends Button

func _on_pressed() -> void:
	var dialogue_box = get_tree().get_first_node_in_group("answer")
	if dialogue_box:
		dialogue_box.hide_text()
		dialogue_box.show_text("Incorrect!")
	self.disabled = true
