extends Area2D

const SMOKE_OBJ = preload("res://Smoke.tscn")

@onready var _spr = $Sprite

# 移動方向.
var _deg := 0.0
# 速度.
var _speed := 0.0

# 経過時間
var _timer := 0.0

var _cnt = 0

## 速度をベクトルとして取得する.	
func get_velocity() -> Vector2:
	var v = Vector2()
	var rad = deg_to_rad(_deg)
	v.x = cos(rad) * _speed
	v.y = -sin(rad) * _speed
	return v

## 消滅する
func vanish() -> void:
	
	# 逆方向にパーティクルを発生させる.
	var v = get_velocity() * -1
	var spd = v.length()
	for i in range(4):
		var rad = atan2(-v.y, v.x)
		var deg = rad_to_deg(rad)
		deg += randf_range(-30, 30)
		var speed = spd * randf_range(0.1, 0.5)
		Common.add_particle(position, 1.0, deg, speed)
	queue_free()

func _ready() -> void:
	_spr.visible = false

## 一番近いターゲットを探す.
func _search_target():
	var target_layer = Common.get_layer("main")
	var distance:float = 999999
	var target:Node2D = null
	for obj in target_layer.get_children():
		if not obj is Enemy:
			continue
		var d = (obj.position - position).length()
		if d < distance:
			# より近いターゲット.
			target = obj
			distance = d
	
	return target	
## 速度を設定.
func set_velocity(v:Vector2) -> void:
	_deg = rad_to_deg(atan2(-v.y, v.x))
	_speed = v.length()

func _physics_process(delta: float) -> void:
	_spr.visible = true
	_timer += delta
	
	_cnt += 1
	if _cnt%2 == 0:
		if Common.is_smoke():
			# 煙発生.
			var smoke = SMOKE_OBJ.instantiate()
			smoke.position = position
			var vel = Vector2.ZERO
			if Common.is_smoke_rand():
				# 煙をランダム移動.
				var d = 45
				var rad = deg_to_rad(_deg + randf_range(180-d, 180+d))
				vel.x = 0.2 * _speed * cos(rad)
				vel.y = 0.2 *_speed * -sin(rad)
				smoke.set_velocity(vel)
			Common.get_layer("main").add_child(smoke)
	
	#_speed += 1000 * delta # 加速する.
	#if _speed > 5000:
	#	_speed = 5000 # 最高速度制限.
	
	var target = _search_target()
	if target != null:
		# 速度を更新.
		var d = target.position - position
		# 狙い撃ち角度を計算する.
		var aim = rad_to_deg(atan2(-d.y, d.x))
		var diff = Common.diff_angle(_deg, aim)
		# 旋回する.
		#_deg += diff * delta * 3 + (diff * _timer * (delta+0.5))
		_deg += diff * delta * 5
		
	# 角度に合わせてスプライトを回転.
	_spr.rotation_degrees = 180 - _deg - 90
	
	var v = get_velocity()
	
	# 移動量.
	var d = v * delta
	position += d
		
	# 画面外に出たら消す.
	if position.x < 0 or position.y < 0:
		queue_free()
	if position.x > 1024 or position.y > 600:
		queue_free()

func _on_Shot_area_entered(area: Area2D) -> void:
	# 何かに衝突したら消える.
	vanish()
	
	if area is Enemy:
		# 敵だったらヒット処理.
		area.hit(get_velocity())
