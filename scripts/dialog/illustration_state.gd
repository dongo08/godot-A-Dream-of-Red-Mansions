extends Resource
class_name IllustrationState
@export var illustration:CharacterImageGroup.Characters
@export var emoji:int=0
@export var position:Vector2=Vector2(-1,-1)
@export var animation:String
@export var trans:Tween.TransitionType=Tween.TRANS_QUAD
@export_group("layer")
@export var is_appear:bool=true
@export var is_focus:bool=false
@export var Z_index:int=1
