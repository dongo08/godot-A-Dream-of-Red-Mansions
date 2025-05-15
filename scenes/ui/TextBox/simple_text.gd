extends DialogManager
class_name SimpleText
#@export var text_box:RichTextLabel
#@export var main_dialog:DialogGroup
#var dialog_index:int=0
#
#var tween:Tween
#var is_down:bool=0
#var typing_tween:Tween
#var current_group: DialogGroup
#var dialog_stack: Array[DialogGroup] = [] 
#var dialog_index_stack: Array[int] = [] 
func _ready() -> void:
	option1.pressed.connect(_on_option_1_pressed)
	option2.pressed.connect(_on_option_2_pressed)
	option3.pressed.connect(_on_option_3_pressed)
	option4.pressed.connect(_on_option_4_pressed)
	input_OK.pressed.connect(_on_input_ok_button_pressed)
	#menu.visibility_changed.connect(menu_disappear)
	#menu.restart.connect(func():queue_free())
	if up_area!=null and down_area!=null:
		if is_up:
			up_area.visible=false
			down_area.visible=true
		else:
			up_area.visible=true
			down_area.visible=false
	current_group=main_dialog
	start_dialog(main_dialog)
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#display_next_dialog()
#func start_dialog(group: DialogGroup):
	#dialog_stack.push_back(current_group)
	#dialog_index_stack.push_back(dialog_index)
	#current_group = group
	#dialog_index = 0
	#print("start:",dialog_stack)
	#display_next_dialog()
#func display_next_dialog():
	#if dialog_index>=len(main_dialog.dialog_list):
		#dialog_end.emit()
		#queue_free()
		#return
	#text_box.text=""
	#var dialog=main_dialog.dialog_list[dialog_index]
	#tween=create_tween()
	#for character in dialog.content:
		#tween.tween_callback(append_character.bind(character)).set_delay(0.03)
	#dialog_index+=1
#func append_character(character:String):
	#text_box.text+=character
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#
	#if Input.is_action_just_pressed("confirm") and !(tween and tween.is_running()):
		#display_next_dialog()
