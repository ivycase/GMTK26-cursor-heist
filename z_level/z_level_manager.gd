extends Node2D

enum Layers {BASE, VENT}

@export var vents: Array[Zone]

@export var active_z_level: Layers

@export var base_level_parent: Node2D
@export var base_level_tilemap: TileMapLayer

@export var vent_level_parent: Node2D
@export var vent_level_tilemap: TileMapLayer

var yeet_zone: Vector2 = Vector2(5000, 5000)
var yeet_parent: Node2D

func _ready() -> void:
	for vent in vents:
		vent.entered_zone.connect(toggle_z_level)
		vent.top_level = true
		
	yeet_parent = Node2D.new()
	yeet_parent.global_position = yeet_zone
	vent_level_parent.reparent.call_deferred(yeet_parent) # just yeet is somewhere else lmfao

func toggle_z_level(_node: Node2D) -> void:
	ez_sound.play_sfx("release.wav")
	
	if Global.mouse_holder and Global.mouse_holder is DragComponent:
		Global.mouse_holder.dragged_node.reparent.call_deferred(vent_level_parent if active_z_level == Layers.BASE else base_level_parent)
	
	match active_z_level:
		Layers.BASE:
			active_z_level = Layers.VENT
			
			base_level_parent.reparent.call_deferred(yeet_parent) # just yeet is somewhere else lmfao
			vent_level_parent.reparent.call_deferred(get_parent()) # just unyeet is somewhere else lmfao
			
			base_level_parent.hide()
			base_level_tilemap.collision_enabled = false
			
			vent_level_parent.show()
			vent_level_tilemap.collision_enabled = true
			
		Layers.VENT:
			active_z_level = Layers.BASE
			
			vent_level_parent.reparent.call_deferred(yeet_parent) # just yeet is somewhere else lmfao
			base_level_parent.reparent.call_deferred(get_parent()) # just unyeet is somewhere else lmfao
			
			vent_level_parent.hide()
			vent_level_tilemap.collision_enabled = false
			
			base_level_parent.show()
			base_level_tilemap.collision_enabled = true
