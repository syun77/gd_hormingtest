extends Sprite2D

const MAX_TIMER = 0.5
const MAX_FRAME = 4

var _timer = 0.0
var _velocity = Vector2.ZERO

func set_velocity(vel:Vector2) -> void:
	_velocity = vel

func _ready() -> void:
	rotation_degrees = randf_range(0, 360)

func _physics_process(delta: float) -> void:
	_timer += delta
	
	_velocity *= 0.95
	position += _velocity * delta
	
	var rate = _timer/MAX_TIMER
	modulate.a = 0.5 * (1.0 - rate)
	var idx = int(MAX_FRAME * (rate))
	frame = idx
	
	if _timer >= MAX_TIMER:
		queue_free()
	
