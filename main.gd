extends Node2D


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://map/Map1.tscn")


func _on_menu_button_2_pressed() -> void:
	get_tree().quit()


func _on_menu_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://chon_nv.tscn")
	pass # Replace with function body.
