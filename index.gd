extends Node
class_name Index

const _menu_path: String = ""
const _level_path: String = ""
const _object_path: String = ""
const _character_path: String = ""
const _weapon_path: String = ""
const _projectile_path: String = ""
const _module_path: String = ""
const _test_data_path: String = ""

enum Category {
	OBJECT,
	WEAPON,
	PROJECTILE,
	CHARACTER,
	LEVEL,
	MENU,
	HUD,
	DATA,
	SFX,
	BGM,
	BGS,
	ABILITY_SHEET,
}

const _paths: Dictionary = {
	Category.OBJECT: "res://game/objects/misc/",
	Category.WEAPON: "res://game/objects/weapons/",
	Category.PROJECTILE: "res://game/objects/projectiles/",
	Category.CHARACTER: "res://game/character_builds/scenes/",
	Category.LEVEL: "res://game/levels/",
	Category.MENU: "res://game/menus/",
	Category.HUD: "res://game/hud/",
	Category.DATA: "res://game/data/",
	Category.SFX: "res://game/assets/sfx sound_effects/",
	Category.BGM: "res://game/assets/bgm soundtracks/",
	Category.BGS: "res://game/assets/bgs background_sounds/",
	Category.ABILITY_SHEET: "res://game/characters/ability sheets/saved sheets/"
}

enum {
	MENU_TEST,
	MENU_NULL,

	WEAPON_REVOLVER_DEFAULT,
	WEAPON_REVOLVER_POWER,
	WEAPON_REVOLVER_SPEED,
	WEAPON_REVOLVER_SMART,


	TESTDATA_0,
	TESTDATA_1,
	TESTDATA_2,
	TESTDATA_3,
	TESTDATA_4,
	TESTDATA_5,
	TESTDATA_6,
	TESTDATA_7,
	TESTDATA_8,
	TESTDATA_9,

}



const _categories: Dictionary = {
	Category.OBJECT: _object,
	Category.WEAPON: _weapon,
	Category.PROJECTILE: _projectile,
	Category.CHARACTER: _character,
	Category.LEVEL: _level,
	Category.MENU: _menu,
	Category.DATA: _data,
	Category.HUD: _hud,
	Category.SFX: _sound_effects,
	Category.BGM: _background_music,
	Category.BGS: _background_sound,
	Category.ABILITY_SHEET: _ability_sheet,
}



static var big_dict: Dictionary

static var index_ready: bool = false


func _init():
	smart_merge()
	index_ready = true


func smart_merge():
	for c in Category.size():
		var folder_path = _paths[c]
		for id in _categories[c]:
			var file_name: String = _categories[c][id]
			big_dict.set(id, folder_path.path_join(file_name))


static func fetch(key: int):
	return big_dict[key]

const _object: Dictionary = {}
const _weapon: Dictionary = {}
const _projectile: Dictionary = {}
const _character: Dictionary = {}

const _level: Dictionary = {}

const _menu: Dictionary = {
	MENU_TEST: "res://game/scenes/gui/menus/test_menu.tscn",
	MENU_NULL: "not a real address",
}

const _hud: Dictionary = {}

const _sound_effects: Dictionary = {}
const _background_music: Dictionary = {}
const _background_sound: Dictionary = {}
const _ability_sheet: Dictionary = {}


#	Tekstiavaimet alunperin konsolin vuoksi
const _data: Dictionary[String, String] = {
	"test_0": "res://scenes/gui/menus/test_menu.tscn",
	"test_1": "res://scenes/gui/menus/test_menu.tscn",
	"test_2": "res://scenes/gui/menus/test_menu.tscn",
	"test_3": "res://scenes/gui/menus/test_menu.tscn",
	"test_4": "res://scenes/gui/menus/test_menu.tscn",
	"test_5": "res://scenes/gui/menus/test_menu.tscn",
	"test_6": "res://scenes/gui/menus/test_menu.tscn",
	"test_7": "res://scenes/gui/menus/test_menu.tscn",
	"test_8": "res://scenes/gui/menus/test_menu.tscn",
	"test_9": "res://scenes/gui/menus/test_menu.tscn",
}

