extends Node


@export var asteroid_scene: PackedScene
@export var player_scene: PackedScene
@export var ufo_scene: PackedScene

var asteroid_spawn_timer := 2.0
var ufo_spawn_timer := 10.0

@onready var screen_size = get_viewport().size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_died.connect(life_lost.call_deferred)
	Global.spawn_child_asteroids.connect(spawn_children.call_deferred)
	spawn_player()
	spawn_asteroids()
	spawn_ufos()


func life_lost() -> void:
	Global.player_lives -= 1
	if Global.player_lives == 0:
		Global.is_game_active = false
		Global.game_over.emit()
	else:
		await get_tree().create_timer(1.0).timeout
		spawn_player()


func spawn_asteroids() -> void:
	while Global.is_game_active:
		await get_tree().create_timer(asteroid_spawn_timer).timeout
		var asteroid = asteroid_scene.instantiate()
		get_parent().add_child.call_deferred(asteroid)


func spawn_ufos() -> void:
	while Global.is_game_active:
		await get_tree().create_timer(ufo_spawn_timer).timeout
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
	player.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	player.rotation = deg_to_rad(-90)
	get_parent().add_child.call_deferred(player)
