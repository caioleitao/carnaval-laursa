extends AudioStreamPlayer

signal beat_emitted(beat_number: int)
signal measure_emitted(measure_number: int)
signal song_finished

@export var bpm: int = 120
@export var measures: int = 4

var sec_per_beat: float = 0.0
var song_position: float = 0.0
var song_position_in_beats: float = 0.0
var last_reported_beat: int = 0
var audio_offset: float = 0.0
var current_scene_path: String = ""

func _ready() -> void:
	audio_offset = AudioServer.get_output_latency()
	# Connect to the built-in finished signal
	finished.connect(_on_audio_finished)

func _on_audio_finished():
	song_finished.emit()

func load_song(music_stream: AudioStream, new_bpm: int, new_measures: int = 4):
	stream = music_stream
	
	bpm = new_bpm
	measures = new_measures
	
	sec_per_beat = 60.0 / bpm
	song_position = 0.0
	last_reported_beat = 0

func _process(delta: float) -> void:
	if not playing:
		return
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix() - audio_offset
	song_position_in_beats = song_position / sec_per_beat
	_report_change()
	
func _report_change():
	var curr_beat_int = int(song_position_in_beats)
	
	if curr_beat_int > last_reported_beat:
		last_reported_beat = curr_beat_int
		beat_emitted.emit(last_reported_beat)
		if last_reported_beat % measures == 0:
			measure_emitted.emit(last_reported_beat/measures)

func play_from_start():
	song_position = 0.0
	last_reported_beat = 0
	play()
	
func get_total_measures_in_song() -> int:
	if not stream:
		return 0
		
	var song_length_sec = stream.get_length()
	var measure_duration_sec = sec_per_beat * measures
	var total = floor(song_length_sec / measure_duration_sec)
	
	return int(total)

