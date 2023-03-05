extends Node2D

# 画面の中央.
const CENTER_X = 1024.0 / 2
const CENTER_Y = 600.0 / 2

onready var _camera = $MainCamera

onready var _bg_layer = $BgLayer
onready var _main_layer = $MainLayer
onready var _shot_layer = $ShotLayer
onready var _particle_layer = $ParticleLayer
onready var _hdr = $WorldEnvironment

onready var _checkbox_laser = $UILayer/CheckButtonLaser
onready var _hslider_max_shot = $UILayer/HSliderMaxShot
onready var _hslider_max_shot_label = $UILayer/HSliderMaxShot/Label
onready var _checkbox_bloom = $UILayer/CheckButtonBloom
onready var _checkbox_smoke = $UILayer/CheckButtonSmoke
onready var _checkbox_smoke_rand = $UILayer/CheckButtonSmokeRand


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
	var is_glow = _checkbox_bloom.pressed
	_hdr.environment.glow_enabled = is_glow
	for obj in _bg_layer.get_children():
		if not obj is Sprite:
			continue
		var spr = obj as Sprite
		if is_glow:
			spr.modulate = Color.slategray
		else:
			spr.modulate = Color.white
	Common.set_smoke(_checkbox_smoke.pressed)
	Common.set_smoke_rand(_checkbox_smoke_rand.pressed)

