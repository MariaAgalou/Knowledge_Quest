extends Control

@export var default_style: StyleBox
@export var default_grey_style: StyleBox

@onready var http = $HTTPRequest
@onready var scroll1: ScrollContainer = $Panel/ScrollContainer1
@onready var scroll2: ScrollContainer = $Panel/ScrollContainer2
@onready var scroll3: ScrollContainer = $Panel/ScrollContainer3
@onready var stats_label1: Label = $Panel/ScrollContainer1/StatsLabel
@onready var stats_label2: Label = $Panel/ScrollContainer2/StatsLabel
@onready var stats_label3: Label = $Panel/ScrollContainer3/StatsLabel

@onready var hbox: HBoxContainer = $Panel/HBoxContainer
@onready var student: LineEdit = $Panel/LineEdit
@onready var exit: Button = $Panel/Exit
@onready var return_b: Button = $Panel/Return

@onready var error: Label = $Panel/Error

@onready var buttons = [
	$Panel/Return,
	$Panel/Exit,
	$Panel/HBoxContainer/Button,
	$Panel/HBoxContainer/Button2,
	$Panel/HBoxContainer/Button3
]

func _ready() -> void:
	apply_styles()
	error.hide()
	scroll1.hide()
	scroll2.hide()
	scroll3.hide()
	return_b.hide()

func apply_styles():
	for b in buttons:
		b.add_theme_stylebox_override("normal", default_style)
		b.add_theme_stylebox_override("hover", default_grey_style)
		b.add_theme_stylebox_override("pressed", default_style)
		b.add_theme_stylebox_override("disabled", default_style)

func request_stats():
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer %s" % GameState.teacher_token
	]
	http.request(
		"http://127.0.0.1:3000/stats",
		headers,
		HTTPClient.METHOD_GET
	)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		stats_label1.text = "Failed to load statistics"
		stats_label2.text = "Failed to load statistics"
		stats_label3.text = "Failed to load statistics"
		return
	
	if response_code == 401 or response_code == 403:
		GameState.teacher_token = ""
		SceneManager.change_scene("res://scenes/login.tscn")
		return

	
	var data = JSON.parse_string(body.get_string_from_utf8())
	if data == null or data.is_empty():
		stats_label1.text = "No statistics available"
		stats_label2.text = "No statistics available"
		stats_label3.text = "No statistics available"
		return
	
	stats_label1.text = format_statistics_all(data)
	for stats in data:
		if stats["student"] == student.text:
			stats_label2.text = format_statistics_single(data, student.text)
			error.text = ""
			break
		else:
			error.text = "Student %s does not exist" % student.text
	stats_label3.text = format_statistics_total(data)

func format_statistics_all(total_stats: Array) -> String:
	var lines: Array[String] = []

	lines.append("Student Statistics")
	lines.append("----------------------------")
	
	var stat_order = [
		"Score gained",
		"Total score",
		"Lives lost",
		"Lives remaining",
		"Time to completion",
		"Number of wrong answers",
		"Wrong answers",
		"Number of correct answers",
		"Correct answers"
	]
	
	for stats in total_stats:
		lines.append("Student: %s\n" % stats["student"])
		var i = 1
		for level in stats["stats"]:
			lines.append("===========Level %s===========\n" % str(i))
			
			for stat_name in stat_order:
				if level.has(stat_name):
					var stat_value = level[stat_name]

					if stat_value is Array:
						lines.append("%s:" % stat_name)
						for item in stat_value:
							lines.append("  • %s" % item)
					else:
						lines.append("%s: %s" % [stat_name, stat_value])
			i += 1
		
		lines.append("Played on: %s\n" % format_iso_date(stats["created_at"]))
		lines.append("=============================================")

	return "\n".join(lines)

func format_statistics_single(total_stats: Array, student:String) -> String:
	var lines: Array[String] = []

	lines.append("Student Statistics")
	lines.append("----------------------------")
	
	var stat_order = [
		"Score gained",
		"Total score",
		"Lives lost",
		"Lives remaining",
		"Time to completion",
		"Number of wrong answers",
		"Wrong answers",
		"Number of correct answers",
		"Correct answers"
	]
	
	for stats in total_stats:
		if stats["student"] == student:
			lines.append("Student: %s\n" % stats["student"])
			var i = 1
			for level in stats["stats"]:
				lines.append("===========Level %s===========\n" % str(i))
				
				for stat_name in stat_order:
					if level.has(stat_name):
						var stat_value = level[stat_name]

						if stat_value is Array:
							lines.append("%s:" % stat_name)
							for item in stat_value:
								lines.append("  • %s" % item)
						else:
							lines.append("%s: %s" % [stat_name, stat_value])
				i += 1
			
			lines.append("Played on: %s\n" % format_iso_date(stats["created_at"]))
			lines.append("=============================================")
	return "\n".join(lines)

