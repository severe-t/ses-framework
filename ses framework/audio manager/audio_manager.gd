extends Node2D

#	Original code by Aarimous. Heavily iterated by Severe Entertainment.

"""
TODO:
	Testaa fade in ja fade out
	Tee BGS loppuun
	Testaan BGS:n fade in ja fade out
	Testaa molempien volume change






"""
var sound_effect_string_dict: Dictionary[String, SoundEffect.ids]
var bgm_string_dict: Dictionary[String, Bgm.ids]
var bgs_string_dict: Dictionary[String, Bgs.ids]

var sound_effect_dict: Dictionary = {} ## Loads all registered SoundEffects on ready as a reference.
var background_music_dict: Dictionary = {}
var background_sound_dict: Dictionary = {}

signal kill_audio_player

@export var sound_effects: Array[SoundEffect] ## Stores all possible SoundEffects that can be played.
@export var background_music: Array[Bgm]
@export var background_sounds: Array[Bgs]

@export var loop_bgm: bool = true
@export var bgm_loop_delay: float = 0.0
@export var loop_bgs: bool = true
@export var bgs_loop_delay: float = 0.0

var bgs_history: Array[int]


var rolling_numbers: Array[int]

var current_bgm: StaticPlayer
var current_bgs: Dictionary[Bgs.ids, StaticPlayer]


func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.selected_id] = sound_effect
	for bgm: Bgm in background_music:
		background_music_dict[bgm.selected_id] = bgm
	for bgs: Bgs in background_sounds:
		background_sound_dict[bgs.selected_id] = bgs
	init_rolling_numbers()
	init_string_id_dicts()

	Ses.add_command(self, "se", "play", "command_play_se", 1, "Plays a selected sound effect.")
	Ses.add_command(self, "bgm", "play", "command_play_bgm", 1, "Plays a selected soundtrack.")
	Ses.add_command(self, "bgs", "play", "command_play_bgs", 1, "Plays a selected background audio.")

	Ses.add_command(self, "bgm", "stop", "stop_bgm", -1, "Stops selected soundtrack.")
	Ses.add_command(self, "bgm", "fadein", "command_fade_in_bgm", 2, "Fades in selected soundtrack.")
	Ses.add_command(self, "bgm", "fadeout", "command_fade_out_bgm", 1, "Fades out selected soundtrack.")
	Ses.add_command(self, "bgm", "mute", "mute_bgm", -1, "Mutes selected soundtrack.")
	Ses.add_command(self, "bgm", "unmute", "unmute_bgm", -1, "Unmutes selected soundtrack.")




func init_rolling_numbers() -> void:
	rolling_numbers.resize(sound_effects.size())
	for sound_effect in sound_effects:
		rolling_numbers.set(sound_effect.selected_id, 0)


func roll_number(sound_effect: SoundEffect) -> int:
	var current_number = rolling_numbers[sound_effect.selected_id]
	var new_number = posmod(current_number + 1, sound_effect.limit)
	rolling_numbers[sound_effect.selected_id] = new_number
	return new_number


func spike_prevention(sound_effect: SoundEffect, number: int) -> void:
	kill_audio_player.emit(sound_effect.selected_id, number)

"""
func play_se(se_id: SoundEffect.ids, location = 0) -> void:
	if location is int and location == 0:
		_play_se_1d(se_id)
	elif location is Vector2:
		_play_se_2d(se_id, location)
	else:
		return
"""



func play_se(se_id: SoundEffect.ids) -> void:
	if sound_effect_dict.has(se_id):
		var sound_effect: SoundEffect = sound_effect_dict[se_id]
		var new_audio: CustomAudioStreamPlayer = CustomAudioStreamPlayer.new()
		add_child(new_audio)
		new_audio.stream = sound_effect.sound_file
		new_audio.volume_db = sound_effect.volume
		new_audio.pitch_scale = sound_effect.pitch_scale
		new_audio.pitch_scale += Ses.rng.randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
	#	new_audio.finished.connect(new_audio.queue_free)
		var number = roll_number(sound_effect)
		new_audio.number = number
		spike_prevention(sound_effect, number)
		kill_audio_player.connect(new_audio._on_kill)
		new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for se_id ", se_id)



func play_se_2d(se_id: SoundEffect.ids, location: Vector2) -> void:
	if sound_effect_dict.has(se_id):
		var sound_effect: SoundEffect = sound_effect_dict[se_id]
		var new_audio: AudioStreamPlayer2D = CustomAudioStreamPlayer2D.new()
		add_child(new_audio)
		new_audio.position = location
		new_audio.stream = sound_effect.sound_file
		new_audio.volume_db = sound_effect.volume
		new_audio.pitch_scale = sound_effect.pitch_scale
		new_audio.pitch_scale += Ses.rng.randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
	#	new_audio.finished.connect(new_audio.queue_free)
		var number = roll_number(sound_effect)
		new_audio.number = number
		spike_prevention(sound_effect, number)
		kill_audio_player.connect(new_audio._on_kill)
		new_audio.play()
	else:
		push_error("Audio Manager failed to find setting for id ", se_id)






func play_bgm(bgm_id: Bgm.ids, volume_modifier: float = 1) -> void:
	if background_music_dict.has(bgm_id):
		var selected_track: Bgm = background_music_dict[bgm_id]
		var new_static_player: StaticPlayer = StaticPlayer.new()
		add_child(new_static_player)
		new_static_player.selected_start_mode = StaticPlayer.StartMode.INSTANT
		new_static_player.bgm_id = bgm_id
		new_static_player.selected_mode = StaticPlayer.Mode.BGM
		new_static_player.stream = selected_track.sound_file
		new_static_player.original_res_volume = selected_track.volume
		new_static_player.volume_db = selected_track.volume
		new_static_player.volume_modifier = volume_modifier
		stop_bgm()
		current_bgm = new_static_player
		new_static_player.init_track_volume()
		new_static_player.play()

