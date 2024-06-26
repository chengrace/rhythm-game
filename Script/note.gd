## rhythm/note.gd
extends Area2D

const TARGET_Y = 370
const SPAWN_Y = -16
const MAX_Y = 400
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN = Vector2(324, SPAWN_Y)
const CENTRE_LANE_SPAWN = Vector2(394, SPAWN_Y)
const RIGHT_LANE_SPAWN = Vector2(468, SPAWN_Y)

var speed = 0
var hit = false

var perfect_color = Color("f6d6bd")
var good_color = Color("c3a38a")
var ok_color = Color("997577")
var miss_color = Color.BLACK

func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > MAX_Y: #note reaches bottom of screen
			destroy(-1)
			#queue_free()
			get_parent().reset_combo() #means player missed
	else:
		$Node2D.position.y -= speed * delta

func initialize(lane):
	if lane == 0:
		$AnimatedSprite2D.frame = 0
		position = LEFT_LANE_SPAWN
	elif lane == 1:
		$AnimatedSprite2D.frame = 1
		position = CENTRE_LANE_SPAWN
	elif lane == 2:
		$AnimatedSprite2D.frame = 2
		position = RIGHT_LANE_SPAWN
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	speed = DIST_TO_TARGET / 2.0 #takes 2 seconds for our node to reach the arrow


func destroy(score):
	$CPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$DeathTimer.start()
	hit = true
	if score == 3:
		$Node2D/Label.text = "PERFECT"
		$Node2D/Label.modulate = perfect_color
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = good_color
	elif score == 1:
		$Node2D/Label.text = "OK"
		$Node2D/Label.modulate = ok_color
	elif score < 0:
		#$Node2D.position += Vector2(0, -5)
		$Node2D/Label.text = "MISS"
		$Node2D/Label.modulate = miss_color

func _on_death_timer_timeout():
	queue_free()
	
func change_color(arrow_color=Color.WHITE, perfect=perfect_color, good=good_color, ok=ok_color, miss=miss_color):
	perfect_color = perfect
	good_color = good
	ok_color = ok
	miss_color = miss
	$AnimatedSprite2D.modulate = arrow_color
