extends Node2D

var npc = preload("res://NpcRigid.tscn")
var car = preload("res://Car.tscn")
onready var y_sort = $YSort
onready var player = $YSort/Player

onready var l_current = $VBoxContainer/HBoxContainer/LCurrent
onready var l_max = $VBoxContainer/HBoxContainer2/LMax

var npcs = []
var max_npcs = 100
var car_rate = 4
var npc_rate = 4
var can_spawn_cars = true
var can_spawn_npcs = true
var currenthorde = 0
var maxhorde = 0

func _ready():
	randomize()
	spawn_npc()

func spawn_npc():
	if can_spawn_npcs:
		can_spawn_npcs = false
		var screen = get_viewport().size
		var newnpc = npc.instance()
		newnpc.set_player(player)
		npcs.append(newnpc)
		newnpc.position = Vector2(int(randi() % int(screen.x)), int(randi() % int(screen.y)))
		y_sort.add_child(newnpc)
		yield(get_tree().create_timer(npc_rate), "timeout")
		can_spawn_npcs = true

func _process(_delta):
	update_score()
	spawn_car()
	if get_tree().get_nodes_in_group("npcs").size() < max_npcs:
		spawn_npc()

func update_score():
	currenthorde = player.npclist.size() -1
	if currenthorde > maxhorde:
		maxhorde = currenthorde
	l_current.set_text(String(currenthorde))
	l_max.set_text(String(maxhorde))

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


