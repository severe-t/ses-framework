extends Node2D

#	Original code by Aarimous. Heavily iterated by Severe Entertainment.

"""
TODO:
	Testaa fade in ja fade out
	Tee BGS loppuun
	Testaan BGS:n fade in ja fade out
	Testaa molempien volume change






"""


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

var rolling_numbers: Array[int]

var current_bgm: StaticPlayer
var current_bgs: Dictionary[Bgs.id, StaticPlayer]


func _ready() -> void:
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.selected_id] = sound_effect
	for bgm: Bgm in background_music:
		background_music_dict[bgm.selected_id] = bgm
	for bgs: Bgs in background_sounds:
		background_sound_dict[bgs.selected_id] = bgs


	init_rolling_numbers()

func init_rolling_numbers():
	rolling_numbers.resize(sound_effects.size())
	for sound_effect in sound_effects:
		rolling_numbers.set(sound_effect.selected_id, 0)


func roll_number(sound_effect: SoundEffect):
	var current_number = rolling_numbers[sound_effect.selected_id]
	var new_number = posmod(current_number + 1, sound_effect.limit)
	rolling_numbers[sound_effect.selected_id] = new_number
	return new_number


func spike_prevention(sound_effect: SoundEffect, number: int):
	kill_audio_player.emit(sound_effect.selected_id, number)


func play_se(se_id: SoundEffect.id, location = 0) -> void:
	if location is int and location == 0:
		_play_se_1d(se_id)
	elif location is Vector2:
		_play_se_2d(se_id, location)
	else:
		return




func _play_se_1d(se_id: SoundEffect.id) -> void:
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



func _play_se_2d(se_id: SoundEffect.id, location: Vector2) -> void:
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






func play_bgm(bgm_id: Bgm.id, volume_modifier: float = 1):
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
		if current_bgm:
			current_bgm.kill(true)
		current_bgm = new_static_player
		new_static_player.play()

func _on_bgm_finished():
	current_bgm = null


func play_bgs(bgs_id: Bgs.id, volume_modifier: float = 1):
	if background_sound_dict.has(bgs_id):
		var selected_track: Bgs = background_sound_dict[bgs_id]
		var new_static_player: StaticPlayer = StaticPlayer.new()
		new_static_player.bgs_id = bgs_id
		new_static_player.selected_mode = StaticPlayer.Mode.BGS
		new_static_player.stream = selected_track.sound_file
		new_static_player.original_res_volume = selected_track.volume
		new_static_player.volume_db = selected_track.volume
		new_static_player.volume_modifier = volume_modifier

func _on_bgs_finished(bgs_id):
	current_bgs[bgs_id] = null
