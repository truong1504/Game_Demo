extends Node2D



func _on_map_1_pressed() -> void:
	Global.selected_map = preload("res://map/Map1.tscn")
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_map_2_pressed() -> void:
	Global.selected_map = preload("res://map/Map2.tscn")
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.
