extends Control

onready var master_bus = AudioServer.get_bus_index("Master")
onready var music_bus = AudioServer.get_bus_index("Music")
onready var sfx_bus = AudioServer.get_bus_index("Sfx")
onready var volume_panel = $VolumePanel

func _ready():
	volume_panel.set_position(Vector2(0, -70))

func _on_MasterVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)

func _on_MusicVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, value)

func _on_SfxVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, value)

func _on_BtnAudio_pressed():
	var tween := create_tween().set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(volume_panel, "rect_position", Vector2(0, 0), 0.35)
