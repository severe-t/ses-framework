extends CharacterModule
class_name ControlModule
var action = GameEnums.ActionInput

signal action_input(press, hold)


func get_movement_input():
	pass

func attack():
	action_input.emit(action.ATTACK, action.ATTACK)

func reload():
	action_input.emit(action.RELOAD, action.RELOAD)
	
func dodge():
	action_input.emit(action.DODGE, action.DODGE)