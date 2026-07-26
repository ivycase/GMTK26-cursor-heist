class_name RotateComponent
extends Node2D

@export var rotate_node: Node2D
@export var timer: Timer
@export var delay: float = 2.5
@export var look_targets: Array[Marker2D]
@export var rotate_speed: float = 2.5

var target_index: int = 0
var target_angles: Array[float]
var target: float
var rotate_interpolation: float = 0.0

func _ready() -> void:
	target_angles.append(global_rotation)
	for marker: Marker2D in look_targets:
		target_angles.append(rotate_node.global_position.angle_to_point(marker.global_position))
	
	timer.wait_time = delay
	timer.timeout.connect(_look_at_next_target)
	
	_look_at_next_target()
	rotate_speed *= -1
	rotate_node.global_rotation = target

func _disable() -> void:
	pass

func _physics_process(delta: float) -> void:
	if rotate_interpolation >= 1:
		if timer.is_stopped(): timer.start()
		return
		
	rotate_node.global_rotation = rotate_toward(rotate_node.global_rotation, target, delta * rotate_speed)
	
	rotate_interpolation += delta

func _look_at_next_target() -> void:
	target_index += 1
	target = target_angles[target_index % len(target_angles)]
	rotate_interpolation = 0
	rotate_speed *= -1
