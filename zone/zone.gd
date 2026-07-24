class_name Zone
extends Area2D

signal entered_zone(node: Node2D)
signal exited_zone(node: Node2D)

func _ready() -> void:
	area_entered.connect(entered_zone.emit)
	body_entered.connect(entered_zone.emit)
	
	area_exited.connect(exited_zone.emit)
	body_exited.connect(exited_zone.emit)
