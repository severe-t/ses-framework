extends CharacterModule
class_name AbilityModule

var parent_character: ModularCharacter


#	Name, cooldown, sprite, all the other shit



var ability_ids: Dictionary[ModularCharacter.CharacterAction, Ability.id]#	List of assigned ability_ids per CharacterAction
@export var ability_sheet: AbilitySheet	#	Stores a set of ability ID's for a character/combat stance



#	Input
func activate_ability(action_id: ModularCharacter.CharacterAction):
	GameIndex.ability_preloads[ability_ids[action_id]].activate()


func _ready() -> void:
	init_ability_sheet()
	parent_character = get_parent()	#	Erroraa tarkotuksella paskaks jos ei ole modular characteria parentina
	if parent_character.control_module:
		parent_character.control_module.ability_activation.connect(activate_ability)


func init_ability_sheet():
	if !ability_sheet:
		return "FUCK"
	ability_ids = ability_sheet.get_as_dict()


func load_new_ability_sheet(new_ability_sheet):
	if !ability_sheet:
		return "SHIT"
	ability_ids = new_ability_sheet.get_as_dict()
