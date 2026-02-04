extends Button


@export var scene_name: String


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if scene_name:
		UIButtonSFX.on_click()
		var next_scene = "res://scenes/" + scene_name + ".tscn"
		get_tree().paused = false
		get_tree().change_scene_to_file(next_scene)
