extends Area2D

onready var _spr = $Sprite
onready var _line = $Line2D

var _velocity = Vector2()

var _spr_list = []

func vanish() -> void:
	# 逆方向にパーティクルを発生させる.
	var v = _velocity * -1
	var spd = v.length()
	for i in range(4):
		var rad = atan2(-v.y, v.x)
		var deg = rad2deg(rad)
		deg += rand_range(-30, 30)
		var speed = spd * rand_range(0.1, 0.5)
		Common.add_particle(position, 1.0, deg, speed)
	queue_free()

func _ready() -> void:
	for i in range(8):
		var rate = 1.0 - ((i+1) / 8.0)
		var spr:Sprite = get_node("./Sprite%d"%i)
		spr.texture = _spr.texture
		if Common.is_trail():
			spr.scale.x = rate
			spr.scale.y = rate
		spr.modulate.a = rate
		_spr_list.append(spr)
		

func set_velocity(deg:float, speed:float) -> void:
	var rad = deg2rad(deg)
	_velocity.x = cos(rad) * speed
	_velocity.y = -sin(rad) * speed

func _physics_process(delta: float) -> void:
	var d = _velocity * delta
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
		area.hit(_velocity)
