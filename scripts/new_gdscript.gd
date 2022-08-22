extends KinematicBody2D

onready var _animated_sprite = $AnimatedSprite
var speed = 10000
var vel = Vector2()

var following

func follow(node):
	following = node

func _physics_process(delta):
	if following:
		var dir = (following.global_position - global_position).normalized()
		dir = dir * speed * delta
		if (global_position.distance_to(following.global_position) > 16.0):
			move_and_slide(dir)

func _on_Area2D_body_entered(player):
	if (!following):
		var follow = player.get_last()
		player.push(self)
		following = follow
