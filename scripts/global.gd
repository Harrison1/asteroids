extends Node


@warning_ignore("unused_signal")
signal game_over()

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

var hiscore := 0
var is_game_active := true
var player_lives := 4
var score := 0


func reset_stats() -> void:
	is_game_active = true
	player_lives = 4
	score = 0
	Player.is_respawn = false
