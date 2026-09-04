extends CharacterModule
class_name HealthModule

@export var parent: CharacterBody2D
@export var value_hud_connection: GameEnums.HUDElement = GameEnums.HUDElement.NONE
@export var max_value_hud_connection: GameEnums.HUDElement = GameEnums.HUDElement.NONE
@export var value: float
@export var max_value: float

signal value_changed(value)
signal max_value_changed(max_value)


@export var over_heal_default_setting: bool = false




func death():
	parent.queue_free()


func set_value(amount:float, override := over_heal_default_setting):
	value = amount
	if override == over_heal_default_setting:
		if value > max_value:
			value = max_value
	value_changed.emit(value)
	update_hud(value_hud_connection, value)
	if value <= 0:
		death()


func set_max_value(amount:float):
	max_value = amount
	if value > max_value:
		set_value(max_value)
	max_value_changed.emit(max_value)
	update_hud(max_value_hud_connection, max_value)


func calculate_max_value_percentage(p: float):# Probably inaccurate as fuck
	var multiplier:float = p / 100
	var amount:float = max_value * multiplier
	return amount


func set_value_p(p:float, override := over_heal_default_setting):
	var amount = calculate_max_value_percentage(p)
	set_value(amount, override)


func take_damage(amount:float):
	var new_value = value - amount
	set_value(new_value)


func take_damage_p(p:float):	
	var amount = calculate_max_value_percentage(p)
	var new_value = value - amount
	set_value(new_value)


func heal(amount:float, override = over_heal_default_setting):
	var new_value = value + amount
	set_value(new_value, override)


func heal_p(p:float, override = over_heal_default_setting):
	var amount = calculate_max_value_percentage(p)
	var new_value = value + amount
	set_value(new_value, override)


func set_max_value_p(p:float):
	var amount = calculate_max_value_percentage(p)
	set_max_value(amount)


func raise_max_value(amount:float):
	var new_max_value = max_value + amount
	set_max_value(new_max_value)


func raise_max_value_p(p:float):
	var amount = calculate_max_value_percentage(p)
	var new_max_value = max_value + amount
	set_max_value(new_max_value)


func lower_max_value(amount:float):
	var new_max_value = max_value - amount
	set_max_value(new_max_value)


func lower_max_value_p(p:float):
	var amount = calculate_max_value_percentage(p)
	var new_max_value = max_value - amount
	set_max_value(new_max_value)