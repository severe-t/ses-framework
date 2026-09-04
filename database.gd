extends Node
class_name Database

enum SoundEffectID {
	REVOLVER_DEFAULT,
	REVOLVER_POWER,
}

@export var sound_effects: Dictionary[SoundEffectID, SoundEffect] = {}