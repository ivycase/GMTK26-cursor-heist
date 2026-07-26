class_name Turret
extends Node2D

@export var charge_timer: Timer
@export var is_enabled: bool
@export var rotate_node: Node2D
@export var detect_zone: Zone
@export var aim_speed: float = 2.5
@export var charge_duration: float = 1.0
@export var animation_buffer: float = 0.2
@export var visual_width: float = 5.0
@export var visual_start_color: Color = Color.RED
@export var visual_end_color: Color = Color.TRANSPARENT
@export_range(-5.0, 5.0) var width_ease: float = 1.0
@export_range(-5.0, 5.0) var color_ease: float = 1.0

var last_target_position: Vector2
var current_target: Node2D
var default_rotation: float

func _ready() -> void:
	charge_timer.wait_time = charge_duration
	charge_timer.timeout.connect(_destroy_target)
	
	detect_zone.entered_zone.connect(_switch_target)
	detect_zone.exited_zone.connect(_switch_target.bind(null).unbind(1))
	
func _physics_process(delta: float) -> void:
	queue_redraw()
	
	if !is_enabled: return
	if !current_target: return
	if !_try_aim(): return
	
	_set_last_target_pos()
		
	var target_angle: float = rotate_node.global_position.angle_to_point(current_target.global_position)
	rotate_node.global_rotation = rotate_toward(rotate_node.global_rotation, target_angle, delta * aim_speed)
	
	if abs(rotate_node.global_rotation - target_angle) <= 0.01 and charge_timer.is_stopped():
		charge_timer.start()
		
func _draw() -> void:
	if !current_target:
		return
	
	var interpolation: float = ((charge_timer.wait_time + animation_buffer) - charge_timer.time_left) / (charge_timer.wait_time + animation_buffer)
	var interp_color: Color = lerp(visual_start_color, visual_end_color, ease(interpolation, color_ease))
	var interp_width: float = lerp(0.5, visual_width, ease(interpolation, width_ease))
	draw_line(Vector2.ZERO, to_local(current_target.global_position), interp_color, interp_width)
	
func _destroy_target() -> void:
	if !current_target: return
	print("TODO: destroy visual")
	current_target.queue_free()
	
func _raycast_to_target() -> Dictionary:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, current_target.global_position, 0b101)
	var result: Dictionary = space_state.intersect_ray(query)
	return result

func _set_last_target_pos() -> void:
	if !current_target:
		return
		
	last_target_position = current_target.global_position

func _switch_target(node: Node2D) -> void:
	if node == null:
		charge_timer.stop()
		current_target = null
		return
		
	if !node.get_node_or_null("LootComponent"):
		return
	
	current_target = node

func _try_aim() -> bool:
	var raycast_result: Dictionary = _raycast_to_target()
	if !raycast_result:
		charge_timer.stop()
		return false
	if raycast_result.collider != current_target:
		charge_timer.stop()
		return false
	return true
	
