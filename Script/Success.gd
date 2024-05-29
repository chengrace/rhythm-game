## rhythm/success.gd

extends CanvasLayer

func _on_button_pressed():
	get_tree().paused = false
	SceneManager.change_scene_with_transition("res://Scenes/forest_area.tscn")

func _on_visibility_changed():
	$Button.grab_focus()
