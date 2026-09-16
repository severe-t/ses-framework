extends Resource
class_name AbilitySheet
@export var sheet_name: String

@export_category ("Abilities")
@export var ability_fire_primary: Ability.id = Ability.id.NONE
@export var ability_fire_secondary: Ability.id = Ability.id.NONE
@export var ability_ability_primary: Ability.id = Ability.id.NONE
@export var ability_ability_secondary: Ability.id = Ability.id.NONE
@export var ability_ability_defensive: Ability.id = Ability.id.NONE
@export var ability_ability_ultimate: Ability.id = Ability.id.NONE


@export var ability_sheet_dict: Dictionary[ModularCharacter.CharacterAction, Ability.id] = {
	ModularCharacter.CharacterAction.FIRE_PRIMARY: Ability.id.NONE


}




func get_as_dict():
	var dict: Dictionary = {
		ModularCharacter.CharacterAction.FIRE_PRIMARY: ability_fire_primary,
		ModularCharacter.CharacterAction.FIRE_SECONDARY: ability_ability_secondary,
		ModularCharacter.CharacterAction.ABILITY_PRIMARY: ability_ability_secondary,
		ModularCharacter.CharacterAction.ABILITY_SECONDARY: ability_ability_secondary,
		ModularCharacter.CharacterAction.ABILITY_DEFENSIVE: ability_ability_secondary,
		ModularCharacter.CharacterAction.ABILITY_ULTIMATE: ability_ability_secondary,
	}
	return dict




