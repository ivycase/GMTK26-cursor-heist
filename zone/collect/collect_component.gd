class_name CollectComponent
extends Node

@export var trigger_zone: Zone

func _ready() -> void:
	await get_tree().physics_frame
	_late_ready()

func _late_ready() -> void:
	trigger_zone.entered_zone.connect(_collect_loot)
	trigger_zone.exited_zone.connect(_uncollect_loot)
	
func _collect_loot(area: Node2D) -> void:
	if area is not LootComponent:
		return
		
	Global.add_score(area.worth)
	
func _uncollect_loot(area: Node2D) -> void:
	if area is not LootComponent:
		return
		
	Global.add_score(-area.worth)
	
