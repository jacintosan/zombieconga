extends Node2D

class_name BaseLevel

var npc = preload("res://Npc/Npc.tscn")
var car = preload("res://Car/Car.tscn")

onready var y_sort = $YSort
onready var player = $YSort/Player

onready var l_current = $VBoxContainer/HBoxContainer/LCurrent
onready var l_max = $VBoxContainer/HBoxContainer2/LMax

var splat = preload("res://Splat/Splat.tscn")

onready var splats = $splats

var player_spawn_point = Vector2()

var conga = []
var max_npcs = 5
var car_rate = 1
var npc_rate = 1
var can_spawn_cars = true
var can_spawn_npcs = true
var currenthorde = 0
var maxhorde = 0

func _init():
	randomize()

func _ready():
	spawn_player()

func _process(_delta):
	update_score()
	spawn_car()
	if get_tree().get_nodes_in_group("npcs").size() < max_npcs:
		spawn_npc()

func set_player_spawn_position(position=player_spawn_point):
	player_spawn_point = position

func spawn_player():
	player.position = _relative_position_to_screen(player_spawn_point)

func _relative_position_to_screen(relative):
	var viewportSize = get_viewport().size
	return relative * viewportSize

func add_zombie(zombie):
	conga.append(zombie)

func get_following(zombie):
	var pos = conga.bsearch(zombie)
	print(pos)
	if pos:
		return conga[pos-1]

func kill(node):
	var pos = conga.bsearch(node)	
	var zombie = conga.pop_at(pos)
	if (zombie != null and zombie.is_in_group("zombie")):
		var newsplat = splat.instance()
		newsplat.position = zombie.position
		newsplat.modulate = Color.darkgreen
		splats.add_child(newsplat)
		zombie.queue_free()

func update_score():
	currenthorde = conga.size() -1
	if currenthorde > maxhorde:
		maxhorde = currenthorde
	l_current.set_text(String(currenthorde))
	l_max.set_text(String(maxhorde))

func spawn_npc():
	if can_spawn_npcs:
		can_spawn_npcs = false
		var screen = get_viewport().size
		var newnpc = npc.instance()
		newnpc.position = Vector2(int(randi() % int(screen.x)), int(randi() % int(screen.y)))
		y_sort.add_child(newnpc)
		yield(get_tree().create_timer(npc_rate), "timeout")
		can_spawn_npcs = true

func spawn_car():
	if can_spawn_cars:
		can_spawn_cars = false
		var init_offset = 16
		var scr_size = get_viewport().size
		var r = int(rand_range(0, 4))
		var new_car = car.instance()
		var dir = Vector2()
		var pos = Vector2(-init_offset, -init_offset)
		if r==0:
			dir = Vector2(0,1)
			pos = Vector2(scr_size.x / 2 - 5, -init_offset)
		if r==1:
			dir = Vector2(0,-1)
			pos = Vector2(scr_size.x / 2 + +20, scr_size.y)
		if r==2:
			dir = Vector2(1,0)
			pos = Vector2(-init_offset, scr_size.y / 2 + 10)
		if r==3:
			dir = Vector2(-1,0)
			pos = Vector2(scr_size.x + init_offset, scr_size.y / 2 - init_offset)
		y_sort.add_child(new_car)
		new_car.position = pos
		new_car.set_direction(dir)
		yield(get_tree().create_timer(car_rate), "timeout")
		can_spawn_cars = true
