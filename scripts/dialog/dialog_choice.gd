extends Resource
class_name DialogChoice

@export var text: String  # 选项显示文本
@export var target_group: DialogGroup  # 选择后跳转的对话组
@export var condition: String  # 条件表达式（可选，如 "global.coins > 10"）
@export var dialog_events:Array[String]
@export var dialog_self_call:Array[String]
