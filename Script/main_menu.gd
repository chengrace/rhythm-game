## main_menu.gd

extends Node2D

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scene/levels_menu.tscn")
