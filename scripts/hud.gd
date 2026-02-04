extends CanvasLayer


@export var life_texture: Texture2D

var life_array: Array[Sprite2D]

@onready var score_label: Label = $Score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_died.connect(substract_life)
	Global.update_score.connect(set_score)
	render_lives()


func set_score(points: int) -> void:
	Global.score += points
	score_label.text = str(Global.score)


func render_lives() -> void:
	for i in range(Global.player_lives):
		var sprite_node = Sprite2D.new()
		sprite_node.texture = life_texture
		sprite_node.scale = Vector2(0.5, 0.5)
		sprite_node.global_position = Vector2(277.0 - (i * 40.0), 100.0)
		add_child(sprite_node)
		life_array.append(sprite_node)


func substract_life() -> void:
	var last_life = life_array.pop_back()
	last_life.queue_free()
