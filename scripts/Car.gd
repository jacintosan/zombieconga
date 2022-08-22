extends KinematicBody2D

export (int) var speed = 1

onready var taxi_anim = $TaxiAnim
onready var red_anim = $RedAnim
onready var green_anim = $GreenAnim

var _animated_sprite

var velocity = Vector2()


func _ready():
	taxi_anim.visible = false
	red_anim.visible = false
	green_anim.visible = false
	randomize()
	var r = randi() % 3
	if (r==0):
		_animated_sprite = taxi_anim
	elif (r==1):
		_animated_sprite = green_anim
	elif (r==2):
		_animated_sprite = red_anim
	_animated_sprite.visible = true
	set_direction(Vector2(0,1))

func set_direction(dir):
	velocity = dir * speed
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

func _physics_process(delta):
	move_and_collide(velocity)

func _process(delta):
	var screen = get_viewport().size
	if (_animated_sprite.get_animation() == "left" and position.x < 0):
		queue_free()
	if (_animated_sprite.get_animation() == "right" and position.x > screen.x):
		queue_free()
	if (_animated_sprite.get_animation() == "up" and position.y < 0):
		queue_free()
	if (_animated_sprite.get_animation() == "down" and position.y > screen.y):
		queue_free()
