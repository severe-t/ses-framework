extends SesLibrary
class_name Sestem

var source_id = "Sestem"

#enum CommandArgumentQuantity{NOT_ACCEPTED, REQUIRED, OPTIONAL,}


#S3T (Severi's shitty signal terminal):
signal console_print
signal console_new_line


var ses_out_log: Array[LogEntry]
var s3t_history: Array[LogEntry]
#/

var command_directories: Dictionary[String, Dictionary]
var command_suggestions: Array

@export var default_settings: SettingsList
var settings: SettingsList
var rng = RandomNumberGenerator.new()
@export var console: SestemConsole
@export var commannddddd: Callable

func cmd():

	pass



func _init():
	_init_file_paths()

func _ready():
	init_settings()
	sestem_ready = true

func _init_file_paths():
	init_path(ses_log_folder)
	init_path(backup_folder)
	init_path(dump_folder)
	init_path(save_folder)
	init_path(settings_folder)
	init_path(test_folder)


func init_path(path: String):
	if not DirAccess.dir_exists_absolute(path):
		var error = DirAccess.make_dir_recursive_absolute(path)
		if error != OK:
			print("FUCK")
			quit_game()
		else:
			out(self, Color.WHITE, "Created directory at path: ", path)


#	Suggestion-listan eka versio, hyvin simppeli:

func simple_sugg(input_text: String = ""):
	if input_text == "":
		return
	var root_directory = command_directories["root"]
	var available_commands = root_directory.keys()
	for key in available_commands:
		var command_name: String = command_directories[key].command_name
		#var dir_name: String
		var suggestion: String
		if key == "root":
			suggestion = command_name



func init_settings():
	settings = default_settings.duplicate()
	var result = load_settings()
	if result == false:
		save_settings()

func save_settings():
	var exported_settings = settings.export()
	var result = save_as_binary("game_settings", exported_settings, folder.SETTINGS)
	if result == true:
		console.print_text("Settings saved")
	else:
		out(self, Color.RED, "Failed to save settings")

func load_settings():
	var imported_settings = load_file("game_settings", folder.SETTINGS)
	if imported_settings:
		settings.import(imported_settings)
		console.print_text("Settings loaded")
		cmd_list_settings()
		return true
	else:
		out(self, Color.WHITE, "No settings file was found. Creating one...")
		return false



	

func cmd_list_settings():
	var settings_array: Array
	var settings_dict = settings.export()
	var settings_keys = settings_dict.keys()
	for k in settings_keys:
		var value_array: Array = [k, str(settings_dict[k])]
		settings_array.append(value_array)
	console.print_text("Current settings in memory:")
	console.print_text(create_table_from_nested_array(2, settings_array, 8))


func cmd_edit_setting(arguments: PackedStringArray):
	var settings_dict = settings.export()
	#var selected_setting = settings_dict.get(arguments[0])
	if settings_dict.has(arguments[0]):
		var new_value = convert_type_strict(arguments[1], typeof(settings_dict[arguments[0]]))
		settings_dict.set(arguments[0], new_value)
		console.print_text(arguments[0]+" set to " + str(new_value))
	settings.import(settings_dict)


func reset_settings_to_defaults():
	settings = default_settings.duplicate()
	console.print_text("Settings reset to defaults.")




func auto_match(callable: Callable, ...args):#	Does NOT support Arrays or Dictionaries!
	auto_match_arr(callable, args)

func auto_match_arr(callable: Callable, args: Array):
	var types = get_arg_types(callable)
	if args.size() < get_required_arg_count(callable):
		return
	var margs = match_array(args, types)
	if margs == null:
		return
	callable.callv(margs)

	

func match_args(callable: Callable, ...args):
	var types = get_arg_types(callable)
	if args.size() < get_required_arg_count(callable):
		return null
	var margs = match_array(args, types)
	if margs == null:
		return null
	return margs


func get_arg_types(callable: Callable) -> Array:
	var types: Array[Variant.Type]
	var obj: Object = callable.get_object()
	
	if callable.is_valid() == false:
		return types
	
	for method in obj.get_method_list():
		if method["name"] == callable.get_method():
			for arg in method["args"]:
				types.append(arg["type"] as Variant.Type)
				break

	return types


