extends Node


@export var asteroid_scene: PackedScene
@export var player_scene: PackedScene

var game_active := true
var spawn_timer := 2.0

@onready var screen_size = get_viewport().size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_died.connect(spawn_children.call_deferred)
	Global.spawn_child_asteroids.connect(life_lost)
	spawn_player()
	spawn_asteroids()


func life_lost() -> void:
	Global.lives -= 1
	if Global.lives == 0:
		game_active = false
	else:
		await get_tree().create_timer(1.0).timeout
		spawn_player()


func spawn_asteroids() -> void:
	while game_active:
		await get_tree().create_timer(spawn_timer).timeout
		var asteroid = asteroid_scene.instantiate()
		add_child(asteroid)


func spawn_children(pos: Vector2, size: Global.Size, vel: Vector2) -> void:
	for i in range(2):
		var asteroid = asteroid_scene.instantiate()
		asteroid.asteroid_size = size
		asteroid.position = pos
		asteroid.random_spawn = false
		var degree = 45.0 if i else -45.0
		asteroid.velocity = vel.rotated(deg_to_rad(degree))
		add_child(asteroid)


func spawn_player() -> void:
	var player = player_scene.instantiate()
	player.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	player.rotation = deg_to_rad(-90)
	add_child(player)
