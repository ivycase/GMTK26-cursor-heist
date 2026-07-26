extends Node2D

enum Layers {BASE, VENT}

@export var vents: Array[Zone]

@export var active_z_level: Layers

@export var base_level_parent: Node2D
@export var base_level_tilemap: TileMapLayer

@export var vent_level_parent: Node2D
@export var vent_level_tilemap: TileMapLayer

func _ready() -> void:
	for vent in vents:
		vent.entered_zone.connect(toggle_z_level.unbind(1))
		vent.top_level = true
		
	vent_level_parent.global_position += Vector2(5000, 5000) # just yeet is somewhere else lmfao

func toggle_z_level() -> void:
	match active_z_level:
		Layers.BASE:
			active_z_level = Layers.VENT
			
			base_level_parent.global_position += Vector2(5000, 5000) # just yeet is somewhere else lmfao
			vent_level_parent.global_position -= Vector2(5000, 5000) # just unyeet is somewhere else lmfao
			
			base_level_parent.hide()
			base_level_tilemap.collision_enabled = false
			
			vent_level_parent.show()
			vent_level_tilemap.collision_enabled = true
			
		Layers.VENT:
			active_z_level = Layers.BASE
			
			vent_level_parent.global_position += Vector2(5000, 5000) # just yeet is somewhere else lmfao
			base_level_parent.global_position -= Vector2(5000, 5000) # just unyeet is somewhere else lmfao
			
			vent_level_parent.hide()
			vent_level_tilemap.collision_enabled = false
			
			base_level_parent.show()
			base_level_tilemap.collision_enabled = true
