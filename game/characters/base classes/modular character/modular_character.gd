extends CharacterBody2D
class_name ModularCharacter
 #CharacterAction: GameIndex.CharacterAction

@export var source_id: String = "ModularCharacter"


enum CharacterAction{
	FIRE_PRIMARY,
	FIRE_SECONDARY,
	ABILITY_PRIMARY,
	ABILITY_SECONDARY,
	ABILITY_DEFENSIVE,
	ABILITY_ULTIMATE,
}
#	MODULE SLOTS
@export var use_player_input: bool = false

@export_category ("Modules")
@export var control_module : ControlModule
@export var health_module: HealthModule
@export var hurtbox_module: HurtboxModule
@export var movement_module: MovementModule
@export var hands_module: HandsModule
@export var ability_module: AbilityModule


@export_category ("Abilities")

"""
@export var ability_fire_primary: AbilityModule
@export var ability_fire_secondary: AbilityModule
@export var ability_ability_primary: AbilityModule
@export var ability_ability_secondary: AbilityModule
@export var ability_ability_defensive: AbilityModule
@export var ability_ability_ultimate: AbilityModule
"""

#	CharacterAction == List of possible actions that a character can make. Inputs are bound to these
#	AbilityModule == "Wrapper" around the ability. Keeps track of info outside of a single ability's instance such as previous casts


var held_inputs: Dictionary[CharacterAction, bool]#	List of character action inputs and whether they are currently pressed

var abilities: Dictionary[CharacterAction, Ability.id]#	List of assigned abilities per CharacterAction
@export var ability_sheet: AbilitySheet	#	Stores a set of ability ID's for a character/combat stance

@export var abilities_enabled: bool = false	#	Just to avoid errors when a character does not have abilities.


func character_death():
	self.queue_free()
	pass
