extends CanvasLayer


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var new_hi_score: Label = $NewHiScore
@onready var score: Label = $Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.game_over.connect(game_over)


func game_over() -> void:
	visible = true
	audio_stream_player_2d.play()
	score.text = "Score:" + str(Global.score)
	if Global.score > Global.hiscore:
		Global.hiscore = Global.score
		animation_player.active = true
		animation_player.play("flash")
