extends RigidBody2D
class_name Player

onready var _animated_sprite = $AnimatedSprite

export (int) var speed = 15
var velocity = Vector2()
var level

func _ready():
	level = get_tree().get_nodes_in_group("level")[0]
	level.add_zombie(self)

func _get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play("right")
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		_animated_sprite.play("left")
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		_animated_sprite.play("down")
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		_animated_sprite.play("up")
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	_get_input()
	velocity = apply_central_impulse(velocity)

func _integrate_forces(_state):
	_get_input()
