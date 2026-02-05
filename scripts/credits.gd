extends Node2D


@onready var hover: AudioStreamPlayer = $Hover


func _on_main_menu_mouse_entered() -> void:
	hover.play()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(String(meta))
