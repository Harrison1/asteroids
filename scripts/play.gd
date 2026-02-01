extends Button


@export var animation_player: AnimationPlayer
@export var game_scene: PackedScene


func _on_pressed() -> void:
	if game_scene:
		animation_player.stop()
		modulate.a = 1.0
		# play coin sound
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_packed(game_scene)
