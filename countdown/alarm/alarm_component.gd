class_name AlarmComponent
extends Node

@export var trigger_zone: Zone

func _ready() -> void:
	await get_tree().physics_frame
	_late_ready()

func _late_ready() -> void:
	trigger_zone.entered_zone.connect(Global.active_countdown.start_countdown.unbind(1))
