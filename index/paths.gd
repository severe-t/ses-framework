extends Node
class_name Paths

@export_category ("Loaded at runtime")
@export var level: Dictionary[Level.id, String]
@export var menu: Dictionary[Menu.id, String]


@export_category("Loaded at game start")
#@export var _sound_effects: Dictionary[SoundEffect.id, String]
#@export var _background_music: Dictionary[Bgm.id, String]
#@export var _background_sound: Dictionary[Bgs.id, String]
#@export var _ability_sheet: Dictionary[AbilitySheet.id, String]



func fetch_path():

	pass


func fetch_packed_scene():

	pass