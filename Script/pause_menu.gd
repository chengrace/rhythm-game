## pause_menu.gd
extends CanvasLayer

@export var countdown_time = 3

var countdown
	
func show_pause_menu():
	visible = true
	$ColorRect.visible = true
	$Countdown.text = ""
	get_tree().paused = true

func hide_pause_menu():
	visible = false
	get_tree().paused = false

func _on_resume_pressed():
	$ColorRect.visible = false
	$Timer.start()
	countdown = countdown_time
	$Countdown.text = str(countdown)
	
func _on_main_menu_pressed():
	get_tree().paused = false
	self.visible = false
	get_tree().change_scene_to_file("res://Scene/levels_menu.tscn")

func _on_timer_timeout():
	if countdown == 0:
		hide_pause_menu()
	else:
		countdown -= 1
		$Countdown.text = str(countdown)
		$Timer.start()
