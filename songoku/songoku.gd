extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# lực hất tung từ boss
const KNOCKBACK_Y = -450.0
const KNOCKBACK_X = 250.0

@onready var anm = $AnimatedSprite2D

@export var kame_scene : PackedScene

var facing = 1
var hp = 100

# trạng thái bị hất tung
var is_knocked = false


func _ready():
	add_to_group("player")
	print("Songoku đã sẵn sàng, HP:", hp)


func take_damage(damage_amount):
	hp -= damage_amount
	print("Player nhận sát thương:", damage_amount, " - HP còn lại:", hp)

	# bị hất tung khi nhận damage
	knock_up()

	if hp <= 0:
		print("Player đã chết!")
		queue_free()


# =========================
# HẤT TUNG
# =========================
func knock_up():
	is_knocked = true

	# đẩy lên
	velocity.y = KNOCKBACK_Y

	# đẩy ngang theo hướng ngược boss (tạm thời random nếu không truyền hướng)
	velocity.x = -facing * KNOCKBACK_X


# =========================
func shoot():
	var kame = kame_scene.instantiate()

	kame.direction = facing

	get_parent().add_child(kame)

	kame.position = $Marker2D.global_position

	print("Bắn đạn, hướng:", facing)


func _physics_process(delta: float) -> void:

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# nếu đang bị hất tung → giảm control
	if is_knocked:
		anm.play("hattung")
		move_and_slide()

		# khi chạm đất thì reset trạng thái
		if is_on_floor():
			is_knocked = false

		return

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
		facing = direction
		anm.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Shoot
	if Input.is_action_just_pressed("attack"):
		shoot()

	# Animation
	if not is_on_floor():
		anm.play("nhay")
	elif direction != 0:
		anm.play("run")
	else:
		anm.play("dung")

	move_and_slide()
