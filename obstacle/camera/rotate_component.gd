class_name RotateComponent
extends Node2D

@export var is_enabled: bool = true
@export var rotate_node: Node2D
@export var timer: Timer
@export var delay: float = 2.5
@export var look_targets: Array[Marker2D]
@export var rotate_speed: float = 2.5
@export_range(-5.0, 5.0) var ease_curve: float = 1.0

var target_index: int = 0
var target_angles: Array[float]
var target: float
var prev_target: float
var rotate_interpolation: float = 0.0

func _ready() -> void:
	target_angles.append(rotate_node.global_rotation)
	
	for marker: Marker2D in look_targets:
		target_angles.append(rotate_node.global_position.angle_to_point(marker.global_position) + rotate_node.global_rotation)
	
	target = rotate_node.global_rotation
	_look_at_next_target()
	
	timer.wait_time = delay
	timer.timeout.connect(_look_at_next_target)

func _physics_process(delta: float) -> void:
	if !is_enabled: return
	
	if rotate_interpolation >= 1:
		if timer.is_stopped(): timer.start()
		return
		
	rotate_node.global_rotation = lerp_angle(prev_target, target, ease(rotate_interpolation, ease_curve))
	
	rotate_interpolation += delta * rotate_speed
	print(target_angles)
	
func disable() -> void:
	is_enabled = false

func _look_at_next_target() -> void:
	target_index += 1
	prev_target = target
	target = target_angles[target_index % len(target_angles)]
	rotate_interpolation = 0
