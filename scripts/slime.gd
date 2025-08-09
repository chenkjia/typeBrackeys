extends Node2D

const SPEED = 30

var direction = 1
var word_to_type = ""
var typed_chars = 0

# 英文单词库
var word_list = ["cat", "dog", "run", "jump", "fire", "water", "tree", "house", "book", "game", 
				 "love", "time", "world", "light", "music", "dream", "happy", "quick", "brave", "magic"]

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var word_label: RichTextLabel = $WordLabel

func _ready() -> void:
	# 随机选择一个单词
	word_to_type = word_list[randi() % word_list.size()]
	update_word_display()
	# 注册到游戏管理器
	var game_manager = get_node("/root/Game/GameManager")
	if game_manager:
		game_manager.register_slime(self)

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += SPEED * direction * delta

func handle_input(key_char: String) -> void:
	if typed_chars < word_to_type.length():
		if key_char == word_to_type[typed_chars]:
			typed_chars += 1
			update_word_display()
			if typed_chars >= word_to_type.length():
				# 单词输入完成，添加分数并消失
				var game_manager = get_node("/root/Game/GameManager")
				if game_manager:
					game_manager.add_point()
					game_manager.unregister_slime(self)
				queue_free()

func _exit_tree() -> void:
	# 确保在销毁时注销
	var game_manager = get_node("/root/Game/GameManager")
	if game_manager:
		game_manager.unregister_slime(self)

func update_word_display() -> void:
	var display_text = ""
	for i in range(word_to_type.length()):
		if i < typed_chars:
			# 已输入的字母显示为绿色
			display_text += "[color=green]" + word_to_type[i] + "[/color]"
		else:
			# 未输入的字母显示为白色
			display_text += "[color=white]" + word_to_type[i] + "[/color]"
	word_label.text = display_text
