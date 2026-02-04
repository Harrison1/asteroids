extends Node2D


@onready var hover: AudioStreamPlayer2D = $Hover


func _on_main_menu_mouse_entered() -> void:
	hover.play()
