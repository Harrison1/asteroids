class_name Asteroid
extends Area2D


var asteroid_size: Global.Size
var random_spawn := true
var speed: float
var velocity: Vector2
var asteroid_properties = {
	0: {
		"frame": [0, 1, 2].pick_random(),
		"scale": Vector2(0.25, 0.25),
		"speed": randf_range(200, 300)
	},
	1: {
		"frame": [3, 4, 5].pick_random(),
		"scale": Vector2(0.5, 0.5),
		"speed": randf_range(120, 130)
	},
	2: {
		"frame": [6, 7, 8].pick_random(),
		"scale": Vector2(1.0, 1.0),
		"speed": randf_range(100, 110)
	}
}

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var screen_size = get_viewport_rect().size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if random_spawn:
		asteroid_size = Global.Size.values().pick_random()
		spawn_asteroid()

	init_properties(asteroid_size)


func _physics_process(delta: float) -> void:
	position += velocity * speed * delta


func _process(_delta: float) -> void:
	pass


func init_properties(size: Global.Size) -> void:
	animated_sprite_2d.rotation = randf_range(0, TAU)
	animated_sprite_2d.frame = asteroid_properties[size].frame
	scale = asteroid_properties[size].scale
	speed = asteroid_properties[size].speed


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func spawn_asteroid() -> void:
	var loc: String = ["bottom", "left", "right", "top"].pick_random()
	spawn(loc)


func set_x(loc: String) -> float:
	match loc:
		"top": return randf_range(200.0, screen_size.x - 200.0)
		"right": return screen_size.x + 100.0
		"bottom": return randf_range(200.0, screen_size.y - 200.0)
		"left": return -100.00
		_: return 0.0


func set_y(loc: String) -> float:
	match loc:
		"top": return -100.0
		"right": return randf_range(200.0, screen_size.y - 200.0)
		"bottom": return screen_size.y + 100.0
		"left": return randf_range(200.0, screen_size.y - 200.0)
		_: return 0.0


func set_degree(loc: String) -> float:
	match loc:
		"top": return randf_range(45.0, 135.0)
		"right": return randf_range(135.0, 225.0)
		"bottom": return randf_range(225.0, 315.0)
		"left": return randf_range(-45.0, 45.0)
		_: return 0.0


func spawn(loc: String) -> void:
	position = Vector2(set_x(loc), set_y(loc))
	var random_degree = set_degree(loc)
	var vel_angle = deg_to_rad(random_degree)
	velocity = Vector2.from_angle(vel_angle)


func _on_area_entered(area: Area2D) -> void:
	if area is Missile:
		match asteroid_size:
			Global.Size.SIZE_1:
				Global.update_score.emit(100)
				queue_free()
			Global.Size.SIZE_2:
				Global.update_score.emit(50)
				Global.spawn_child_asteroids.emit(position, Global.Size.SIZE_1, velocity)
				queue_free()
			Global.Size.SIZE_3:
				Global.update_score.emit(20)
				Global.spawn_child_asteroids.emit(position, Global.Size.SIZE_2, velocity)
				queue_free()


# large saucer: 200pts
# small saucer: 1000pts
