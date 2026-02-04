extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	UIButtonSFX.on_click()
	Global.reset_stats()
	get_tree().reload_current_scene.call_deferred()
