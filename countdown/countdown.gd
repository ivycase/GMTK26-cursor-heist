class_name Countdown
extends Node

@export var timer: Timer
@export var getaway_time: float = 10.0

func _ready() -> void:
	Global.active_countdown = self
	timer.wait_time = getaway_time
	timer.timeout.connect(end_countdown)

func start_countdown() -> void:
	if !timer.is_stopped():
		return
	
	timer.start()
	
func end_countdown() -> void:
	print("times up buster")
