extends Node

#global triggers
var gender_male := true
var castle_quiz_triggered := false
var castle_level_completed := false
var mountains_quiz_triggered := false
var mountains_level_completed := false
var woods_quiz_triggered := false
var woods_level_completed := false
var cave_quiz_triggered := false
var cave_level_completed := false
var orchard_quiz_triggered := false
var orchard_level_completed := false
var river_quiz_triggered := false
var river_level_completed := false
var lake_quiz_triggered := false
var lake_level_completed := false
var village_quiz_triggered := false
var village_level_completed := false
var ancient_ruins_quiz_triggered := false
var ancient_ruins_level_completed := false
var abandoned_tower_quiz_triggered := false
var abandoned_tower_level_completed := false
var underground_dungeon_quiz_triggered := false
var underground_dungeon_level_completed := false
var underwater_realm_quiz_triggered := false
var underwater_realm_level_completed := false
var maze_quiz_triggered := false
var maze_level_completed := false
var magician_lair_quiz_triggered := false
var magician_lair_level_completed := false

#global variables used for progression
var player_name: String = ""
var correct_questions = 0
var score: int = 0
var lives: int = 10
var stats = [] 

var teacher_token: String = ""

func update_score():
	score = correct_questions * 100

func reset_game():
	#var player = get_tree().get_first_node_in_group("player")
	#player._collision.disabled = false
	#player.input_pickable = true
	#set_physics_process(true)
	castle_quiz_triggered = false
	castle_level_completed = false
	mountains_quiz_triggered = false
	mountains_level_completed = false
	woods_quiz_triggered = false
	woods_level_completed = false
	cave_quiz_triggered = false
	cave_level_completed = false
	orchard_quiz_triggered = false
	orchard_level_completed = false
	river_quiz_triggered = false
	river_level_completed = false
	lake_quiz_triggered = false
	lake_level_completed = false
	village_quiz_triggered = false
	village_level_completed = false
	ancient_ruins_quiz_triggered = false
	ancient_ruins_level_completed = false
	abandoned_tower_quiz_triggered = false
	abandoned_tower_level_completed = false
	underground_dungeon_quiz_triggered = false
	underground_dungeon_level_completed = false
	underwater_realm_quiz_triggered = false
	underwater_realm_level_completed = false
	maze_quiz_triggered = false
	maze_level_completed = false
	magician_lair_quiz_triggered = false
	magician_lair_level_completed = false
	correct_questions = 0
	score = 0
	lives = 10
	stats = [] 
