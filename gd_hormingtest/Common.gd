extends Node

const ParticleObj = preload("res://Particle.tscn")
const TIMER_SCREEN_SHAKE = 1.0

var _layers = null
var _max_shot = 32 # 同時に発射可能な弾の数.
var _is_trail = false # トレイル弾を発射するかどうか.
var _is_smoke = false
var _is_smoke_rand = false

func setup(layers) -> void:
	_layers = layers

## レイヤーを取得する.
func get_layer(name:String) -> CanvasLayer:
	return _layers[name]

## 存在するオブジェクトを数える.
func count_obj(name:String) -> int:
	return get_layer(name).get_child_count()

## パーティクルを発生させる.
func add_particle(pos:Vector2, t:float, deg:float, speed:float):
	var p = ParticleObj.instance()
	p.position = pos
	p.start(t, deg, speed)
	get_layer("particle").add_child(p)
	return p

func set_trail(b:bool) -> void:
	_is_trail = b
func is_trail() -> bool:
	return _is_trail

func set_max_shot(n:int) -> void:
	_max_shot = n
func get_max_shot() -> int:
	return _max_shot
	
func set_smoke(b:bool) -> void:
	_is_smoke = b
func is_smoke() -> bool:
	return _is_smoke
func set_smoke_rand(b:bool) -> void:
	_is_smoke_rand = b
func is_smoke_rand() -> bool:
	return _is_smoke_rand

## 角度差を求める.
func diff_angle(now:float, next:float) -> float:
	# 角度差を求める.
	var d = next - now
	# 0.0〜360.0にする.
	d -= floor(d / 360.0) * 360.0
	# -180.0〜180.0の範囲にする.
	if d > 180.0:
		d -= 360.0
	return d
