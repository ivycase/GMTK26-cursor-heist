class_name DoorComponent
extends Node2D

@export var connected_button: ButtonComponent
@export var is_start_closed: bool = true
@export var static_body: StaticBody2D
@export var closed_sprite: Sprite2D
@export var opened_sprite: Sprite2D

var is_closed: bool
var nodes_on_top: Array[Node2D]

func _ready() -> void:
	await get_tree().physics_frame
	_late_ready()

func _late_ready() -> void:
	connected_button.update_power.connect(_update_door)
	is_closed = is_start_closed
	update_visual()

func _update_door(trigger_node: Node2D, new_power: bool) -> void:
	var index: int = nodes_on_top.find(trigger_node)
	if index == -1:
		nodes_on_top.append(trigger_node)
	else:
		nodes_on_top.remove_at(index)
		
	if !new_power and len(nodes_on_top) > 0: # still things on the button
		return 
	
	is_closed = is_start_closed != new_power
	static_body.collision_layer = int(is_closed) #layer one is wall layer
	update_visual()

func update_visual() -> void:
	if !opened_sprite or !closed_sprite:
		return
	
	if is_closed:
		opened_sprite.hide()
		closed_sprite.show()
	else:
		opened_sprite.show()
		closed_sprite.hide()
