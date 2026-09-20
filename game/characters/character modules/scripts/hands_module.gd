extends CharacterModule
class_name HandsModule

@export var input_source: ControlModule
#@export var equipped_weapon: Weapon
var fists#: = load(something_something_fists)

@export var primary_action: Callable
@export var secondary_action: Callable



func listen_to_inputs():
	if input_source.active_inputs.get(ModularCharacter.CharacterAction.FIRE_PRIMARY, false) == true:
		primary_attack()
	if input_source.active_inputs.get(ModularCharacter.CharacterAction.FIRE_SECONDARY, false) == true:
		secondary_attack()


func primary_attack():

	pass


func secondary_attack():

	pass



func _ready():
	pass


func equip_weapon():
	pass


func equip_fists():
	pass


func switch_weapons():
	pass

