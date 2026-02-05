extends Node


@warning_ignore("unused_signal")
signal game_over()

@warning_ignore("unused_signal")
signal increase_difficulty()

# notifications on the pause menu were not working as expected
@warning_ignore("unused_signal")
signal pause_game()

@warning_ignore("unused_signal")
signal player_died()

@warning_ignore("unused_signal")
signal spawn_child_asteroids(pos: Vector2, size: Size, vel: Vector2)

@warning_ignore("unused_signal")
signal update_score(points: int)

enum Size {SIZE_1, SIZE_2, SIZE_3}

var difficulty_multiplier := 1.0: set = _clamp_multiplier
var hiscore := 0
var is_game_active := true
var player_lives := 4
var screen_center := Vector2(0.0, 0.0)
var score := 0


func reset_stats() -> void:
	difficulty_multiplier = 1.0
	is_game_active = true
	player_lives = 4
	score = 0
	Player.is_respawn = false


func _clamp_multiplier(value: float) -> void:
	difficulty_multiplier = clamp(value, 1.0, 3.0)
