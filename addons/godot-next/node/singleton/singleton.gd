# author: willnationsdev
# license: MIT
# description: A Singleton Node. It is only possible to have one instance of each type.
#              Relies on an autoload, so it cannot be a tool script.
#              Can access two ways:
#              - Singletons.<ScriptOrSceneName>
#              - <Script>.get_singleton()
extends Node
class_name Singleton

##### CLASSES #####

##### SIGNALS #####

##### CONSTANTS #####

##### PROPERTIES #####

##### NOTIFICATIONS #####

func _init() -> void:
    if Singletons.has(get_script()):
        push_error("Cannot create multiple instances of singletons! Use the 'Singletons' global to fetch the singleton instance.")
        assert false

func _notification(p_what: int) -> void:
    match p_what:
        NOTIFICATION_PARENTED:
            assert get_parent() == get_tree().get_root()
        NOTIFICATION_UNPARENTED:
            assert false

##### OVERRIDES #####

##### VIRTUALS #####

##### PUBLIC METHODS #####

static func get_singleton() -> Node:
    return Singletons.get(ClassType.namify_path(get_script().resource_path)) as Node

##### CONNECTIONS #####

##### PRIVATE METHODS #####

##### SETTERS AND GETTERS #####
