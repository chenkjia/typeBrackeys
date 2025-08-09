extends Area2D

const SPEED = 300
var direction = Vector2.RIGHT
var target_slime = null

func _ready() -> void:
	# 设置火球朝向目标
	if target_slime and is_instance_valid(target_slime):
		direction = (target_slime.global_position - global_position).normalized()
	# 3秒后自动销毁
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func _process(delta: float) -> void:
	position += direction * SPEED * delta

func set_target(slime) -> void:
	target_slime = slime

func _on_body_entered(body) -> void:
	if body == target_slime:
		# 击中目标怪物
		body.destroy_by_fireball()
		queue_free()

func _on_area_entered(area) -> void:
	# 检查是否击中目标怪物的区域
	if area.get_parent() == target_slime:
		target_slime.destroy_by_fireball()
		queue_free()

func _on_timeout() -> void:
	queue_free()
