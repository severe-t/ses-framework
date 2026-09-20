extends CharacterModule
class_name AbilityModule


var ability_metadata: Dictionary[ModularCharacter.CharacterAction, Dictionary]


var active_process: Callable = idle
@export var ability_sheet: AbilitySheet	#	Stores a set of ability ID's for a character/combat stance

var ability_instances: Dictionary[ModularCharacter.CharacterAction, Ability]


func _process(_delta) -> void:
	active_process.call()


func idle():
	pass


func listen_to_inputs():
	for i in ability_instances:
		if control_module.active_inputs.get(i, false):
			ability_instances[i].instantiate()


func _module_ready() -> void:
	load_abilities()
	character = get_parent()#	Erroraa tarkotuksella paskaks jos ei ole modular characteria parentina
	if character.control_module:
		control_module = character.control_module
		active_process = listen_to_inputs


#	Input
func activate_ability(action_id: ModularCharacter.CharacterAction):
	var new_ability = GameIndex.abilities[ability_instances[action_id]].instantiate()
	new_ability.source_control_module = character.control_module
	add_child(new_ability)


func load_new_ability_sheet(new_ability_sheet: AbilitySheet):
	ability_sheet = new_ability_sheet
	load_abilities()


func load_abilities():#	Jos käynnistys on paska niin lataa scenet vasta täällä!
	var ability_dict
	if !ability_sheet:
		ability_dict = AbilitySheet.get_empty_dict()
	else:
		ability_dict = ability_sheet.get_as_dict()
	for i in ability_dict:
		ability_instances[i] = GameIndex.abilities[ability_dict[i]]
	for i in ability_instances:
		ability_metadata[i] = ability_instances[i].metadata
