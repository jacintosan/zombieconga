extends RigidBody2D

onready var _animated_sprite = $AnimatedSprite
var splat = preload("res://Splat.tscn")
onready var audio_splat = $AudioSplat

onready var splats = $"../../splats"

export (int) var speed = 15
var velocity = Vector2()
var npclist = []
var index = 0

func _ready():
	push(self)

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
	#velocity = move_and_slide(velocity)
	velocity = apply_central_impulse(velocity)

func _integrate_forces(_state):
	_get_input()

func get_last():
	return npclist.back()
	
func push(node):
	npclist.append(node)
	node.index = npclist.size() - 1

func kill(node):
	print(node.index)
	var pos = node.index
	var new_index = 0
	for i in range(npclist.size()):
		if (pos != i):
			npclist[i].index = new_index
			new_index += 1
	if (npclist.size() > 2 and pos < npclist.size() - 1):
		var next = npclist[pos+1]
		var prev = npclist[pos-1]
		next.follow(prev)
	var die = npclist.pop_at(pos)

	if (die != null and die.is_in_group("npcs")):
		var newsplat = splat.instance()
		newsplat.position = die.position
		newsplat.modulate = Color.darkgreen
		splats.add_child(newsplat)
		audio_splat.play()
	#yield(get_tree().create_timer(1), "timeout")
	if die:
		die.visible = false
		die.queue_free()
	
