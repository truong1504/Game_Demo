extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -470.0

# lực hất tung
const KNOCKBACK_Y = -350.0
const KNOCKBACK_X = 100.0

@onready var anm = $AnimatedSprite2D

@export var kame_scene : PackedScene

var facing = 1

# =========================
# HP
# =========================
var max_hp = 160
var hp = 160

# =========================
# STATE
# =========================
var is_knocked = false
var is_dead = false

# =========================
# HP BAR
# =========================
var hp_bar_bg
var hp_bar


func _ready():

	add_to_group("player")

	anm.play("dung")

	create_hp_bar()

	print("Songoku ready HP:", hp)


# =========================
# CREATE HP BAR
# =========================
func create_hp_bar():

	# nền
	hp_bar_bg = ColorRect.new()

	hp_bar_bg.size = Vector2(80, 8)

	hp_bar_bg.color = Color.BLACK

	add_child(hp_bar_bg)

	hp_bar_bg.position = Vector2(-40, -70)

	# máu
	hp_bar = ColorRect.new()

	hp_bar.size = Vector2(80, 8)

	hp_bar.color = Color.GREEN

	add_child(hp_bar)

	hp_bar.position = Vector2(-40, -70)


# =========================
# UPDATE HP BAR
# =========================
func update_hp_bar():

	var ratio = float(hp) / float(max_hp)

	hp_bar.size.x = 80 * ratio

	if ratio > 0.6:

		hp_bar.color = Color.GREEN

	elif ratio > 0.3:

		hp_bar.color = Color.YELLOW

	else:

		hp_bar.color = Color.RED


# =========================
# DAMAGE
# =========================
func take_damage(damage_amount):

	if is_dead:
		return

	hp -= damage_amount

	update_hp_bar()

	print("Player nhận sát thương:", damage_amount)
	print("HP còn:", hp)

	knock_up()

	if hp <= 0:

		die()


# =========================
# DIE
# =========================
func die():

	if is_dead:
		return

	is_dead = true

	velocity = Vector2.ZERO

	print("Player chết")

	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file("res://main.tscn")


# =========================
# KNOCKBACK
# =========================
func knock_up():

	is_knocked = true

	velocity.y = KNOCKBACK_Y

	velocity.x = -facing * KNOCKBACK_X


# =========================
# SHOOT
# =========================
func shoot():

	if is_dead:
		return

	var kame = kame_scene.instantiate()

	kame.direction = facing

	get_parent().add_child(kame)

	kame.position = $Marker2D.global_position

	print("Bắn đạn:", facing)


# =========================
# PROCESS
# =========================
func _physics_process(delta):

	# =========================
	# HOTKEY
	# =========================

	# F1 = restart
	if Input.is_key_pressed(KEY_F1):

		get_tree().reload_current_scene()

	# F2 = menu
	if Input.is_key_pressed(KEY_F2):

		get_tree().change_scene_to_file("res://main.tscn")

	# =========================
	# DEAD
	# =========================
	if is_dead:

		move_and_slide()

		return

	# =========================
	# FIX HP BAR FLIP
	# =========================
	hp_bar.scale.x = 1
	hp_bar_bg.scale.x = 1

	# =========================
	# GRAVITY
	# =========================
	if not is_on_floor():

		velocity += get_gravity() * delta

	# =========================
	# KNOCKBACK
	# =========================
	if is_knocked:

		anm.play("hattung")

		move_and_slide()

		if is_on_floor():

			is_knocked = false

		return

	# =========================
	# JUMP
	# =========================
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():

		velocity.y = JUMP_VELOCITY

	# =========================
	# MOVE
	# =========================
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:

		velocity.x = direction * SPEED

		facing = direction

		anm.flip_h = direction < 0

	else:

		velocity.x = move_toward(velocity.x, 0, SPEED)

	# =========================
	# SHOOT
	# =========================
	if Input.is_action_just_pressed("attack"):

		shoot()

	# =========================
	# ANIMATION
	# =========================
	if not is_on_floor():

		anm.play("nhay")

	elif direction != 0:

		anm.play("run")

	else:

		anm.play("dung")

	move_and_slide()
