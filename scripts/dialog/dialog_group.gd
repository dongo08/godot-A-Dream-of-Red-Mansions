extends Resource
class_name DialogGroup
@export var dialog_list:Array[Dialog]
@export var is_in_gaming:bool
@export var can_move:bool
@export var times:int=1
@export var have_played:bool=false
@export var id:String
@export var index_change:int=0
var origin_node:NodePath
var root_node:NodePath
