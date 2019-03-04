# author: willnationsdev
# license: MIT
# description: A Node which manages a set of Node types as children. Will only allow one child of each type.
#              Can create new singletons simply doing Singletons.<ScriptOrSceneName> to 'get' the type.
tool
extends Node

##### CLASSES #####

##### SIGNALS #####

##### CONSTANTS #####

##### PROPERTIES #####

var _ct: ClassType = ClassType.new(null, true)
var _set: Dictionary = {}
var root: Node

##### NOTIFICATIONS #####

func _enter_tree() -> void:
    root = get_tree().get_root()

func _get(p_property: String):
    if root.has_node(p_property):
        return root.get_node(p_property)
    else:
        if has_name(p_property):
            root.add_child(_ct.instance(), true)
            _set[_ct.get_res()] = null
        else:
            return null

##### OVERRIDES #####

##### VIRTUALS #####

##### PUBLIC METHODS #####

func has(p_type: Resource) -> bool:
    _ct.res = p_type
    return _ct_conflicts()

func has_name(p_name: String) -> bool:
    _ct.name = p_name
    return _ct_conflicts()

##### CONNECTIONS #####

##### PRIVATE METHODS #####

func _ct_conflicts() -> bool:
    for a_type in _set:
        if _ct.is_type(a_type):
            return true
    return false

##### SETTERS AND GETTERS #####
