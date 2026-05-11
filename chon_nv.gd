extends Node2D

@onready var anm = $AnimatedSprite2D2
@onready var anm1 = $AnimatedSprite2D

func _ready():
	anm.play("son")
	anm1.play("janitor")

func _on_menu_button_pressed() -> void:
	Global.selected_player_scene = preload("res://janitor/janitor.tscn")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_menu_button_2_pressed() -> void:
	Global.selected_player_scene = preload("res://songoku/songoku.tscn")
	get_tree().change_scene_to_file("res://main.tscn")


# =========================
# CHECK BEFORE START GAME
# =========================
func _on_play_button_pressed() -> void:
	if Global.selected_player_scene == null:
		print("Chưa chọn nhân vật!")
		return

	get_tree().change_scene_to_file("res://main.tscn")