func fade_in_bgm(bgm_id: Bgm.ids, duration: float, volume_modifier: float = 1) -> void:
	if background_music_dict.has(bgm_id):
		var selected_track: Bgm = background_music_dict[bgm_id]
		var new_static_player: StaticPlayer = StaticPlayer.new()
		add_child(new_static_player)
		new_static_player.selected_start_mode = StaticPlayer.StartMode.FADE
		new_static_player.bgm_id = bgm_id
		new_static_player.selected_mode = StaticPlayer.Mode.BGM
		new_static_player.stream = selected_track.sound_file
		new_static_player.original_res_volume = selected_track.volume
		new_static_player.volume_db = selected_track.volume
		new_static_player.volume_modifier = volume_modifier
		stop_bgm()
		current_bgm = new_static_player
		new_static_player.init_track_volume()
		current_bgm.fade_in(duration)

func stop_bgm():
	if current_bgm:
		current_bgm.kill(true)

func fade_out_bgm(duration: float):
	if current_bgm:
		current_bgm.fade_out(duration)


func mute_bgm():
	if current_bgm:
		current_bgm.mute()

func unmute_bgm():
	if current_bgm:
		current_bgm.unmute()


func command_fade_in_bgm(arguments: PackedStringArray):
	var bgm_id = parse_text_argument(arguments[0], 1)
	print(arguments[0], arguments[1])
	var duration = Ses.match_type_strict(arguments[1], TYPE_FLOAT)
	print(duration)
	if duration == null:
		print("SAAATANA")
		return
	#stop_bgm()
	fade_in_bgm(bgm_id, duration)

func command_fade_out_bgm(arguments: PackedStringArray):
	var duration = Ses.match_type_strict(arguments[0], TYPE_FLOAT)
	if duration == null:
		return null
	if current_bgm:
		current_bgm.fade_out(duration)

func _on_bgm_finished() -> void:
	current_bgm = null


func play_bgs(bgs_id: Bgs.ids, volume_modifier: float = 1) -> void:
	if background_sound_dict.has(bgs_id):
		var selected_track: Bgs = background_sound_dict[bgs_id]
		var new_static_player: StaticPlayer = StaticPlayer.new()
		new_static_player.bgs_id = bgs_id
		new_static_player.selected_mode = StaticPlayer.Mode.BGS
		new_static_player.stream = selected_track.sound_file
		new_static_player.original_res_volume = selected_track.volume
		new_static_player.volume_db = selected_track.volume
		new_static_player.volume_modifier = volume_modifier
		stop_bgs(bgs_id)
		current_bgs[bgs_id] = new_static_player
		bgs_history.append(bgs_id)
		new_static_player.play()


func stop_bgs(bgs_id: int):
	if current_bgs[bgs_id]:
		current_bgs[bgs_id].kill(true)
		_bgs_history_remove(bgs_id)

func stop_previous_bgs():
	var bgs_id = bgs_history.back()
	stop_bgs(bgs_id)

func _bgs_history_append(bgs_id: int):
	bgs_history.erase(bgs_id)
	bgs_history.append(bgs_id)

func _bgs_history_remove(bgs_id):
	bgs_history.erase(bgs_id)

func _bgs_history_clear():
	bgs_history.clear()


func stop_all_bgs():
	for i in current_bgs.size():
		if current_bgs[i]:
			current_bgs[i].kill(true)


func _on_bgs_finished(bgs_id) -> void:
	current_bgs[bgs_id] = null



func init_string_id_dicts() -> void:
	for str_id in SoundEffect.ids:
		var int_id: int = SoundEffect.ids[str_id]
		sound_effect_string_dict[str_id] = int_id as SoundEffect.ids

	for str_id in Bgm.ids:
		var int_id: int = Bgm.ids[str_id]
		bgm_string_dict[str_id] = int_id as Bgm.ids

	for str_id in Bgs.ids:
		var int_id: int = Bgs.ids[str_id]
		bgs_string_dict[str_id] = int_id as Bgs.ids


func parse_text_argument(text_input: String, string_dict_type: int) -> int:	#	0 = se, 1 = bgm, 2 = bgs
	var selected_dict: Dictionary
	var text_all_caps_conversion = text_input.to_upper()
	match string_dict_type:
		0:
			selected_dict = sound_effect_string_dict
		1:
			selected_dict = bgm_string_dict
		2:
			selected_dict = bgs_string_dict
	if selected_dict.has(text_all_caps_conversion):
		return selected_dict[text_all_caps_conversion]
	
	var int_attempt = Ses.match_type_strict(text_input, TYPE_INT)
	if int_attempt is int:
		return int_attempt
	return -1

func command_play_se(arguments: PackedStringArray) -> void:
	var se_id = parse_text_argument(arguments[0], 0)
	if se_id == -1:
		return
	play_se(se_id)

func command_play_bgm(arguments: PackedStringArray) -> void:
	var bgm_id = parse_text_argument(arguments[0], 1)
	if bgm_id == -1:
		return
	play_bgm(bgm_id)

func command_play_bgs(arguments: PackedStringArray) -> void:
	var bgs_id = parse_text_argument(arguments[0], 2)
	if bgs_id == -1:
		return
	play_bgs(bgs_id)
