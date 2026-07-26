extends Node

signal update_score(old_score: int, new_score: int)

var mouse_holder: Node

var current_level: int = 1

var active_cursor: Cursor
var active_countdown: Countdown
var active_quota: Quota


func add_score(amount: int) -> void:
	active_quota.add_score(amount)

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
	EasyTransition.transition_to("res://levels/greyboxes/level" + str(next_level) + ".tscn")
	current_level = next_level

func level_restart() -> void: 
	EasyTransition.transition_to("res://levels/greyboxes/level" + str(current_level) + ".tscn")
	
func _ready() -> void:
	BgmSingleton.get_node("bgm").play()
	BgmSingleton.get_node("bgm").stream.set_sync_stream_volume(1, -80.0)
	
func bgm_phase1() -> void:
	if BgmSingleton.get_node("bgm").stream.get_sync_stream_volume(0) != 0:
		BgmSingleton.get_node("bgm").stream.set_sync_stream_volume(1,-80)
		BgmSingleton.get_node("bgm").stream.set_sync_stream_volume(0,0)
		
func bgm_phase2() -> void: 
	if BgmSingleton.get_node("bgm").stream.get_sync_stream_volume(1) != 0:
		BgmSingleton.get_node("bgm").stream.set_sync_stream_volume(0,-80)
		BgmSingleton.get_node("bgm").stream.set_sync_stream_volume(1,0)
