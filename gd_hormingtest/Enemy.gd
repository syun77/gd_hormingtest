extends Area2D

class_name Enemy

const TIMER_SHAKE = 1.0

onready var _spr = $Enemy

var _start_pos = Vector2.ZERO
var _shake_timer = 0.0
var _cnt = 0

# ノイズテクスチャ
var _noise := OpenSimplexNoise.new()
var _noise_y := 0

func hit(vel:Vector2) -> void:
	# 揺れ開始.
	_shake_timer = 1.0
	_noise_y = randi()
	
func _process(delta: float) -> void:
	_cnt += 1
	
	_spr.position = Vector2.ZERO
	if _shake_timer > 0:
		_shake_timer -= delta
		var t = _shake_timer
		# 残り時間の幅でノイズテクスチャを使って揺らす
		_noise_y += 1000 * delta # 動かす
		_spr.position.x = t * (16 * _noise.get_noise_2d(_noise.seed * 2, _noise_y))
		_spr.position.y = t * (16 * _noise.get_noise_2d(_noise.seed * 3, _noise_y))

func _ready() -> void:
	_start_pos = position
