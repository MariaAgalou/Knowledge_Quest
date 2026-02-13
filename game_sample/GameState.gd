extends Node

#global triggers
var castle_quiz_triggered := false
var castle_level_completed := false
var gender_male := true

#global variables used for progression
var correct_questions = 0
var score: int = 0
var lives: int = 10
var stats = [] 

func update_score():
	score = correct_questions * 100

func reset_game():
	castle_quiz_triggered = false
	correct_questions = 0
	score = 0
	lives = 10
