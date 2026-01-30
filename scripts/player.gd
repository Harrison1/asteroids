class_name Player
extends CharacterBody2D


const COOLDOWN = 0.4
const SPEED = 400.0
const ROTATION_SPEED = 2.5

@export var missile_scene: PackedScene

var can_shoot := true
var rotation_direction := 0.0

@onready var screen_size = get_viewport_rect().size
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D


func get_input():
	var input_strength = Input.get_action_strength("thrust")
	var new_velocity = transform.x * input_strength * SPEED
	var damp = 10.0 if input_strength else 1.0
	velocity = velocity.move_toward(new_velocity, damp)

	rotation_direction = Input.get_axis("turn_left", "turn_right")


func _process(_delta: float) -> void:
	fire_missile()


func _physics_process(delta: float):
	get_input()
	rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
	screen_wrap()


func fire_missile() -> void:
	if not can_shoot: return

	if Input.is_action_pressed("shoot"):
		var missile = missile_scene.instantiate()
		missile.position = position + Vector2.from_angle(rotation) * 40.0
		missile.rotation = rotation
		get_parent().add_child(missile)
		#shoot.play()
		can_shoot = false
		await get_tree().create_timer(COOLDOWN).timeout
		can_shoot = true


func screen_wrap() -> void:
	position.x = fposmod(position.x, screen_size.x)
	position.y = fposmod(position.y, screen_size.y)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		Global.player_died.emit()
		queue_free()
		#hide()
		#collision_shape_2d.set_deferred("disabled", true)
		#await get_tree().create_timer(1.0).timeout
		#get_tree().reload_current_scene.call_deferred()
