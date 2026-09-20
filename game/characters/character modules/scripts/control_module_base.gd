extends CharacterModule
class_name ControlModule

@export var use_player_override_as_default: bool = false

var movement_input:= Vector2(0, 0)
var active_inputs: Dictionary[ModularCharacter.CharacterAction, bool]
var input_mode: Callable



signal ability_activation
#signal finished		#	Path finding -funktioita varten

func _ready() -> void:
	switch_to_default_input()
	_init_ability_input_dict()

func _process(delta) -> void:
	input_mode.call(delta)

func _init_ability_input_dict() -> void:	# Initializes the ability input dict (duh)
	for i in ModularCharacter.CharacterAction.keys():
		active_inputs[i] = false




#	CPU control functions:
func main_loop(_delta):	#	Keep this empty in the base class. (that means right here)
	pass


func ability_input_press(action: ModularCharacter.CharacterAction) -> void:# Voi toimia vähän jännästi
	active_inputs[action] = true
	await get_tree().process_frame
	active_inputs[action] = false


func ability_input_hold(action: ModularCharacter.CharacterAction, duration: float = 0) -> void:
	active_inputs[action] = true
	await Ses.wait(duration)
	active_inputs[action] = false


func ability_input_toggle(action: ModularCharacter.CharacterAction, mode: bool) -> void:
	active_inputs[action] = mode


func switch_to_player_input() -> void:
	input_mode = _player_input


func switch_to_ai_input() -> void:
	input_mode = main_loop


func switch_to_default_input() -> void:
	if use_player_override_as_default == true:
		input_mode = _player_input
	else:
		input_mode = main_loop



"""#	Tee nää sit ku kartat on jotenki kasattu
func move_to_position(position: Vector2):
	# Vitun hienoa path findaamista
	finished.emit(position)

func move_through_route(positions: Array[Vector2]):
	pass

func _path_finder(global_position: Vector2):
	pass
"""



#	Player control functions:

func _player_input(_delta):
	movement_input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	movement_input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	if Input.is_action_just_pressed("FirePrimary"):
		_player_ability_input("FirePrimary", ModularCharacter.CharacterAction.FIRE_PRIMARY)
	if Input.is_action_just_pressed("FireSecondary"):
		_player_ability_input("FireSecondary", ModularCharacter.CharacterAction.FIRE_SECONDARY)
	if Input.is_action_just_pressed("AbilityPrimary"):
		_player_ability_input("AbilityPrimary", ModularCharacter.CharacterAction.ABILITY_PRIMARY)
	if Input.is_action_just_pressed("AbilitySecondary"):
		_player_ability_input("AbilitySecondary", ModularCharacter.CharacterAction.ABILITY_SECONDARY)
	if Input.is_action_just_pressed("AbilityDefensive"):
		_player_ability_input("AbilityDefensive", ModularCharacter.CharacterAction.ABILITY_DEFENSIVE)
	if Input.is_action_just_pressed("AbilityUltimate"):
		_player_ability_input("AbilityUltimate", ModularCharacter.CharacterAction.ABILITY_ULTIMATE)


#	Täs hajoo ihan varmasti vielä jotain
func _player_ability_input(input_name: String, action_id: ModularCharacter.CharacterAction) -> void:
	active_inputs[action_id] = true
	ability_activation.emit(action_id)
	while Input.is_action_pressed(input_name):
		await get_tree().process_frame
	active_inputs[action_id] = false
