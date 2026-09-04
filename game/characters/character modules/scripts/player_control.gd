extends ControlModule
class_name PlayerControl

@export var parent: CharacterBody2D
@export var enable_wasd: bool = true
@export var look_at_cursor: bool = true

var movement_input : Vector2



func _process(_delta):
	if look_at_cursor == true:
		parent.look_at(get_viewport().get_mouse_position())
	get_movement_input()
	if Input.is_action_just_pressed("attack"):
		action_input.emit(action.ATTACK, action.ATTACK)
	if Input.is_action_just_pressed("reload"):
		action_input.emit(action.RELOAD, action.RELOAD)
	if Input.is_action_just_pressed("dodge"):
		action_input.emit(action.DODGE, action.DODGE)

	if Input.is_action_pressed("attack"):
		action_input.emit(action.NULL,action.ATTACK)
	if Input.is_action_pressed("reload"):
		action_input.emit(action.NULL,action.RELOAD)
	if Input.is_action_pressed("dodge"):
		action_input.emit(action.NULL,action.DODGE)

func get_movement_input():# -> Vector2:
	if enable_wasd == true:
		movement_input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		movement_input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))


func construct_signal(press:int, hold:int):
	action_input.emit(press, hold)
