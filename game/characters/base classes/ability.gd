extends Node2D
class_name Ability

enum ActivationType{
	PRESS,
	HOLD,
	TOGGLE,
	PASSIVE
}


enum id{
	NONE,
	WEAPON_PRIMARY,
	WEAPON_SECONDARY,
	
	FAN_THE_HAMMER,
	DODGE_BASIC,
	COUNTER,
	SNIPER_SHOT,
	SMOKELESS_POWDER,

	STOMP,
	GUARD,
	GUARD_SUPER,
	
	DODGE_SPEED,
	DODGE_SPEED_CANCEL,
	DODGE_SPEED_TO_CURSOR
}

@export var selected_id: id
@export var activation_type: ActivationType


var source_id = "Ability"

var ability_name: String
var cooldown: float


func activate():
	Ses.log(self, 0, "Ability: default activation")
	