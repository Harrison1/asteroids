extends Node

@warning_ignore("unused_signal")
signal player_died()

@warning_ignore("unused_signal")
signal spawn_child_asteroids(pos: Vector2, size: Size, vel: Vector2)

@warning_ignore("unused_signal")
signal update_score(points: int)

enum Size {SIZE_1, SIZE_2, SIZE_3}

var is_game_active := true
var player_lives := 4
