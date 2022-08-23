extends Node2D

onready var audio_splat = $AudioSplat

func _ready():
	randomize()
	rotation_degrees = rand_range(1, 360)
	audio_splat.play()
