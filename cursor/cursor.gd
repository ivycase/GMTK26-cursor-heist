class_name Cursor
extends CharacterBody2D

signal click
signal release

@export_group("Nodes")
@export var interact_area: Area2D
@export var sprite: Sprite2D

@export_group("Properties")
@export var move_speed: float = 100.0
@export_range(0.0, 1.0) var decelerate_speed: float = 0.2

var start_position: Vector2

func _ready() -> void:
	Global.active_cursor = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	start_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_click_event(event)
	
	if event is InputEventMouseMotion:
		_handle_move_event(event)
		
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if sprite:
		sprite.global_position = global_position + velocity / 50.0
		
	velocity = lerp(velocity, Vector2.ZERO, decelerate_speed)
	
func _handle_click_event(event: InputEventMouseButton) -> void:
	if event.button_index != 1:
		return
	elif event.is_pressed():
		click.emit()
	else:
		release.emit()
	
func _handle_move_event(event: InputEventMouseMotion) -> void:
	velocity = event.screen_relative * move_speed
