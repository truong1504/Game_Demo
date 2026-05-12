extends Node2D

var map

func _on_menu_button_pressed() -> void:

	if Global.selected_map == null:
		Global.selected_map = preload("res://map/Map1.tscn")

	map = Global.selected_map.instantiate()
	add_child(map)

func _on_menu_button_2_pressed() -> void:
	get_tree().quit()

func _on_menu_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://chon_nv.tscn")


func _on_menu_button_4_pressed() -> void:
	get_tree().change_scene_to_file("res://select_map.tscn")
	pass # Replace with function body.
