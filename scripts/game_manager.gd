extends Node


@export var asteroid_scene: PackedScene
@export var player_scene: PackedScene
@export var ufo_scene: PackedScene

var asteroid_spawn_wait_timer := 2.0: set = _clamp_asteroid_wait_time
var difficulty_spike_increase := 2000
var next_difficulty_spike := 2000
var ufo_spawn_wait_time := 10.0: set = _clamp_ufo_wait_time

@onready var asteroid_timer: Timer = $AsteroidTimer
@onready var player_spawn_point: Control = %PlayerSpawnPoint
@onready var screen_size = get_viewport().size
@onready var ufo_timer: Timer = $UFOTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_died.connect(life_lost.call_deferred)
	Global.spawn_child_asteroids.connect(spawn_children.call_deferred)
	Global.update_score.connect(increase_difficulty)
	spawn_player()


func life_lost() -> void:
	Global.player_lives -= 1
	if Global.player_lives == 0:
		Global.is_game_active = false
		Global.game_over.emit()
	else:
		Engine.time_scale = 0.5
		await get_tree().create_timer(1.0, false).timeout
		Engine.time_scale = 1.0
		spawn_player()


func spawn_asteroid() -> void:
	if Global.is_game_active:
		var asteroid = asteroid_scene.instantiate()
		get_parent().add_child.call_deferred(asteroid)


func spawn_ufo() -> void:
	if Global.is_game_active:
		var ufo = ufo_scene.instantiate()
		get_parent().add_child.call_deferred(ufo)


func spawn_children(pos: Vector2, size: Global.Size, vel: Vector2) -> void:
	for i in range(2):
		var asteroid = asteroid_scene.instantiate()
		asteroid.asteroid_size = size
		asteroid.position = pos
		asteroid.random_spawn = false
		var degree = 45.0 if i else -45.0
		asteroid.velocity = vel.rotated(deg_to_rad(degree))
		get_parent().add_child.call_deferred(asteroid)


func spawn_player() -> void:
	var player = player_scene.instantiate()
	player.position = player_spawn_point.position
	player.rotation = deg_to_rad(-90)
	get_parent().add_child.call_deferred(player)


func increase_difficulty(_score: int) -> void:
	if Global.score > next_difficulty_spike:
		Global.difficulty_multiplier += 0.2
		asteroid_spawn_wait_timer -= 0.2
		ufo_spawn_wait_time -= 1.0
		asteroid_timer.wait_time = asteroid_spawn_wait_timer
		ufo_timer.wait_time = ufo_spawn_wait_time
		next_difficulty_spike += difficulty_spike_increase
		

func _on_asteroid_timer_timeout() -> void:
	spawn_asteroid()


func _on_ufo_timer_timeout() -> void:
	spawn_ufo()


func _clamp_asteroid_wait_time(value: float) -> void:
	asteroid_spawn_wait_timer = clamp(value, 0.4, 2.0)


func _clamp_ufo_wait_time(value: float) -> void:
	ufo_spawn_wait_time = clamp(value, 4.0, 10.0)
