extends Button

# using export PackedScene for main_menu and credits throws an error. Potential circular dependency issue
# E 0:00:00:367   _printerr: res://scenes/main_menu.tscn:158 - Parse Error: [ext_resource] referenced non-existent resource at: res://scenes/credits.tscn.
# https://forum.godotengine.org/t/parse-error-referenced-non-existent-resource/95356/11
# @export var credits_scene: PackedScene
@export var scene_name: String


func _on_pressed() -> void:
	if scene_name:
		# get_tree().change_scene_to_packed(credits_scene)
		var credits_scene = "res://scenes/" + scene_name +".tscn"
		get_tree().change_scene_to_file(credits_scene)