func get_required_arg_count(callable: Callable) -> int:
	if not callable.is_valid():
		return 0
	var obj: Object = callable.get_object()
	var method_name: StringName = callable.get_method()
	var total_args: int = obj.get_method_argument_count(method_name)
	var default_args: int = 0
	if obj.get_script():
		for method in obj.get_script().get_script_method_list():
			if method["name"] == method_name:
				default_args = method["default_args"].size()
				break
	return total_args - default_args


func convert_type_strict(input, wanted_type: int):
	if typeof(input) == wanted_type:
		return input
	match wanted_type:
		TYPE_BOOL:
			if input is int or input is float:
				if input == 1 or input >= 1.0: return true
				if input == 0 or input < 1.0: return false
			elif input is String:
				var clean: String = input.strip_edges().to_lower()
				if clean in ["true", "1"]: return true
				if clean in ["false", "0"]: return false
		TYPE_INT:
			if input is float:
				return int(input)
			if input is String and input.is_valid_int():
				return input.to_int()
		TYPE_FLOAT:
			if input is int:
				return float(input)
			if input is String and input.is_valid_float():
				return input.to_float()
		TYPE_STRING:
			return str(input)
		TYPE_VECTOR2:
			if input is String:
				var parsed = str_to_var("Vector2" + input if not input.begins_with("Vector2") else input)
				if parsed is Vector2: return parsed
		TYPE_NIL:
			pass
		_:
			pass
	return null


func match_array(args: Array, types: Array):
	if args.size() > types.size():
		return null
	var result: Array
	for i in args.size():
		var matched_arg = convert_type(args[i], types[i])
		if matched_arg == null:
			return null
		result.append(matched_arg)
	return result


func convert_type(input, type: int):
	return type_convert(input, type)


"""
func match_type_strict(text:String, type:int):
	var result
	match type:
		TYPE_STRING:
			pass
		TYPE_INT:
			if text.is_valid_int():
				result = text.to_int()
				return result
			else:
				return null
		TYPE_FLOAT:
			if text.is_valid_float():
				result = text.to_float()
				return result
			else:
				return null
		TYPE_BOOL:
			match text:
				"1":
					result = true
					return result
				"true":
					result = true
					return result
				"0":
					result = false
					return result
				"false":
					result = false
					return result
				_:
					return null
		_:
			return null
"""

func _time_dict_to_seconds(a: Dictionary):
	var total_seconds = (a.get("hour, 0") * 3600) + (a.get("minute", 0) * 60) + (a.get("second", 0))
	return total_seconds

func _time_seconds_to_dict(a: int):
	var hours: int = int(a / 3600)
	var minutes: int = int((a % 3600) / 60)
	var seconds: int = a % 60
	var time_dictionary: Dictionary = {"hour": hours, "minute": minutes, "second": seconds}
	return time_dictionary


func time_addition(a: Dictionary, b: Dictionary):
	var total_seconds = _time_dict_to_seconds(a) + _time_dict_to_seconds(b)
	return _time_seconds_to_dict(total_seconds)


func time_subtraction(a: Dictionary, b: Dictionary, allow_negative_result: bool = false) -> Dictionary:
	var total_seconds = _time_dict_to_seconds(a) - _time_dict_to_seconds(b)
	if total_seconds < 0 and allow_negative_result == true:
		var zero_dict: Dictionary = {"hour": 0, "minute": 0, "second": 0}
		return zero_dict
	return _time_seconds_to_dict(total_seconds)



