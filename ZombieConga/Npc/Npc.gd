extends RigidBody2D
class_name Npc

onready var _animated_sprite = $AnimatedSprite

var framesets = ["char1.tres", "char2.tres",
				"char3.tres", "char4.tres",
				"char5.tres", "char6.tres"]

var speed = 3
var vel = Vector2()

var is_zombie = false
var is_human = true
var is_scared_from = null

var health = 1

var following
var player
var iddle_direction = Vector2()
var iddle_speed = 0.5
var index

signal kill_zombie(zombie)
signal convert_zombie(human)

func _ready():
	randomize()

	set_human()
	
	var frameset = framesets[randi() % framesets.size()]
	_animated_sprite.frames = load("res://assets/%s" % frameset)

func _integrate_forces(_state):
	if is_zombie:
		process_follow()
	if is_human:
		process_idle()
	if is_scared_from:
		process_escape()
	set_anim()

func _on_HitArea_body_entered(body):
	if is_human:
		if body.is_in_group("player"):
			process_bite()
	elif body.is_in_group("cars"):
		emit_signal("kill_zombie", self)

func _on_ScareArea_body_entered(body):
	if (body.is_in_group("player")):
		if is_human:
			is_scared_from = body

func _on_ScareArea_body_exited(body):
	if (body.is_in_group("player")):
		if is_human:
			is_scared_from = null
	

func process_bite():
	health -= 1
	if health <= 0:
		convert_zombie()

func convert_zombie():
	add_to_group("zombie")
	is_zombie = true
	is_human = false
	is_scared_from = null
	emit_signal("convert_zombie", self)
	_animated_sprite.modulate = Color.aquamarine

func set_following(zombie):
	following = zombie

func process_follow():
	if (following != null and is_instance_valid(following) and following.is_in_group("zombie")):
		var following_dinstance = global_position.distance_to(following.global_position)
		if (following_dinstance > 20):
			var dir = (following.global_position - global_position).normalized()
			dir = dir * speed
			apply_central_impulse(dir)

func process_escape():
	if (is_scared_from):
		_animated_sprite.modulate = Color.crimson
		var dir = (global_position - is_scared_from.global_position).normalized()
		apply_central_impulse(dir)
		iddle_direction = dir

func process_idle():
	apply_central_impulse(iddle_direction * iddle_speed)
	_animated_sprite.modulate = Color.white
	if (rand_range(1, 100) < 5):
		iddle_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()

func set_human():
	is_zombie = false
	is_human = true
	iddle_direction = Vector2(randi(),randi()).normalized()

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