func format_statistics_total(total_stats: Array) -> String:
	var lines: Array[String] = []

	#Player Rankings
	var scores = []
	for stats in total_stats:
		var total_score = 0
		for level in stats["stats"]:
			if level.has("Total score"):
				total_score = level["Total score"]
		scores.append({"student": stats["student"], "total_score": total_score})

	# Sort descending
	scores.sort_custom(func(a, b):
		return a["total_score"] > b["total_score"]
	)

	lines.append("Player Rankings")
	lines.append("-------------------------")
	var rank = 1
	for s in scores:
		lines.append("%d. %s: %d" % [rank, s["student"], s["total_score"]])
		rank += 1
	lines.append("\n=============================================")
	
	# Mean Total Score
	var sum_score = 0
	var count_score = 0
	for stats in total_stats:
		for level in stats["stats"]:
			if level.has("Total score"):
				sum_score = level["Total score"]
		count_score += 1
	var mean_score = sum_score / max(count_score, 1)
	lines.append("\nMean Total Score: %.2f" % mean_score)
	lines.append("\n=============================================")
	
	# Mean errors and correct per level
	var level_data = []
	for stats in total_stats:
		for i in range(stats["stats"].size()):
			var level = stats["stats"][i]
			if level_data.size() <= i:
				level_data.append({"errors": 0, "correct": 0, "count": 0})
			level_data[i]["errors"] += level.get("Number of wrong answers", 0)
			level_data[i]["correct"] += level.get("Number of correct answers", 0)
			level_data[i]["count"] += 1

	lines.append("\nMean Stats per Level")
	lines.append("-------------------------")
	for i in range(level_data.size()):
		var mean_errors = level_data[i]["errors"] / max(level_data[i]["count"], 1)
		var mean_correct = level_data[i]["correct"] / max(level_data[i]["count"], 1)
		lines.append("Level %d - Mean Errors: %.2f, Mean Correct: %.2f" % [i+1, mean_errors, mean_correct])
	

	var errors_result = get_levels_with_max("Number of wrong answers", total_stats)
	var corrects_result = get_levels_with_max("Number of correct answers", total_stats)

	# Levels with most wrong and right answers
	lines.append("\n=============================================")
	lines.append("\nLevels with Most Errors: %s" % levels_to_string(errors_result["levels"]))
	lines.append("Levels with Most Correct Answers: %s" % levels_to_string(corrects_result["levels"]))
	lines.append("\n=============================================")

	# Return full formatted string
	return "\n".join(lines)

func get_levels_with_max(stat_key: String, total_stats: Array) -> Dictionary:
	var level_totals := []
	# Accumulate totals per level
	for stats in total_stats:
		for i in range(stats["stats"].size()):
			if level_totals.size() <= i:
				level_totals.append(0)
			level_totals[i] += stats["stats"][i].get(stat_key, 0)

	# Find max value and all levels that match it
	var max_value := -1
	var max_levels := []
	for i in range(level_totals.size()):
		if level_totals[i] > max_value:
			max_value = level_totals[i]
			max_levels = [i]
		elif level_totals[i] == max_value:
			max_levels.append(i)
	
	return {"value": max_value, "levels": max_levels}

func levels_to_string(levels: Array) -> String:
	if levels.size() == 0:
		return "None"
	# build "Level X, Level Y, ..." manually because Array.join() isn't available
	var parts := []
	for idx in levels:
		parts.append("Level %d" % (idx + 1))

	var s := ""
	for j in range(parts.size()):
		s += parts[j]
		if j < parts.size() - 1:
			s += ", "
	return s

func format_iso_date(iso_string: String) -> String:
	var unix_time := Time.get_unix_time_from_datetime_string(iso_string)

	if unix_time == 0:
		return iso_string # fallback if parsing fails

	var dt := Time.get_datetime_dict_from_unix_time(unix_time)

	return "%02d %s %d — %02d:%02d" % [
		dt.day,
		["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][dt.month - 1],
		dt.year,
		dt.hour,
		dt.minute
	]

func _on_button_2_pressed() -> void:
	request_stats()
	error.hide()
	scroll1.show()
	return_b.show()
	student.hide()
	exit.hide()
	hbox.hide()

func _on_button_3_pressed() -> void:
	if student.text != "":
		error.hide()
		request_stats()
		await get_tree().create_timer(1.0).timeout
		if error.text == "":
			error.hide()
			scroll2.show()
			return_b.show()
			student.hide()
			exit.hide()
			hbox.hide()
		else:
			error.show()

func _on_exit_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")

func _on_return_pressed() -> void:
	student.text = ""
	error.hide()
	scroll1.hide()
	scroll2.hide()
	scroll3.hide()
	return_b.hide()
	student.show()
	exit.show()
	hbox.show()

func _on_button_pressed() -> void:
	request_stats()
	error.hide()
	scroll3.show()
	return_b.show()
	student.hide()
	exit.hide()
	hbox.hide()
