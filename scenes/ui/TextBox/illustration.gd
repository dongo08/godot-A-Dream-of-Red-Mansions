extends TextureRect
class_name Illustration
var is_appear:bool=false
var move_tween:Tween
var appear_tween:Tween
var animation_tween:Tween
var character:CharacterImageGroup.Characters
var move_position:Vector2:
	set(value):
		move_position=value
		_on_update_position()
var appear_position:Vector2:
	set(value):
		appear_position=value
		_on_update_position()
var animate_position:Vector2:
	set(value):
		animate_position=value
		_on_update_position()
signal update_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(position)
	#await get_tree().create_timer(0.5).timeout
	#animation("jump")
	#appear()

signal finished()
func lose_focus():
	modulate.v=0.5
func get_focus():
	modulate.v=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func move(x:float=move_position.x,y:float=move_position.y,trans:Tween.TransitionType=Tween.TRANS_QUAD,time:float=0.5):
	if move_tween and move_tween.is_running():
		move_tween.kill()
	move_tween=create_tween()
	move_tween.tween_property(self,"move_position",Vector2(x,y),time).set_trans(trans).set_ease(Tween.EASE_OUT)
	move_tween.tween_callback(func():finished.emit())
func appear(x:float=position.x,y:float=position.y):
	if appear_tween and appear_tween.is_running():
		appear_tween.kill()
	appear_tween=create_tween()
	var tween=create_tween()
	visible=true
	is_appear=true
	modulate.a=0
	#print(position)
	appear_position=Vector2((position.x-576)*0.1,0)
	appear_tween.tween_property(self,"appear_position",Vector2(0,0),0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",1,0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
func disappear(x:float=position.x,y:float=position.y):
	if appear_tween and appear_tween.is_running():
		appear_tween.kill()
	appear_tween=create_tween()
	var tween=create_tween()
	modulate.a=1
	#print(position)
	appear_position=Vector2(0,0)
	appear_tween.tween_property(self,"appear_position",Vector2((position.x-576)*0.1,0),0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",0,0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	appear_tween.tween_callback(func():
								visible=false
								is_appear=false
								)
func animation(type:String):
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()
	animation_tween=create_tween()
	if type=="jump":
		animation_tween.tween_property(self,"animate_position:y",-30,0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		animation_tween.tween_property(self,"animate_position:y",0,0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
func _process(delta: float) -> void:
	#print(position)
	pass


func _on_update_position() -> void:
	position=move_position+appear_position+animate_position
