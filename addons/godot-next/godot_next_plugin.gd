tool
extends EditorPlugin

func _enter_tree():
    add_autoload_singleton("node/singleton.gd")

func _enter_tree():
    remove_autoload_singleton("node/singleton.gd")