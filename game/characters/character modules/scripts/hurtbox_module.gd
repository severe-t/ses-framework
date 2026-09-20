extends CharacterModule
class_name HurtboxModule


signal received_damage(damage)

func _ready():
	connect("area_entered", on_area_entered)


func on_area_entered(hitbox):
	if hitbox is HitboxModule:
		health_module.take_damage(hitbox.damage)
		received_damage.emit()
