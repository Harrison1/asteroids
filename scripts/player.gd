class_name Player
extends CharacterBody2D


const COOLDOWN = 0.4
const SPEED = 400.0
const ROTATION_SPEED = 2.5

static var is_respawn := false

@export var explosion_scene: PackedScene
@export var missile_scene: PackedScene

var invincible := true
var can_shoot := true
var rotation_direction := 0.0
var tween: Tween

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var screen_size = get_viewport_rect().size
@onready var shoot_sfx: AudioStreamPlayer2D = $ShootSFX
@onready var thrust: AudioStreamPlayer2D = $Thrust


func _ready() -> void:
	# only play iframe flash anim on respawns
	if is_respawn:
		animation_player.play("flash")
		await get_tree().create_timer(1.5).timeout
		invincible = false
		animation_player.play("idle")
	else:
		invincible = false
		is_respawn = true


func _process(_delta: float) -> void:
	fire_missile()


func _physics_process(delta: float):
	get_input()
	rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
	screen_wrap()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("thrust"):
		animated_sprite_2d.frame = 1
		if tween and tween.is_running():
			tween.stop()
		thrust.play()
		thrust.volume_db = 10.0

	if event.is_action_released("thrust"):
		animated_sprite_2d.frame = 0
		if thrust.playing:
			tween = create_tween()
			tween.tween_property(thrust, "volume_db", -80.0, 6.0)
			tween.tween_callback(thrust.stop)


func get_input():
	var input_strength = Input.get_action_strength("thrust")
	var new_velocity = transform.x * input_strength * SPEED
	var damp = 10.0 if input_strength else 1.0
	velocity = velocity.move_toward(new_velocity, damp)
	rotation_direction = Input.get_axis("turn_left", "turn_right")


func fire_missile() -> void:
	if not can_shoot: return

	if Input.is_action_pressed("shoot"):
		var missile = missile_scene.instantiate()
		missile.position = position + Vector2.from_angle(rotation) * 40.0
		missile.rotation = rotation
		get_parent().add_child(missile)
		shoot_sfx.play()
		can_shoot = false
		await get_tree().create_timer(COOLDOWN).timeout
		can_shoot = true


func screen_wrap() -> void:
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)


func spawn_explosion() -> void:
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		get_parent().add_child.call_deferred(explosion)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if invincible: return
	if area.is_in_group("Enemy"):
		spawn_explosion()
		Global.player_died.emit()
		if area is Missile:
			area.queue_free()
		queue_free()
