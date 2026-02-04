extends CanvasLayer

@onready var click: AudioStreamPlayer2D = $Click
@onready var controls_menu: Control = $ControlsMenu
@onready var hover: AudioStreamPlayer2D = $Hover
@onready var menu: Control = $Menu


func _ready() -> void:
	Global.pause_game.connect(pause_listener)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		toggle_visibility()


func pause_listener() -> void:
	toggle_visibility()


func toggle_visibility() -> void:
	if get_tree().paused:
		show()
		menu.show()
		controls_menu.hide()
	else:
		hide()


func _on_controls_pressed() -> void:
	click.play()
	menu.hide()
	controls_menu.show()


func _on_resume_pressed() -> void:
	click.play()
	get_tree().paused = false
	toggle_visibility()


func _on_resume_mouse_entered() -> void:
	hover.play()


func _on_controls_mouse_entered() -> void:
	hover.play()


func _on_quit_mouse_entered() -> void:
	hover.play()


func _on_back_pressed() -> void:
	click.play()
	controls_menu.hide()
	menu.show()


func _on_back_mouse_entered() -> void:
	hover.play()


# notifications not working as expected when process_mode is set to always
#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_PAUSED:
			#show()
