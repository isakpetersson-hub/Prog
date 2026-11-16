class_name  SoundEffect
extends Resource

@export_range(0, 10) var limit: int = 5 ## Maximum number concurrently playing.
@export var sound_effects: Array[AudioStream] ## array of mp3 files choosen at random, one file means no randomness.
@export_range(-40, 20) var volume: float = 0 
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0 
@export_range(0.0, 1.0,.01) var pitch_randomness: float = 0.0 

var audio_count: int = 0 ## The instances of this [AudioStreamMP3] currently playing.

## Takes [param amount] to change the [member audio_count]. 
func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)


## Checkes whether the audio limit is reached. Returns true if the [member audio_count] is less than the [member limit].
func has_open_limit() -> bool:
	return audio_count < limit


## Connected to the [member sound_effect]'s finished signal to decrement the [member audio_count].
func on_audio_finished() -> void:
	change_audio_count(-1)
