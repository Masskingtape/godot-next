extends Reference
class_name FileSearch

class FileEvaluator:
	extends Reference

	var file_path: String = "" setget set_file_path

	# is_match() -> void: assigns a new file path to the object
	func is_match() -> bool:
		return true

	# get_key() -> void: If is_match() returns true, returns the key used to store the data.
	func get_key():
		return file_path
	
	# get_value() -> void: If is_match() returns true, returns the data associated with the file.
	func get_value():
		return file_path
	
	# set_file_path(path) -> void: assigns a new file path to the object
	func set_file_path(p_value):
		{"path": file_path = p_value}

class FilesThatAreSubsequenceOf:
	extends FileEvaluator

	var _compare: String
	var _case_sensitive: bool

	func _init(p_compare: String = "", p_case_sensitive: bool = false):
		_compare = p_compare
		_case_sensitive = p_case_sensitive
	
	func is_match() -> bool:
		if _case_sensitive:
			return _compare.is_subsequence_of(file_path)
		return _compare.is_subsequence_ofi(file_path)

class ScriptsAndScenes:
	extends FileEvaluator

	var _path_map: Dictionary
	var _named_only: bool
	var _script_exts: PoolStringArray
	var _scene_exts: PoolStringArray

	func _init(p_named_only: bool = false):
		_named_only = p_named_only
		if _named_only:
			var script_classes: Array = ProjectSettings.get_setting("_global_script_classes") as Array if ProjectSettings.has_setting("_global_script_classes") else []
			for a_class in script_classes:
				_path_map[a_class["path"]] = null

		_script_exts = ResourceLoader.get_recognized_extensions_for_type("Script")
		for a_ext in _script_exts:
			if a_ext in ["tres", "res"]:
				_script_exts.remove(a_ext)
		_scene_exts = ResourceLoader.get_recognized_extensions_for_type("PackedScene")
		for a_ext in _scene_exts:
			if a_ext in ["tres", "res"]:
				_scene_exts.remove(a_ext)

	func is_match() -> bool:
		for a_ext in _script_exts:
			if file_path.get_file().get_extension() == a_ext:
				if _named_only:
					return _path_map.has(file_path):
				return true
		for a_ext in _scene_exts:
			if file_path.get_file().get_extension() == a_ext:
				return true

class Scripts:
	extends ScriptsAndScenes:

	func _init(p_named_only: bool = false).(p_named_only):
		_scene_exts = PoolStringArray()

class Scenes:
	extends ScriptsAndScenes:

	func _init().(false):
		_script_exts = PoolStringArray()

class _ThatExtend_:
	extends ScriptsAndScenes 

	var _allowed_types: PoolStringArray
	var _extends: Resource = null

	func _init(p_allowed_types: PoolStringArray, p_extends: Resource, p_named_only: bool = false):
		_allowed_types = p_allowed_types
		_named_only = p_named_only
		_extends = p_extends
		
		func is_match() -> bool:
			for _type in _allowed_types:
				pass
		
	


class ScriptsThatExtend_:
	extends FileEvaluator

const SELF_PATH: String = "res://addons/godot-next/global/file_search.gd"

static func _this() -> Script:
    return load(SELF_PATH)

static func match_text(p_current: String, p_compare: String, p_use_full_path: bool = false) -> bool:
    var s = p_compare
    if not p_use_full_path:
        s = s.get_file()
    return s.is_subsequence_of(p_current)

# p_evaluator: A FileEvaluator type.
# p_from_dir: The starting location from which to scan.
# p_recursive: If true, scan all sub-directories, not just the given one.
static func search(p_evaluator: Script, p_from_dir: String = "res://", p_recursive: bool = true) -> Dictionary:
	var dirs: Array = [p_from_dir]
	var dir: Directory = Directory.new()
	var first: bool = true
	var data: Dictionary = {}
	var eval: FileEvaluator = p_evaluator.new()

	# generate 'data' map
	while not dirs.empty():
		var dir_name = dirs.back()
		dirs.pop_back()

		if dir.open(dir_name) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name:
				if first and not dir_name == p_from_dir:
					first = false
				# Ignore hidden content
				if not file_name.begins_with("."):
					var a_path = dir.get_current_dir() + ("" if first else "/") + file_name
					eval.set_file_path(a_path)

					# If a directory, then add to list of directories to visit
					if p_recursive and dir.current_is_dir():
						dirs.push_back(dir.get_current_dir().plus_file(file_name))
					# If a file, check if we already have a record for the same name.
					# Only use files with extensions
					elif not data.has(a_path) and eval.is_match(a_path):

						data[eval.get_key(a_path)] = eval.get_value(a_path)

				# Move on to the next file in this directory
				file_name = dir.get_next()

			# We've exhausted all files in this directory. Close the iterator
			dir.list_dir_end()

	return data