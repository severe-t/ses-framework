extends AudioStreamPlayer
class_name StaticPlayer

enum EndOfTrackSetting{
	STOP,
	LOOP,
	FADE,
}

enum Mode{
	BGM,
	BGS
}

enum StartMode{
	INSTANT,
	FADE,
}

var selected_start_mode: StartMode

var bgm_id: Bgm.ids
var bgs_id: Bgs.ids

var selected_mode: Mode
var end_of_track_setting: EndOfTrackSetting

var original_res_volume: float
var volume_modifier: float
var _track_volume: float


var _active_tween: Tween
var _active_tween_duration: float = 0.0
var _prevent_tween_override: bool = false

signal bgm_finished
signal bgs_finished



#	volume_db ja volume_linear
#	käytä linear



func _ready():
#	_track_volume = original_res_volume * volume_modifier
	finished.connect(_on_end)

func init_track_volume():
	_track_volume = original_res_volume * volume_modifier
	pass

func set_volume(vol: float):#	Hyi vittu mitä paskaa
	volume_modifier = vol
	_track_volume = original_res_volume * volume_modifier
	if _active_tween and _active_tween.is_running():
		if _prevent_tween_override == false:
			var tween_time_lapsed = _active_tween.get_total_elapsed_time()
			_active_tween.kill()
			var takeover_duration = _active_tween_duration - tween_time_lapsed
			if takeover_duration <= 0.0:
				volume_db = linear_to_db(_track_volume)
			else:
				fade_volume_in(takeover_duration)
#	Häpeäisit.


func _kill_tween():
	if _active_tween and _active_tween.is_running() and _prevent_tween_override == false:
		_active_tween.kill()


func mute():
	volume_db = linear_to_db(0.0)

func unmute():
	volume_db = linear_to_db(_track_volume)

func fade_in(duration: float):
	volume_db = linear_to_db(0.001)
	play()
	fade_volume_in(duration)

func fade_volume_in(duration: float):
	_kill_tween()
	_active_tween = create_tween()
	_active_tween_duration = duration
	_active_tween.tween_method(
		func(linear_vol: float): volume_db = linear_to_db(linear_vol),
		volume_linear,
		_track_volume,
		duration
	).set_trans(Tween.TRANS_SINE)

func fade_out(duration):
	_prevent_tween_override = true
	fade_volume_out(duration, true)

func fade_volume_out(duration: float, kill_after: bool = false):
	_kill_tween()
	_active_tween = create_tween()
	_active_tween_duration = duration
	_active_tween.tween_method(
		func(linear_vol: float): volume_db = linear_to_db(linear_vol),
		volume_linear,
		0.0,
		duration
	).set_trans(Tween.TRANS_SINE)
	if kill_after == true:
		_active_tween.finished.connect(kill)


func _on_end():
	if AudioManager.loop_bgm == false:
		kill()	
	var loop_delay: float
	if selected_mode == Mode.BGM:
		loop_delay = AudioManager.bgm_loop_delay
	else:
		loop_delay = AudioManager.bgs_loop_delay

	if loop_delay > 0.0:
		await Ses.wait(loop_delay)
	play()
	

func kill(disable_signal = false):
	if disable_signal == false:
		match selected_mode:
			Mode.BGM:
				bgm_finished.emit()
			Mode.BGS:
				bgs_finished.emit(bgs_id)
			_:
				push_error()
	queue_free()