# -1 = Never takes any arguments
# 0 = Optional arguments. NOTE: ASSIGNED FUNCTION MUST ALWAYS STILL TAKE A PACKED STRING ARRAY AS ARGUMENT!
# 1 and up = Minimum arguments
"""
func add_system_commands():
	add_command(self, "root", "echo", "cmd_echo", 1, "Echoes back all arguments given to it.")
	add_command(self, "root", "ls", "cmd_list_commands", 0, "Lists all available commands in a directory.")
	add_command(self, "root", "dir", "command_list_directories", -1, "Lists available directories.")
	add_command(self, "root", "ex", "cmd_run_expression", 1, "Standard Godot expression functionality.")
	add_command(self, "s3t", "help", "cmd_s3t_help", -1, "Provides basic introduction for the s3t signal system.")
	add_command(self, "s3t", "emit", "cmd_s3t_emit", 1, "Emits the s3t-signal with given paramenters packed in a PackedStringArray.")
	add_command(self, "s3t", "log", "command_s3t_history", -1, "Shows previous s3t-signal events.")
	add_command(self, "root", "quit", "quit_game", -1, "Closes the game.")
	add_command(self, "s3t", "save", "command_save_s3t_history", -1, "Saves the signal history into a text file.")
	add_command(self, "root", "help", "command_sestem_help", -1, "Gives the basic instructions to help you get started.")
	add_command(self, "root", "manual", "cmd_sestem_manual", -1, "Provides more detailed instructions for using the developer console.")
	add_command(self, "settings", "ls", "cmd_list_settings", -1, "Lists all available game settings.")
	add_command(self, "settings", "edit", "cmd_edit_setting", 2, "Edits selected setting.")
	add_command(self, "settings", "save", "save_settings", -1, "Saves the current settings to disk.")
	add_command(self, "settings", "load", "load_settings", -1, "Attempts to load settings from disk.")
	add_command(self, "settings", "reset", "reset_settings_to_defaults", -1, "Resets settings to their default values.")

func command_sestem_help():
	console.print_text("Type 'ls' to see available commands in a directory.")
	console.print_text("Type 'dir to see available directories.'")
	console.print_text("Type 'manual' for more information.")
	console.print_text("Type 'help' to see this text again.")
"""

func cmd_sestem_manual():
	console.print_text("[b]SES-library developer console[/b]")
	console.new_line()
	console.print_text("Commands are stored in directories. Directories are specified by using '.' before the command like this:")
	console.print_text("'directory.command'")
	console.new_line()
	console.print_text("Just typing 'command' without specifying directory will search the root directory:")
	console.print_text("'command' is the same as 'root.command'")
	console.new_line()
	console.print_text("Arguments are split by using spaces:")
	console.print_text("'category.command argument1 argument2'")

func save_log_as_text(file_name: String, log_array: Array[LogEntry], path = ses_log_folder):
	var file = create_log_file(log_array)
	save_text_file(file_name, file, path)



func cmd_run_expression(arguments: PackedStringArray):
	var text = " ".join(arguments)
	console.print_text(text)
	var expression = Expression.new()
	var error = expression.parse(text)
	if error != OK:
		console.print_text(expression.get_error_text())
		return
	var result = expression.execute()
	if not expression.has_execute_failed():
		console.print_text(str(result))


func cmd_list_commands(arguments: PackedStringArray):
	var directory_name
	if arguments.size() == 0:
		directory_name = "root"
	else:
		directory_name = arguments[0]
	if command_directories.has(directory_name) == false:
		console.print_text("Could not find directory: '", directory_name, "'")
		return
	var directory: Dictionary = command_directories.get(directory_name)
	if directory == null:
		console.print_text("Could not find directory: '", directory_name, "'")
		return
	console.print_text("Commands in '", directory_name, "':")
	#console.new_line()
	var cmd_array: Array = directory.values()
	sort_resources_by_string_var(cmd_array, "command_name")
	var column1: PackedStringArray
	var column2: PackedStringArray

	for c in cmd_array:
		column1.append(c.command_name)
		column2.append(c.description)
	var table = create_table(column1, column2)
	console.print_text(table)


func create_table(column1: PackedStringArray, column2: PackedStringArray):
	var table: String = "[table=2]"
	for i in column1.size():
		table = table + "[cell]"+ column1[i] +"[/cell]" + "[cell]     - " + column2[i] + "[/cell]"

	table = table + "[/table]"
	return table




func cmd_echo(words: PackedStringArray):
	var text = " ".join(words)
	console.print_text(text)



func print_array_to_console(words: PackedStringArray):
	var text = " ".join(words)
	console_print.emit(text)


func _shit_pants(dev_message: String = "Unavailable"):
	push_error("A SES-Framework component or a related function has malfunctioned unrecoverably.",
	" Additional info: ", dev_message)