extends Area2D

var speed = 700
var direction = 1
var damage = 35

var exploded = false

@onready var anim = $AnimatedSprite2D
@onready var col = $CollisionShape2D


func _ready():

	# animation theo hướng
	if direction < 0:

		anim.play("tenluatrai")

	else:

		anim.play("teluaphai")

	add_to_group("player_attack")


# =========================
# PHYSICS PROCESS
# =========================
func _physics_process(delta):

	# tránh xử lý sau khi va chạm
	if exploded:
		return

	# vị trí hiện tại
	var from = global_position

	# vị trí tiếp theo
	var to = from + Vector2(speed * direction * delta, 0)

	# =========================
	# RAYCAST CHỐNG XUYÊN
	# =========================
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsRayQueryParameters2D.create(from, to)

	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_ray(query)

	# =========================
	# HIT
	# =========================
	if result:

		var body = result.collider

		# hit boss/enemy
		if body.is_in_group("boss") or body.is_in_group("enemy"):

			if body.has_method("take_damage"):

				body.take_damage(damage)

			queue_free()

			return

		# hit map/tường
		queue_free()

		return

	# =========================
	# MOVE
	# =========================
	global_position = to


# =========================
# OUT SCREEN
# =========================
func _on_visible_on_screen_notifier_2d_screen_exited():

	queue_free()
