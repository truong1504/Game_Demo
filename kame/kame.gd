extends Area2D

var speed = 700
var direction = 1
var damage = 20

@onready var anim = $AnimatedSprite2D

var has_hit = false  # tránh trúng nhiều lần

func _ready():
	
	if direction < 0:
		anim.play("flytrai")
	else:
		anim.play("flyphai")

	# connect an toàn
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	monitoring = true

	print("Kame đã sẵn sàng, damage:", damage)


func _physics_process(delta):
	position.x += speed * direction * delta


# =========================
# VA CHẠM
# =========================
func _on_body_entered(body):

	if has_hit:
		return

	print("=== VA CHẠM ===")
	print("Trúng:", body.name)

	# CHỈ TRÚNG BOSS / ENEMY
	if body.is_in_group("boss") or body.is_in_group("enemy"):

		has_hit = true

		print("TRÚNG BOSS -> damage:", damage)

		if body.has_method("take_damage"):
			body.take_damage(damage)

		# hiệu ứng nhỏ (có thể thêm)
		_spawn_hit_effect()

		queue_free()
		return

	# trúng tường / vật khác
	queue_free()


# =========================
# EFFECT (optional)
# =========================
func _spawn_hit_effect():
	# placeholder: bạn có thể spawn particle ở đây
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
