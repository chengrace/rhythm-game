#levels_menu.gd

extends Node2D

func _ready():
	$AnimatedSprite2D.play("snap")

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


func _on_lvl_1_pressed():
	get_tree().change_scene_to_file("res://Scene/level_one.tscn")
