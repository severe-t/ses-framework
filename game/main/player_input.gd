
extends Node

var is_enabled: bool = true

var movement_input:= Vector2(0,0)
var input_held: Dictionary


signal fire_primary
signal fire_secondary
signal ability_primary
signal ability_secondary
signal ability_defensive
signal ability_ultimate


func ready():
	for i in ModularCharacter.CharacterAction:
		input_held[ModularCharacter.CharacterAction] = false
	pass


func _process(delta: float) -> void:
	get_movement_input()
	if Input.is_action_pressed("FirePrimary"):
		pass
	

func get_movement_input():# -> Vector2:
	movement_input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	movement_input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))


func is_action_held(action_name: StringName) -> bool:
	return is_enabled and Input.is_action_pressed(action_name)


	