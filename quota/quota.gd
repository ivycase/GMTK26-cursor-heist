class_name Quota
extends Node

@export var current_score: int = 0
@export var total_quota: int = 3

func _ready() -> void:
	Global.active_quota = self

func add_score(amount: int) -> void:
	if amount > 0:
		ez_sound.play_sfx("coin.wav")
	
	current_score += amount
	Global.update_score.emit(current_score - amount, current_score)

func check_win() -> bool:
	return current_score >= total_quota
