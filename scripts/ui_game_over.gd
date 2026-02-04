extends Control


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_quit_mouse_entered() -> void:
	audio_stream_player_2d.play()


func _on_retry_mouse_entered() -> void:
	audio_stream_player_2d.play()
