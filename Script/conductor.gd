extends AudioStreamPlayer

@export var bpm = 126
@export var measures = 4

# Tracking beat and song position
var song_position = 0.0
var song_position_in_beats = 1
var sec_per_beat = 60.0 / bpm
var last_reported_beat = 0
var beats_before_start = 0
var measure_position = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0

signal beat(position)
signal measure(position)

func _ready():
	sec_per_beat = 60.0 / bpm
	
func _physics_process(_delta):
	if playing:
		var time = get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
		if time > song_position:
			song_position = time
			song_position_in_beats = int(floor(song_position / sec_per_beat)) + beats_before_start
			_report_beat()

func _report_beat():
	# bc we call report beat every frame so we might be on the same beat
	if last_reported_beat < song_position_in_beats:
		# reset measure
		if measure_position > measures:
			measure_position = 1
		beat.emit(song_position_in_beats)
		measure.emit(measure_position)
	
		last_reported_beat = song_position_in_beats
		measure_position += 1
		
func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = sec_per_beat
	$StartTimer.start()

func closest_beat(nth):
	closest = int(round((song_position / sec_per_beat) / nth) * nth)
	time_off_beat = abs(closest * sec_per_beat - song_position)
	return Vector2(closest, time_off_beat)

func play_from_beat(beat, offset):
	play()
	seek(beat * sec_per_beat)
	beats_before_start = offset

	measure_position = beat % measures

func _on_start_timer_timeout():
	#print("counting into song")
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play(0)
		$StartTimer.stop()
	_report_beat()
