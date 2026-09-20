extends Node2D
class_name Ability

enum InputType{
	PRESS,
	HOLD,
	TOGGLE,
	PASSIVE,
	DYNAMIC,
}

enum Id{
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

enum AbilityType{
	STANDARD,
	REROUTE_TO_HANDS,
}


@export var create_node_instance: bool = true
@export var selected_id: Id
@export var input_type: InputType
@export var ability_type: AbilityType = AbilityType.STANDARD

var parent_character: ModularCharacter
var source_control_module: ControlModule

var source_id = "Ability"	# FOR SES.LOG

var ability_name: String
var cooldown: float
var metadata: Dictionary

signal ability_finished

func _ready():
	if ability_type == AbilityType.REROUTE_TO_HANDS:
		reroute_to_hands_module(selected_id)
	else:
		activate()
	terminate()


func reroute_to_hands_module(id: Id):

	pass


func activate():
	Ses.log(self, 0, "Ability: default activation")
	
func terminate():
	ability_finished.emit()
	queue_free()


func _exit_tree() -> void:
	pass


func instantiate_node():
	pass


func delayed_function(callable: Callable, delay_seconds:float)-> void:	# Käytä .bind() argumentteja varten!
	var timer: Timer = Timer.new()
	timer.wait_time = delay_seconds
	timer.timeout.connect(callable)


func apply_effect(target: Node, seconds:float):
	pass