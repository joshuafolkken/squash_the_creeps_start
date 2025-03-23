class_name ScoreLabel
extends Label

var score := 0


func show_score() -> void:
	text = tr("SCORE") % score


func on_mob_squashed() -> void:
	score += 1
	show_score()
