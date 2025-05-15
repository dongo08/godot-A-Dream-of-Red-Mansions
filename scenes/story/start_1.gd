extends Control
var state:int=0
@onready var label: Label = $ColorRect/CenterContainer/Label
var sexiang:float=0.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state==1:
		label.self_modulate=Color.from_hsv(sexiang,0.9,0.9)
		sexiang+=0.01
		print(sexiang,label.self_modulate)
		if sexiang>1:
			sexiang=0
	elif state==3:
		get_tree().change_scene_to_file("res://scenes/story/story_1.tscn")
	else:
		label.self_modulate=Color.from_hsv(0.01,0.9,0.9)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.double_click==false and event.pressed:
		state+=1
		print(state)
