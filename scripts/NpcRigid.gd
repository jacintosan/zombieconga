extends RigidBody2D

onready var _animated_sprite = $AnimatedSprite

onready var anim_1 = $Anim1
onready var anim_2 = $Anim2
onready var anim_3 = $Anim3
onready var anim_4 = $Anim4
onready var anim_5 = $Anim5

var speed = 3
var vel = Vector2()
var is_zombie = false
var scare_distance = 50
var health = 1

var following
var player
var iddle_direction = Vector2()
var iddle_speed = 0.5
var index

func _ready():
	randomize()
	iddle_direction = Vector2(randi(),randi()).normalized()

	anim_1.visible = false
	anim_2.visible = false
	anim_3.visible = false
	anim_4.visible = false
	anim_5.visible = false

	var r = randi() % 5
	if (r==0):
		_animated_sprite = anim_1
	elif (r==1):
		_animated_sprite = anim_2
	elif (r==2):
		_animated_sprite = anim_3
	elif (r==3):
		_animated_sprite = anim_4
	elif (r==4):
		_animated_sprite = anim_5
	_animated_sprite.visible = true

func set_player(node):
	player = node

func follow(node):
	following = node

func _process(delta):
	if !is_zombie:
		if (player.global_position.distance_to(global_position) <= scare_distance):
			_animated_sprite.modulate = Color.lightsalmon
		elif (player.global_position.distance_to(global_position) > scare_distance):
			_animated_sprite.modulate = Color.white

func set_anim():
	var dir = linear_velocity
	if (abs(dir.x) > abs(dir.y)):
		if dir.x < -abs(dir.y):
			_animated_sprite.play("left")
		elif dir.x > abs(dir.y):
			_animated_sprite.play("right")
	else:
		if dir.y < -abs(dir.x):
			_animated_sprite.play("up")
		elif dir.y > abs(dir.x):
			_animated_sprite.play("down")

func _integrate_forces(state):
	if is_zombie:
		process_follow()
	elif (player.global_position.distance_to(global_position) <= scare_distance):
		process_escape()
	elif (player.global_position.distance_to(global_position) > scare_distance):
		process_idle()
	set_anim()

func _on_Area2D_body_entered(node):
	if !is_zombie:
		if node.get_name() == "Player":
			process_bite()
	elif node.is_in_group("cars"):
		process_car()

func process_car():
	player.kill(self)

func process_bite():
	health -= 1
	if health <= 0:
		convert_zombie()

func convert_zombie():
	var follow = player.get_last()
	player.push(self)
	following = follow
	is_zombie = true
	_animated_sprite.modulate = Color.aquamarine

func process_follow():
	if (following == null or !following.is_in_group("npcs") or is_in_group("npcs")):
		pass
	var following_dinstance = global_position.distance_to(following.global_position)
	if (following_dinstance > 20):
		var dir = (following.global_position - global_position).normalized()
		dir = dir * speed
		apply_central_impulse(dir)

func process_escape():
	_animated_sprite.modulate = Color.crimson
	var dir = (global_position - player.global_position).normalized()
	apply_central_impulse(dir)
	iddle_direction = dir

func process_idle():
	apply_central_impulse(iddle_direction * iddle_speed)
	_animated_sprite.modulate = Color.white
	if (rand_range(1, 100) < 5):
		iddle_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
