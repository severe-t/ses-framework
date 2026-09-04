extends Node

#@onready var Main = $self
#@onready var GameplayLayer = $%World2D
#@onready var GuiLayer = $%UiEnvironment
#@onready var menu_manager = $%MenuManager

var main
var GameplayLayer
var GuiLayer
var menu_manager

var uses_signals = true
var thread: Thread

var loaded_resource: PackedScene = null

var source_id = "Main"

#var menu_array = Index.menus.keys()
#@export var base_menu: int = []

@export var levels: Array[Level]
var level_dict: Dictionary = {}

@export var menus: Array[Menu]
var menu_dict: Dictionary = {}

func _ready() -> void:
	main = self
	GameplayLayer = $GameplayLayer
	GuiLayer = $GuiLayer
	#menu_manager = $%MenuManager

	GuiLayer.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	menu_manager.mouse_filter = Control.MOUSE_FILTER_IGNORE
#	load_menu("test_menu")

	for level: Level in levels:
		level_dict[level.selected_id] = level
	
	for menu: Menu in menus:
		menu_dict[menu.selected_id] = menu

	load_menu(Menu.id.TEST_MENU)


func change_level(level_path: String):
	var loaded_level = _load_scene(level_path)
	get_tree().change_scene_to_packed(loaded_level)



func load_level(id: Level.id):
	var level = level_dict[id]
	var level_path = level.path
	if level_path is not String:
		Ses.out(self, Color.RED, "Error loading level: '", level.name, "' was not found in the index.")
		return null
	var level_scene = _load_scene(level_path)
	if level_scene == null:
		return
	clear_all()
	var level_instance = level_scene.instantiate()
	GameplayLayer.add_child(level_instance)



func load_menu(id: Menu.id):
	var menu = menu_dict[id]
	var menu_path = menu.path
	if menu_path is not String:
		Ses.out(self, Color.RED, "Error loading menu: '", menu.name, "' was not found in the index.")
		return null
	var menu_scene = _load_scene(menu_path)
	if menu_scene == null:
		return
	clear_all()
	var menu_instance = menu_scene.instantiate()
	GuiLayer.add_child(menu_instance)



func _load_scene(scene_path):
	if scene_path is not String:
		Ses.out(self, Color.RED, "Error loading scene: Invalid path type. Expected String. It is likely that the fetched scene wasn't found in the index.")
		return null
	var scene
	if scene_path != null:
		scene = load(scene_path)
	else:
		Ses.out(self, Color.RED, "Error loading scene: path '", scene_path, "' is not valid." )
		return
	if scene is PackedScene:
		return scene
	else:
		return null



func clear_current_level():
	for child in GameplayLayer.get_children():
		child.queue_free()



func clear_current_menu():
	for element in GuiLayer.get_children():
		element.queue_free()



func clear_all():
	clear_current_level()
	clear_current_menu()


"""
func on_command_signal(id, command, data):
	match id:
		"Main":
			match command:
				"load_level":
					load_level(data)
				"load_menu":
					load_menu(data)
"""
