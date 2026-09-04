extends Resource
class_name Menu

enum id {
	MAIN_MENU,
	TEST_MENU,
}

@export var selected_id: id
@export var path: String