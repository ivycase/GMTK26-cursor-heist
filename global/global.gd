extends Node

signal update_score(old_score: int, new_score: int)

var mouse_holder: Node

var level_score: int = 0
var level_quota: int = 500

var current_level: int = 1

var active_cursor: Cursor
var active_countdown: Countdown

func add_score(amount: int) -> void:
	level_score += amount
	update_score.emit(level_score - amount, level_score)

func get_cursor_position() -> Vector2:
	return active_cursor.global_position

func request_mouse(requester: Node) -> bool:
	if requester == null:
		return false
	
	if mouse_holder == requester:
		return true
		
	if mouse_holder:
		return false
		
	mouse_holder = requester
	return true
	
func release_mouse(releaser: Node) -> bool:
	if releaser != mouse_holder:
		return false
		
	mouse_holder = null
	return true
	
func level_transition() -> void:
	var next_level: int = current_level+1
	print(next_level)
	EasyTransition.transition_to("res://levels/level" + str(next_level) + ".tscn")
	current_level = next_level
