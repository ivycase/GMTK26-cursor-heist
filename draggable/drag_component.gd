# put this on a node2d to make it draggable

class_name DragComponent
extends Node2D

signal picked

@export var click_area: Area2D
@export var dragged_node: CharacterBody2D
@export var drag_speed: float = 10.0
@export var drag_curve: float = 1.0
@export var visual: Node2D
@export var visual_resize_scale: float = 1.2
@export var is_activated: bool

var is_holding_mouse: bool
var initial_scale: Vector2
var tween: Tween

func _ready() -> void:
	await get_tree().physics_frame
	_late_ready()

func _late_ready() -> void:
	if !dragged_node or !click_area:
		push_error("Drag Component needs a click area and dragged_node.")
		return
		
	if visual:
		initial_scale = visual.scale
		
	click_area.body_entered.connect(_on_click_area_body_entered)
	click_area.body_exited.connect(_on_click_area_body_exited)
		
func _physics_process(delta: float) -> void:
	if !is_holding_mouse:
		return
		
	var mouse_pos: Vector2 = Global.get_cursor_position()
		
	dragged_node.velocity = (mouse_pos - dragged_node.global_position) * drag_speed
	#dragged_node.global_position = dragged_node.global_position.lerp(mouse_pos, ease(delta, drag_curve) * drag_speed)
	var rotate_to: float = dragged_node.global_position.angle_to(mouse_pos)
	dragged_node.rotation = lerpf(dragged_node.rotation, rotate_to, ease(delta * drag_speed, drag_curve))
	
	dragged_node.move_and_slide()

func toggle_drag_visual(do_visual: bool) -> void:
	if tween:
		tween.kill()
	
	if do_visual:
		tween = get_tree().create_tween()
		tween.tween_property(visual, "scale", initial_scale * visual_resize_scale, 0.2).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN_OUT)
	
	if !do_visual:
		tween = get_tree().create_tween().set_parallel()
		tween.tween_property(visual, "scale", initial_scale, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		var mouse_pos: Vector2 = Global.get_cursor_position()
		
		var over_rotation: float = dragged_node.rotation + dragged_node.global_position.angle_to(mouse_pos)
		tween.tween_property(dragged_node, "rotation", over_rotation, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		#var over_translate: Vector2 = dragged_node.global_position.lerp(mouse_pos, ease(0.1, drag_curve) * drag_speed)
		#tween.tween_property(dragged_node, "global_position", over_translate, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
func _receive_click(cursor: Cursor) -> void:
	if !is_activated: 
		return
	
	if !Global.request_mouse(self):
		return
		
	is_holding_mouse = true
	toggle_drag_visual(true)
	
	picked.emit()
	
	cursor.release.connect(_receive_release.bind(cursor))
		
func _receive_release(cursor: Cursor) -> void:
	if !is_holding_mouse:
		return
		
	Global.release_mouse(self)
	is_holding_mouse = false
	if is_activated: toggle_drag_visual(false)
	
	cursor.release.disconnect(_receive_release)
	
	var mouse_pos: Vector2 = Global.get_cursor_position()
	var over_translate: Vector2 = dragged_node.global_position.lerp(mouse_pos, ease(0.1, drag_curve) * drag_speed)
	dragged_node.velocity = (mouse_pos - over_translate) * drag_speed

func _on_click_area_body_entered(body: PhysicsBody2D) -> void:
	if body is Cursor:
		body.click.connect(_receive_click.bind(body))
		
func _on_click_area_body_exited(body: PhysicsBody2D) -> void:
	if body is Cursor:
		body.click.disconnect(_receive_click)
