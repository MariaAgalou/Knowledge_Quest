extends CanvasLayer

@onready var stats_text = $Panel/ScrollContainer/Label

func _ready():
	visible = false

func dict_to_text(stats: Dictionary) -> String:
	var txt := ""
	
	txt += "Score (Level): %d\n" % stats["Score gained"]
	txt += "Score (Total): %d\n" % stats["Total score"]
	txt += "Lives Lost: %d\n" % stats["Lives lost"]
	txt += "Lives Remaining: %d\n" % stats["Lives remaining"]
	txt += "Time: %.1f seconds\n\n" % stats["Time to completion"]
	txt += "Wrong answers: %d\n" % stats["Number of wrong answers"]
	var wrong_list := PackedStringArray(stats["Wrong answers"])
	txt += "- " + " ".join(wrong_list) + "\n"
	txt += "Correct answers: %d\n" % stats["Number of correct answers"]
	var correct_list := PackedStringArray(stats["Correct answers"])
	txt += "- " + " ".join(correct_list)

	return txt

func load_stats():
	var final_text := ""
	for i in GameState.stats.size():
		final_text += "=== Level %d ===\n" % (i + 1)
		final_text += dict_to_text(GameState.stats[i])
		final_text += "\n"

	stats_text.text = final_text

func _on_button_pressed() -> void:
	StatisticsPopUp.hide()
