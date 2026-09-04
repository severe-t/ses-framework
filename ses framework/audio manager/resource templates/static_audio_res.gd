extends Resource
class_name StaticAudio

@export var sound_file: AudioStreamMP3
@export_range(-40, 20) var volume: float = 1
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0