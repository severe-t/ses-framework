extends Resource
class_name AbilitySheet

enum id{
	EMPTY,
	TEST,
	JESSE_STANDARD,
	JESSE_POWER,
	JESSE_SPEED,
	JESSE_SMART,
	ENEMY_TEST,
}

@export var selected_id: id

@export_category ("Abilities")
@export var ability_fire_primary: Ability.Id = Ability.Id.NONE
@export var ability_fire_secondary: Ability.Id = Ability.Id.NONE
@export var ability_ability_primary: Ability.Id = Ability.Id.NONE
@export var ability_ability_secondary: Ability.Id = Ability.Id.NONE
@export var ability_ability_defensive: Ability.Id = Ability.Id.NONE
@export var ability_ability_ultimate: Ability.Id = Ability.Id.NONE


static func get_empty_dict():
	var dict: Dictionary = {
		ModularCharacter.CharacterAction.FIRE_PRIMARY: Ability.Id.NONE,
		ModularCharacter.CharacterAction.FIRE_SECONDARY: Ability.Id.NONE,
		ModularCharacter.CharacterAction.ABILITY_PRIMARY: Ability.Id.NONE,
		ModularCharacter.CharacterAction.ABILITY_SECONDARY: Ability.Id.NONE,
		ModularCharacter.CharacterAction.ABILITY_DEFENSIVE: Ability.Id.NONE,
		ModularCharacter.CharacterAction.ABILITY_ULTIMATE: Ability.Id.NONE,
	}
	return dict


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
