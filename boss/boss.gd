extends CharacterBody2D

const SPEED = 200.0
const JUMP_KNOCKBACK = -450.0

var hp = 300
var damage = 20

var can_attack = true
var is_resting = false

@onready var anm = $Container/AnimatedSprite2D
@onready var container = $Container
@onready var player = get_node("../songoku")


func _ready():
	add_to_group("boss")
	print("Boss ready HP:", hp)


func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# nghỉ sau attack
	if is_resting:
		velocity.x = 0
		move_and_slide()
		return

	var distance = player.global_position.x - global_position.x

	# flip hướng
	container.scale.x = sign(distance)

	# =========================
	# AI MOVE + ANIMATION
	# =========================
	if abs(distance) > 120:

		velocity.x = sign(distance) * SPEED

		if is_on_floor():
			if anm.animation != "chay":
				anm.play("chay")

	else:

		velocity.x = 0

		if can_attack and is_on_floor():
			attack()
		else:
			if anm.animation != "dung":
				anm.play("dung")

	move_and_slide()


# =========================
# ATTACK
# =========================
func attack():

	can_attack = false
	is_resting = true

	anm.play("attack")

	await get_tree().create_timer(0.5).timeout

	anm.play("dung")

	_do_damage()

	await get_tree().create_timer(1.5).timeout

	is_resting = false
	can_attack = true


# =========================
# DAMAGE + HẤT TUNG
# =========================
func _do_damage():

	var dist = abs(player.global_position.x - global_position.x)

	if dist < 170 and player.is_on_floor():

		player.take_damage(damage)

		# hất tung
		player.velocity.y = JUMP_KNOCKBACK

		var dir = sign(player.global_position.x - global_position.x)
		player.velocity.x = dir * 250

		print("Boss hit player + knockup")


# =========================
# TAKE DAMAGE
# =========================
func take_damage(amount):

	hp -= amount
	print("Boss HP:", hp)

	if hp <= 0:
		die()


func die():
	print("Boss died")
	queue_free()
