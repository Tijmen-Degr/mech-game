extends Control


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Battle_UI.tscn")


func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://controls.tscn")
	

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
