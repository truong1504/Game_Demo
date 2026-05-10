extends Area2D

var speed = 700
var direction = 1
var damage = 20

@onready var anim = $AnimatedSprite2D

var has_hit = false

func _ready():
	add_to_group("kame")

	body_entered.connect(_on_body_entered)

	monitoring = true
	monitorable = true

	if direction < 0:
		anim.play("flytrai")
	else:
		anim.play("flyphai")



func _physics_process(delta):

	var from = global_position
	var to = global_position + Vector2(speed * direction * delta, 0)

	# =========================
	# RAYCAST CHECK (CHỐNG XUYÊN 100%)
	# =========================
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space_state.intersect_ray(query)

	if result:
		var collider = result.collider

		if collider.is_in_group("boss"):
			_hit_boss(collider)
			return

	# nếu không trúng gì → di chuyển bình thường
	global_position = to


# =========================
# FALLBACK (Area2D detect)
# =========================
func _on_body_entered(body):

	if has_hit:
		return

	if body.is_in_group("boss"):
		_hit_boss(body)


# =========================
# HIT LOGIC
# =========================
func _hit_boss(body):

	if has_hit:
		return

	has_hit = true

	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
