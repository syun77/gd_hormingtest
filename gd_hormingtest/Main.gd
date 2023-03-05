extends Node2D

# 画面の中央.
const CENTER_X = 1024.0 / 2
const CENTER_Y = 600.0 / 2

onready var _camera = $MainCamera

onready var _main_layer = $MainLayer
onready var _shot_layer = $ShotLayer
onready var _particle_layer = $ParticleLayer
onready var _hdr = $WorldEnvironment

onready var _checkbox_laser = $UILayer/CheckButtonLaser
onready var _hslider_max_shot = $UILayer/HSliderMaxShot
onready var _hslider_max_shot_label = $UILayer/HSliderMaxShot/Label


func _ready() -> void:
	var layers = {
		"main": _main_layer,
		"shot": _shot_layer,
		"particle": _particle_layer,
	}
	Common.setup(layers)

func _process(delta: float) -> void:
	Common.set_trail(_checkbox_laser.pressed)
	var max_shot = _hslider_max_shot.value
	_hslider_max_shot_label.text = "%d/32"%max_shot
	Common.set_max_shot(max_shot)
