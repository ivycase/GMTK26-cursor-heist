class_name Countdown
extends Node

func _ready() -> void:
	Global.active_countdown = self

func start_countdown() -> void:
	print("3... 2..... 1.....")
