extends Node2D

@onready var spawn_point = $SpawnPoint
var player
var boss

func _ready():
	
	# =========================
	# SAFE CHECK GLOBAL
	# =========================
	if Global.selected_player_scene == null:
		Global.selected_player_scene = preload("res://songoku/songoku.tscn")

	# =========================
	# SPAWN PLAYER
	# =========================
	player = Global.selected_player_scene.instantiate()

	if player == null:
		push_error("Player instantiate failed!")
		return

	add_child(player)

	# =========================
	# SAFE POSITION
	# =========================
	if spawn_point != null:
		player.global_position = spawn_point.global_position
	else:
		player.global_position = Vector2.ZERO
func _reload_scene():

	get_tree().reload_current_scene()


func _process(delta):

	# F1 restart
	if Input.is_physical_key_pressed(KEY_F1):

		call_deferred("_reload_scene")

	# F2 menu
	if Input.is_physical_key_pressed(KEY_F2):

		get_tree().change_scene_to_file("res://main.tscn")
