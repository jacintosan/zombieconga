extends CanvasLayer
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func change_scene(target: String, type: String = 'fade_out') -> void:
	if type == 'dissolve':
		transition_dissolve(target)
	elif type == 'slide':
		transition_slide(target)
	elif type == 'fade_out':
		transition_fade_out(target)

func transition_fade_out(target: String) -> void:
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	var screenshot = ImageTexture.new()
	screenshot.create_from_image(img)
	sprite.texture = screenshot
	sprite.centered = false
	sprite.position = Vector2.ZERO
	sprite.visible = true
	animation_player.play('fade_out')
	get_tree().change_scene(target)
	yield(animation_player, "animation_finished")
	sprite.visible = false

func transition_dissolve(target: String) -> void:
	animation_player.play('dissolve')
	yield(animation_player, "animation_finished")
	get_tree().change_scene(target)
	animation_player.play_backwards("dissolve")

func transition_slide(target: String) -> void:
	animation_player.play('slide')
	yield(animation_player, "animation_finished")
	get_tree().change_scene(target)
	animation_player.play_backwards("slide")
