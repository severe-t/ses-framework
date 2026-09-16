extends CharacterModule
class_name ControlModule

@export var use_player_override_as_default: bool = false

var movement_input:= Vector2(0, 0)
var ability_inputs: Dictionary[ModularCharacter.CharacterAction, bool]

var input_mode: Callable


signal ability_activation


func player_input(_delta):

	movement_input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	movement_input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	if Input.is_action_just_pressed("FirePrimary"):
		ability_input("FirePrimary", ModularCharacter.CharacterAction.FIRE_PRIMARY)
	if Input.is_action_just_pressed("FireSecondary"):
		ability_input("FireSecondary", ModularCharacter.CharacterAction.FIRE_SECONDARY)
	if Input.is_action_just_pressed("AbilityPrimary"):
		ability_input("AbilityPrimary", ModularCharacter.CharacterAction.ABILITY_PRIMARY)
	if Input.is_action_just_pressed("AbilitySecondary"):
		ability_input("AbilitySecondary", ModularCharacter.CharacterAction.ABILITY_SECONDARY)
	if Input.is_action_just_pressed("AbilityDefensive"):
		ability_input("AbilityDefensive", ModularCharacter.CharacterAction.ABILITY_DEFENSIVE)
	if Input.is_action_just_pressed("AbilityUltimate"):
		ability_input("AbilityUltimate", ModularCharacter.CharacterAction.ABILITY_ULTIMATE)









#	Täs hajoo ihan varmasti vielä jotain
func ability_input(input_name: String, action_id: ModularCharacter.CharacterAction):
	ability_inputs[action_id] = true
	ability_activation.emit(action_id)
	while Input.is_action_pressed(input_name):
		pass
	ability_inputs[action_id] = false


func _ready():
	reset_player_override_to_default()
	init_ability_input_dict()




func _process(delta):
	input_mode.call(delta)


func toggle_player_override(a: bool):
	if a == true:
		input_mode = player_input
	else:
		input_mode = module_input


func reset_player_override_to_default():
	toggle_player_override(use_player_override_as_default)




func module_input(_delta):	#	Keep this empty in the base class. (that means right here)
	pass




func init_ability_input_dict():	# Initializes the ability input dict (duh)
	for i in ModularCharacter.CharacterAction.keys():
		ability_inputs[i] = false
