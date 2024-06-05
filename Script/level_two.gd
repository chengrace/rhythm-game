## level_two.gd

extends Node2D

var note = load("res://Scene/note.tscn")

@export var bpm = 125
@export var arrow_color: Color = "882e61"
@export var arrow_color_pressed: Color = "e5f5c4"
@export var note_color: Color = "c985ab"
@export var perfect_color: Color = "13073b"
@export var good_color: Color = "13073b"
@export var ok_color: Color = "13073b"
@export var miss_color: Color = "13073b"

var score = 0
var combo = 0

var max_combo = 0
var great = 0
var good = 0
var okay = 0
var missed = 0

var song_position = 0.0
var song_position_in_beats = 0
var last_spawned_beat = 0
var sec_per_beat = 60.0 / bpm

var spawn_1_beat = 1
var spawn_2_beat = 0
var spawn_3_beat = 0
var spawn_4_beat = 0

var lane = 0
var rand = 0

var instance


func _ready():
	randomize()
	$Success.visible = false
	$Conductor.play_with_beat_offset(7)
	#$Conductor.play_from_beat(96,5)
	$Conductor.measure.connect(_on_Conductor_measure)
	$Conductor.beat.connect(_on_Conductor_beat)
	set_colors()
	$AnimationPlayer.play("reset")
	#print("starting")
	
func set_colors():
	$ArrowLeft.original_color = arrow_color
	$ArrowUp.original_color = arrow_color
	$ArrowRight.original_color = arrow_color
	$ArrowLeft.pressed_color = arrow_color_pressed
	$ArrowUp.pressed_color = arrow_color_pressed
	$ArrowRight.pressed_color = arrow_color_pressed

func _input(event):
	if event.is_action("escape"):
		PauseMenu.show_pause_menu()

func _on_Conductor_measure(position):
	if position == 1:
		_spawn_notes(spawn_1_beat)
	elif position == 2:
		_spawn_notes(spawn_2_beat)
	elif position == 3:
		_spawn_notes(spawn_3_beat)
	elif position == 4:
		_spawn_notes(spawn_4_beat)

func _on_Conductor_beat(position):
	$Beat.text = str(position/2)
	song_position_in_beats = position
	if song_position_in_beats < 22*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	elif song_position_in_beats < 50*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 1
	elif song_position_in_beats < 80*2:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 0
	elif song_position_in_beats < 96*2:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 1
	elif song_position_in_beats < 112*2:
		$AnimationPlayer.play("fly")
		spawn_1_beat = 2
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 2
	elif song_position_in_beats < 120*2:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	elif song_position_in_beats < 130*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	elif song_position_in_beats < 170*2:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 0
	elif song_position_in_beats < 180*2:
		$AnimationPlayer.play("reset")
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	elif song_position_in_beats < 195*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 2
		spawn_4_beat = 0
	elif song_position_in_beats < 228*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 2
		spawn_4_beat = 0	
	elif song_position_in_beats < 252*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	elif song_position_in_beats < 270*2:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	elif song_position_in_beats < 300*2:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 2
	elif song_position_in_beats < 336*2:
		spawn_1_beat = 1
		spawn_2_beat = 3
		spawn_3_beat = 2
		spawn_4_beat = 3
	elif song_position_in_beats < 396*2:
		$AnimationPlayer.play("group_circle")
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	elif song_position_in_beats > 420*2:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	elif song_position_in_beats < 483*2:
		$animationPlayer.play("fly")
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 3
	elif song_position_in_beats < 527*2:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 3
		spawn_4_beat = 2
	elif song_position_in_beats < 530*2:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 1
	elif song_position_in_beats < 538*2:
		#Global.set_score(score)
		#Global.combo = max_combo
		#Global.great = great
		#Global.good = good
		#Global.okay = okay
		#Global.missed = missed
		$Success.visible = true
		$Success/Label.text = "Congratulations. You scored: " + str(score)
		get_tree().paused = true

func _spawn_notes(to_spawn):
	# if spawning 1 note 
	if to_spawn > 0:
		lane = randi() % 3
		instance = note.instantiate()
		instance.change_color(note_color, perfect_color, good_color, ok_color, miss_color)
		instance.initialize(lane)
		add_child(instance)
	#if spawning 2 notes
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		instance = note.instantiate()
		instance.change_color(note_color, perfect_color, good_color, ok_color, miss_color)
		instance.initialize(lane)
		add_child(instance)

func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
	$Score.text = str(score)
	if combo > 0:
		$Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$Combo.text = ""


func reset_combo():
	combo = 0
	$Combo.text = ""
