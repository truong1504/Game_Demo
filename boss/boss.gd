extends CharacterBody2D

const SPEED = 300.0
const JUMP_KNOCKBACK = -450.0

# =========================
# HP
# =========================
var max_hp = 1500
var hp = 1500

var damage = 20

# =========================
# STATE
# =========================
var can_attack = true
var is_resting = false
var is_dead = false

# phase 2
var transformed = false
var is_transforming = false

# =========================
# NODE
# =========================
@onready var anm = $Container/AnimatedSprite2D

var player

# HP BAR
var hp_bar_bg
var hp_bar


func _ready():

	add_to_group("boss")

	await get_tree().process_frame

	player = get_tree().get_first_node_in_group("player")

	anm.play("dung")

	create_hp_bar()

	print("Boss ready HP:", hp)


func _physics_process(delta):

	# =========================
	# PLAYER NULL FIX
	# =========================
	if player == null:

		player = get_tree().get_first_node_in_group("player")

		if player == null:
			return

	# =========================
	# DEAD
	# =========================
	if is_dead:
		return

	# =========================
	# TRANSFORM
	# =========================
	if is_transforming:

		velocity = Vector2.ZERO

		move_and_slide()

		return

	# =========================
	# GRAVITY
	# =========================
	if not is_on_floor():

		velocity += get_gravity() * delta

	# =========================
	# REST
	# =========================
	if is_resting:

		velocity.x = 0

		move_and_slide()

		return

	# =========================
	# DISTANCE
	# =========================
	var distance = player.global_position.x - global_position.x

	# phase 2 bị ngược
	if transformed:
		anm.flip_h = distance > 0
	else:
		anm.flip_h = distance < 0

	# =========================
	# MOVE
	# =========================
	if abs(distance) > 120:

		velocity.x = sign(distance) * SPEED

		if transformed:

			if anm.animation != "chay2":
				anm.play("chay2")

		else:

			if anm.animation != "chay":
				anm.play("chay")

	# =========================
	# ATTACK
	# =========================
	else:

		velocity.x = 0

		if can_attack:

			attack()

		else:

			if transformed:

				if anm.animation != "dung2":
					anm.play("dung2")

			else:

				if anm.animation != "dung":
					anm.play("dung")

	move_and_slide()


# =========================
# ATTACK
# =========================
func attack():

	if is_dead or is_transforming:
		return

	can_attack = false
	is_resting = true

	if transformed:
		anm.play("attack2")
	else:
		anm.play("attack")

	await get_tree().create_timer(0.5).timeout

	if is_dead or is_transforming:
		return

	_do_damage()

	# trở về idle
	if transformed:
		anm.play("dung2")
	else:
		anm.play("dung")

	await get_tree().create_timer(1.5).timeout

	if is_dead or is_transforming:
		return

	is_resting = false
	can_attack = true


# =========================
# DAMAGE
# =========================
func _do_damage():

	if player == null:
		return

	var dist = abs(player.global_position.x - global_position.x)

	if dist < 170 and player.is_on_floor():

		player.take_damage(damage)

		player.velocity.y = JUMP_KNOCKBACK

		var dir = sign(player.global_position.x - global_position.x)

		player.velocity.x = dir * 250

		print("Boss hit player")


# =========================
# TAKE DAMAGE
# =========================
func take_damage(amount):

	if is_dead:
		return

	if is_transforming:
		return

	hp -= amount

	print("Boss HP:", hp)

	update_hp_bar()

	flash_hit()

	# =========================
	# TRANSFORM
	# =========================
	if hp <= 200 and not transformed:

		transform()

		return

	# =========================
	# DIE
	# =========================
	if hp <= 0:

		die()


# =========================
# TRANSFORM
# =========================
func transform():

	if is_transforming:
		return

	is_transforming = true

	can_attack = false
	is_resting = true

	velocity = Vector2.ZERO

	print("Boss transforming!")

	anm.play("hoahinh")

	await get_tree().create_timer(3.0).timeout

	if is_dead:
		return

	transformed = true

	# phase 2 hp
	max_hp = 3000
	hp = 3000

	damage = 40

	update_hp_bar()

	is_transforming = false

	can_attack = true
	is_resting = false

	anm.play("dung2")

	print("Boss transformed!")


# =========================
# FLASH HIT
# =========================
func flash_hit():

	anm.modulate = Color(1, 0.5, 0.5)

	await get_tree().create_timer(0.08).timeout

	if is_instance_valid(self):

		anm.modulate = Color(1, 1, 1)


# =========================
# CREATE HP BAR
# =========================
func create_hp_bar():

	# nền
	hp_bar_bg = ColorRect.new()

	hp_bar_bg.size = Vector2(120, 10)

	hp_bar_bg.color = Color.BLACK

	add_child(hp_bar_bg)

	hp_bar_bg.position = Vector2(-60, -120)

	# máu
	hp_bar = ColorRect.new()

	hp_bar.size = Vector2(120, 10)

	hp_bar.color = Color.RED

	add_child(hp_bar)

	hp_bar.position = Vector2(-60, -120)


# =========================
# UPDATE HP BAR
# =========================
func update_hp_bar():

	var ratio = float(hp) / float(max_hp)

	hp_bar.size.x = 120 * ratio

	# màu máu
	if ratio > 0.6:

		hp_bar.color = Color.GREEN

	elif ratio > 0.3:

		hp_bar.color = Color.YELLOW

	else:

		hp_bar.color = Color.RED


# =========================
# DIE
# =========================
func die():

	if is_dead:
		return

	is_dead = true

	can_attack = false
	is_resting = true

	velocity = Vector2.ZERO

	print("Boss died")

	anm.play("die")

	await anm.animation_finished

	get_tree().change_scene_to_file("res://main.tscn")
