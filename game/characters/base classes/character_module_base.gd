extends Node
class_name CharacterModule


#func update_hud(_hud_element:int, _value):
#	SignalManager.update_hud(_hud_element, _value)


#	Jotain tollasta. Mutta tee kunnolla

#@onready var character: ModularCharacter = get_parent()
#@onready var input_source = character.control_module

var character: ModularCharacter

var control_module
var health_module
var hurtbox_module
var movement_module
var hands_module
var ability_module


func _ready():
	_init_module_refs()
	_module_ready()


func _module_ready():
	pass


func input_just_pressed(action: ModularCharacter.CharacterAction):
	pass


func input_pressed(action: ModularCharacter.CharacterAction):
	return control_module.active_inputs(action)


func _init_module_refs() -> void:#	I'm really testing the patience of this engine.
	var parent = get_parent()
	if parent is not ModularCharacter:
		return

	if parent.control_module:
		control_module = parent.control_module
		control_module.ability_activation.connect(input_just_pressed)
	if parent.health_module:
		health_module = parent.health_module
	if parent.hurtbox_module:
		hurtbox_module = parent.hurtbox_module
	if parent.movement_module:
		movement_module = parent.movement_module
	if parent.hands_module:
		hands_module = parent.hands_module
	if parent.ability_module:
		ability_module = parent.ability_module
