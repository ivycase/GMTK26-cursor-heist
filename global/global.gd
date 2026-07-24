extends Node

var mouse_holder: Node

var active_cursor: Cursor

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
