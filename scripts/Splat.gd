extends Node2D

func _ready():
	randomize()
	rotation_degrees = rand_range(1, 360)
