extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.hiscore:
		text = str(Global.hiscore)
	else:
		text = "HiScore"
