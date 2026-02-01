class_name UFO
extends Area2D


@export var missile_scene: PackedScene

var speed := 100.0
var velocity = Vector2(-1.0, 0.0)

@onready var screen_size = get_viewport_rect().size


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ufo()
	shoot()


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func spawn_ufo() -> void:
	var loc: String = ["left", "right"].pick_random()
	spawn(loc)


func set_x(loc: String) -> float:
	match loc:
		"right": return screen_size.x + 100.0
		"left": return -100.00
		_: return 0.0


func set_y(loc: String) -> float:
	match loc:
		"right": return randf_range(200.0, screen_size.y - 200.0)
		"left": return randf_range(200.0, screen_size.y - 200.0)
		_: return 0.0


func spawn(loc: String) -> void:
	var vel_x = 1.0 if loc == "left" else -1.0
	position = Vector2(set_x(loc), set_y(loc))
	velocity = Vector2(vel_x, 0.0) if loc == "left" else Vector2(vel_x, 0.0)


func shoot() -> void:
	while Global.is_game_active:
		await get_tree().create_timer(5.0).timeout
		var player = get_tree().get_first_node_in_group("player")
		if player:
			spawn_missile(player.position)

func spawn_missile(pos: Vector2) -> void:
		var missile = missile_scene.instantiate()
		var rotate_towards_player = (pos - position).angle()
		missile.position = position + Vector2.from_angle(rotate_towards_player) * 100.0
		missile.rotation = (pos - missile.position).angle()
		missile.add_to_group("Enemy")
		get_parent().add_child(missile)
		#shoot.play()


func _on_area_entered(area: Area2D) -> void:
	if area is Missile:
		Global.update_score.emit(200)
		queue_free()


# small saucer: 1000pts
