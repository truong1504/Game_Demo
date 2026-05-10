extends Node2D



func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://word.tscn")
	pass # Replace with function body.


func _on_menu_button_2_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
