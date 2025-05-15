extends RichTextEffect
var bbcode = "shake"

# 控制参数（可导出到编辑器）
@export var speed: float = 10.0
@export var strength: float = 2.0

func _process_custom_fx(char_fx):
	# 每个字符基于索引生成随机种子
	var time = char_fx.elapsed_time * speed

	# 生成随机偏移（基于字符索引和时间的正弦波）
	var angle = randf_range(0, TAU, )
	var offset = Vector2(
		cos(angle + time) * strength,
		sin(angle + time) * strength
	)

	# 应用偏移
	char_fx.offset = offset
	return true
