extends Window

func show_text(text: String):
	$Label.text = text
	var label = $Label
	label.visible = true
	
func hide_text():
	var label = $Label
	label.visible = false
