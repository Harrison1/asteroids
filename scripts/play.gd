extends Button


@export var animation_player: AnimationPlayer
@export var coin: AudioStreamPlayer2D
@export var hover: AudioStreamPlayer2D
@export var scene_name := "game"


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if scene_name:
		disabled = true
		animation_player.stop()
		modulate.a = 1.0
		text = "1 Coin"
		coin.play()
		await get_tree().create_timer(0.8).timeout
		Global.reset_stats()
		var next_scene = "res://scenes/" + scene_name + ".tscn"
		get_tree().change_scene_to_file(next_scene)


func _on_mouse_entered() -> void:
	hover.play()
