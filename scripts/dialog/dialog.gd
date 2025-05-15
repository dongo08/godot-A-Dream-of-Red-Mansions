extends Resource
class_name Dialog

@export var character_name:String
@export var content:Array[TextGroup]
@export var choices: Array[DialogChoice] = []
@export_group("avatar")
@export var avatar:Texture
@export var show_on_left:bool
var text:String
@export_group("skip")
@export var can_skip:bool=1
@export var skipped:bool=0
@export_group("delay")
@export var typing_delay:float=0.03
@export var typing_group_delay:float=0.03
func is_branch() -> bool:
	return choices.is_empty()
func _init() -> void:
	for i in content:
		text+=i.text
