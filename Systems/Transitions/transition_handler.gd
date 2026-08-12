class_name TransitionHandlerClass
extends Control

func switch_to_scene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
