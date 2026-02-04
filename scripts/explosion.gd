extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var particles: CPUParticles2D = $Particles


func _ready() -> void:
	audio_stream_player_2d.pitch_scale = randf_range(0.5, 1.5)
	particles.emitting = true

func _on_particles_finished() -> void:
	queue_free()
