extends Control


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _on_quit_mouse_entered() -> void:
	audio_stream_player.play()


func _on_retry_mouse_entered() -> void:
	audio_stream_player.play()
