extends Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_tiep_tuc_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_choi_lai_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://map/Map1.tscn")

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
