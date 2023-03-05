extends Node2D

const ShotObj = preload("res://Shot.tscn")
const Shot2Obj = preload("res://Shot2.tscn")

var _shot_timer = 0.0
var _shot_cnt = 0

func _physics_process(delta: float) -> void:
	_shot_timer += delta
	
	var v = Vector2()
	if Input.is_action_pressed("ui_left"):
		v.x += -1
	if Input.is_action_pressed("ui_up"):
		v.y += -1
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_action_pressed("ui_down"):
		v.y += 1
	
	v = v.normalized()
	position += 300 * v * delta

	_shot_cnt += 1
	var shot_rate = _get_shot_rate()
	if _shot_cnt % shot_rate == 0:
		_shot()

func _shot() -> void:
	var cnt = Common.count_obj("shot")
	var limit = Common.get_max_shot()
	if cnt >= limit:
		return # 最大数を超えている.
	
	var deg = 90
	var spd = 1500
	var shot = _create_shot(deg, spd)

func _get_shot_rate() -> int:
	var ret = 2
	return ret

func _create_shot(deg:float, speed:float):
	var obj:Area2D = null
	if Common.is_trail():
		obj = Shot2Obj.instance()
		obj.position = position
		var v = Vector2()
		var rad = deg2rad(270 + rand_range(-45, 45))
		var spd = rand_range(100, 1000)
		v.x = cos(rad) * spd
		v.y = -sin(rad) * spd
		obj.set_velocity(v)
	else:
		obj = ShotObj.instance()
		obj.position = position
		obj.set_velocity(deg, speed)
	Common.get_layer("shot").add_child(obj)
	return obj
