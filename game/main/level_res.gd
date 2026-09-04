extends Resource
class_name Level

enum id {
	LEVEL_1,
	LEVEL_2,
	TEST_ENVIRONMENT,
	TUTORIAL,
}

@export var selected_id: id
@export var name: String = "Null"
@export var path: String