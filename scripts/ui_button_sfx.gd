extends Node


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func on_click() -> void:
	audio_stream_player.play()
