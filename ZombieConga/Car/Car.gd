extends KinematicBody2D

export (int) var speed = 50

export(Array, SpriteFrames) var framesets=[]

onready var _animated_sprite = $AnimatedSprite
onready var animation_player = $AnimationPlayer

var velocity = Vector2()

func _ready():
	var frameset = framesets[randi() % framesets.size()]
	_animated_sprite.frames = frameset
	animation_player.play("Moving")

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

func _physics_process(_delta):
	move_and_slide(velocity)

func _process(_delta):
	var screen = get_viewport().size
	if (_animated_sprite.get_animation() == "left" and position.x < 0):
		queue_free()
	if (_animated_sprite.get_animation() == "right" and position.x > screen.x):
		queue_free()
	if (_animated_sprite.get_animation() == "up" and position.y < 0):
		queue_free()
	if (_animated_sprite.get_animation() == "down" and position.y > screen.y):
		queue_free()
