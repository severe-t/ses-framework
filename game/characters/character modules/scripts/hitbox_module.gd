extends CharacterModule
class_name HitboxModule

@export var parent: CharacterBody2D

var damage:int = -1

#	The "damage" variable is taken from parent automatically unless configured manually.
#	If "damage" doesn't exist in parent, the damage will be set to zero.

#	Not that I think about it, that first damage check might be pointless, since it might be	
#	impossible to configure the damage before the module has already loaded and the set the damage 
#	for itself...

#	Aaaah well doesn't hurt to be like that either. I think.

#	Remember to check that the damage actually gets loaded properly from 'gun' to 'bullet' to 'hitbox'

func _ready():
	connect("area_entered", on_area_entered)
	if damage < 0:
		if "damage" in parent:#		Testaa!
			damage = parent.damage
		else:
			damage = 0

func on_area_entered(collider):
	collision()
	

func collision():

	pass