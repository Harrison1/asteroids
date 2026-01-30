extends CanvasLayer


var score = 0

@onready var score_label: Label = $Score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.update_score.connect(set_score)


func set_score(points: int) -> void:
	score += points
	score_label.text = str(score)
