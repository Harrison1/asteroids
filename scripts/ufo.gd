class_name UFO
extends Area2D


@export var explosion_scene: PackedScene
@export var missile_scene: PackedScene

var size := Global.Size.SIZE_1
var speed := 100.0
var velocity = Vector2(-1.0, 0.0)

@onready var screen_size = get_viewport_rect().size
@onready var shoot_sfx: AudioStreamPlayer = $ShootSFX
@onready var shoot_timer: Timer = $ShootTimer
@onready var ufo_abduction_sfx: AudioStreamPlayer = $UFOAbductionSFX


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ufo()
	await get_tree().create_timer(0.5, false).timeout
	ufo_abduction_sfx.play()


func _physics_process(delta: float) -> void:
	position += velocity * speed * Global.difficulty_multiplier * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func spawn_ufo() -> void:
	size = [Global.Size.SIZE_1, Global.Size.SIZE_2].pick_random()
	var loc: String = ["left", "right"].pick_random()
	spawn(loc)


func set_x(loc: String) -> float:
	match loc:
		"right": return screen_size.x + 100.0
		"left": return -100.00
		_: return -100.0


func set_y() -> float:
	return randf_range(200.0, screen_size.y - 200.0)


func spawn(loc: String) -> void:
	var vel_x = 1.0 if loc == "left" else -1.0
	position = Vector2(set_x(loc), set_y())
	velocity = Vector2(vel_x, 0.0)
	if size == Global.Size.SIZE_2:
		scale = Vector2(0.65, 0.65)
		speed = 150.0


func shoot() -> void:
	if Global.is_game_active:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			spawn_missile(player.position)
			shoot_timer.wait_time = randf_range(2.0, 4.0)
			


func spawn_missile(pos: Vector2) -> void:
	var missile = missile_scene.instantiate()
	var rotate_towards_player = (pos - position).angle()
	missile.position = position + Vector2.from_angle(rotate_towards_player) * 100.0
	missile.rotation = (pos - missile.position).angle()
	missile.add_to_group("Enemy")
	shoot_sfx.play()
	get_parent().add_child(missile)


func spawn_explosion() -> void:
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		get_parent().add_child.call_deferred(explosion)


func _on_area_entered(area: Area2D) -> void:
	if area is Missile:
		spawn_explosion()
		match size:
			Global.Size.SIZE_1:
				if not area.is_in_group("Enemy"):
					Global.update_score.emit(200)
			Global.Size.SIZE_2:
				if not area.is_in_group("Enemy"):
					Global.update_score.emit(1000)
		queue_free()


func _on_shoot_timer_timeout() -> void:
	shoot()
