## rhythm/arrow_button.gd

extends AnimatedSprite2D

@export var input = ""

var perfect = false
var good = false
var okay = false
var current_note = null
var original_color = "625292"
var pressed_color = "897CAF"

func _ready():
	modulate = original_color

func _unhandled_input(event):
	if event.is_action(input):
		# player presses an input
		if event.is_action_pressed(input, false):
			if current_note != null:
				if perfect:
					get_parent().increment_score(3)
					current_note.destroy(3)
				elif good:
					get_parent().increment_score(2)
					current_note.destroy(2)
				elif okay:
					get_parent().increment_score(1)
					current_note.destroy(1)
				_reset()
			else:
				get_parent().increment_score(0)
		# no matter if the note is over matches, the arrow is shown to be clicked
		if event.is_action_pressed(input):
			modulate = pressed_color
		# give a second for the arrow to look pressed
		elif event.is_action_released(input):
			$PushTimer.start()

func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false

func _on_perfect_area_area_entered(area):
	if area.is_in_group("note"):
		perfect = true

func _on_perfect_area_area_exited(area):
	if area.is_in_group("note"):
		perfect = false

func _on_good_area_area_entered(area):
	if area.is_in_group("note"):
		good = true

func _on_good_area_area_exited(area):
	if area.is_in_group("note"):
		good = false

func _on_okay_area_area_entered(area):
	if area.is_in_group("note"):
		okay = true
		current_note = area

func _on_okay_area_area_exited(area):
	if area.is_in_group("note"):
		okay = false
		current_note = null

func _on_push_timer_timeout():
	modulate = original_color
