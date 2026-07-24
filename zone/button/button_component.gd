class_name ButtonComponent
extends Node

signal update_power(trigger_node: Node2D, new_power_setting: bool)

@export var trigger_zone: Zone

var is_powered_on: bool = false

func _ready() -> void:
	await get_tree().physics_frame
	_late_ready()

func _late_ready() -> void:
	trigger_zone.entered_zone.connect(update_power.emit.bind(true))
	trigger_zone.exited_zone.connect(update_power.emit.bind(false))
