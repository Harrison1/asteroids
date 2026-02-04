extends Node2D


@onready var particles: CPUParticles2D = $Particles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles.emitting = true


func _on_particles_finished() -> void:
	queue_free()
