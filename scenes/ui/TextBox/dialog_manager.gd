extends Control
class_name DialogManager
@export_group("UI")
@export var character_name_test:Label
@export var text_box:RichTextLabel
@export var left_avatar:TextureRect
@export var right_avatar:TextureRect
@export var buttons:Container
@export var option1:Button
@export var option2:Button
@export var option3:Button
@export var option4:Button
@export var up_area: Control
@export var down_area: Control
@export var input_line:LineEdit
@export var input_OK:Button
@export_group("content")
@export var main_dialog:DialogGroup
var pre_illustration=preload("res://scenes/ui/TextBox/illustration.tscn")
signal option_pressed(option:int)
signal player_input(player_input:String)
signal dialogs_end
var is_up:bool=0
var dialog_index:int=0
var typing_tween:Tween
var illustrations:Array[Illustration]
var typing_delay:float=0.02
var typing_group_delay:float=0.02
var current_group: DialogGroup
var dialog_stack: Array[DialogGroup] = [] 
var dialog_index_stack: Array[int] = [] 
var latest_player_input:String
#@onready var menu=get_node("/root/Menu") as CanvasLayer


func _ready() -> void:
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


func start_dialog(group: DialogGroup):
	dialog_stack.push_back(current_group)
	dialog_index_stack.push_back(dialog_index)
	current_group = group
	dialog_index = 0
	print("start:",dialog_stack)
	display_next_dialog()
	
func handle_choice_selected(choice_index: int):
	var current_dialog = current_group.dialog_list[dialog_index-1]
	#print(current_dialog.choices.size())
	if choice_index < current_dialog.choices.size():
		var choice = current_dialog.choices[choice_index]
		#if !choice.dialog_events.is_empty():
			#for i in choice.dialog_events:
				#DialogEvents.call_thread_safe(i)
		if !choice.dialog_self_call.is_empty() and main_dialog.origin_node:
			for i in choice.dialog_self_call:
				get_node(main_dialog.origin_node).call_thread_safe(i)
		# 条件检查（示例：使用 Expression 解析）
		if choice.target_group!=null:
			if check_condition(choice.condition):
				start_dialog(choice.target_group)
		else:
			display_next_dialog()

func check_condition(cond: String) -> bool:
	if cond.is_empty():
		return true
	
	var expression = Expression.new()
	if expression.parse(cond) == OK:
		return expression.execute([], self)
	return false
	
func display_next_dialog():
	print(dialog_stack,dialog_index_stack)
	print("dialog_index:",dialog_index)
	#print("dialog",current_group.dialog_list[dialog_index].content)
	if dialog_index>=len(current_group.dialog_list):
		end_dialog_group()
		return
	var dialog =current_group.dialog_list[dialog_index]
	
	buttons.visible=false
	option1.get_parent().visible=false
	option2.get_parent().visible=false
	option3.get_parent().visible=false
	option4.get_parent().visible=false
	input_line.get_parent().visible=false
	if typing_tween and typing_tween.is_running():
		skip(dialog)
	else:
		if main_dialog is CharactersDialogGroup and dialog is HugeImageDialog:
			main_dialog=main_dialog as CharactersDialogGroup
			dialog=dialog as HugeImageDialog
			for dialog_illustration in dialog.illustrations:
				dialog_illustration=dialog_illustration as IllustrationState
				if !main_dialog.illustrations.has(dialog_illustration.illustration):
					main_dialog.illustrations.push_back(dialog_illustration.illustration)
					var illustration=pre_illustration.instantiate() as Illustration
					illustration.move_position=dialog_illustration.position
					illustration.character=dialog_illustration.illustration
					illustration.gui_input.connect(_on_click)
					add_child(illustration)
					illustrations.push_back(illustration)
				for i in illustrations:
					i=i as Illustration
					if i.character==dialog_illustration.illustration:
						i.z_index=dialog_illustration.Z_index
						if i.position!=dialog_illustration.position:
							i.move(dialog_illustration.position.x,dialog_illustration.position.y,dialog_illustration.trans)
							pass
						if dialog_illustration.is_appear and !i.is_appear:
							i.appear()
						elif !dialog_illustration.is_appear and i.is_appear:
							i.disappear()
						if dialog_illustration.is_focus:
							i.get_focus()
						else:
							i.lose_focus()
						if dialog_illustration.animation:
							i.animation(dialog_illustration.animation)
						i.texture=CharacterImageGroup.image_group.group[dialog_illustration.illustration].image_group[dialog_illustration.emoji]
					#else:
						#i.lose_focus()
		if dialog is EventDialog and dialog.is_at_end==false:
			if !dialog.dialog_events.is_empty():
				for i in dialog.dialog_events:
					DialogEvents.call_thread_safe(i)
			if !dialog.dialog_self_call.is_empty() and main_dialog.origin_node:
				for i in dialog.dialog_self_call:
					get_node(main_dialog.origin_node).call_thread_safe(i)
			if !dialog.dialog_root_call.is_empty() and main_dialog.root_node:
				for i in dialog.dialog_root_call:
					get_node(main_dialog.root_node).call_thread_safe(i)
		if character_name_test!=null:
			if dialog.character_name==null or dialog.character_name=="":
				character_name_test.visible=false
			else:
				character_name_test.visible=true
				character_name_test.text=dialog.character_name
		
		typing_tween=create_tween()
		text_box.text=""
		if dialog.skipped:
			skip(dialog)
		else:
			for text_group in dialog.content:
				text_group=text_group as TextGroup 
				for character in text_group.text:
					typing_tween.tween_callback(append_character.bind(character,text_group.special_effect)).set_delay(dialog.typing_delay)
				typing_tween.tween_callback(func():pass).set_delay(dialog.typing_group_delay)
			typing_tween.tween_callback(dialog_end.bind(dialog))
		if left_avatar!=null and right_avatar!=null:
			if main_dialog is CharactersDialogGroup:
				left_avatar.visible=false
				right_avatar.visible=false
			else:
				if dialog.avatar==null:
					left_avatar.texture=null
					right_avatar.texture=null
				else:
					if dialog.show_on_left:
						left_avatar.texture=dialog.avatar
						right_avatar.texture=null
					else:
						left_avatar.texture=null
						right_avatar.texture=dialog.avatar

func _process(delta: float) -> void:
	#if typing_tween and typing_tween.is_running():
		#if Input.is_action_just_pressed("back") and typing_tween and typing_tween.is_running():
			#skip(current_group.dialog_list[dialog_index])
	#if Input.is_action_just_pressed("confirm"):
		#print(current_group.dialog_list[max(0,dialog_index-1)].is_branch())
		#if !(typing_tween and typing_tween.is_running()) and current_group.dialog_list[max(0,dialog_index-1)].is_branch() and !(current_group.dialog_list[max(0,dialog_index-1)] is InputDialog):
			#display_next_dialog()
	#if Input.is_action_pressed("down"):
		#text_box.get_v_scroll_bar().value+=max(1,300*delta)
	#if Input.is_action_pressed("up"):
		#text_box.get_v_scroll_bar().value-=max(1,300*delta)
		pass

func dialog_end(dialog:Dialog):
	if dialog is EventDialog and dialog.is_at_end==true:
		if !dialog.dialog_events.is_empty():
			for i in dialog.dialog_events:
				DialogEvents.call_thread_safe(i)
		if !dialog.dialog_self_call.is_empty() and main_dialog.origin_node:
			for i in dialog.dialog_self_call:
				get_node(main_dialog.origin_node).call_thread_safe(i)
		if !dialog.dialog_root_call.is_empty() and main_dialog.root_node:
			for i in dialog.dialog_root_call:
				get_node(main_dialog.root_node).call_thread_safe(i)
	if dialog is InputDialog:
		show_input(dialog)
	if !dialog.is_branch():
		show_choices(dialog.choices)
	else:
		if dialog_index >= current_group.dialog_list.size():
			
			#display_next_dialog()
			end_dialog_group()
	dialog_index+=1
	print(1)

func show_choices(choices: Array[DialogChoice]):
	buttons.visible = true
	# 重置所有按钮
	for btn in [option1, option2, option3, option4]:
		btn.get_parent().visible = false
	
	# 动态显示有效选项
	for i in range(choices.size()):
		if i >= 4: break  # 最多支持4个选项
		var btn = get("option%d" % (i+1)) as Button
		btn.text = choices[i].text
		btn.get_parent().visible = true
		btn.disabled = !check_condition(choices[i].condition)
	option1.grab_focus()

func show_input(input_dialog:InputDialog):
	if input_dialog.sub_text!=null and input_dialog.sub_text!="":
		input_line.find_child("Label").text=input_dialog.sub_text
	if input_dialog.default_input!=null and input_dialog.default_input!="":
		input_line.text=input_dialog.default_input
	input_line.get_parent().visible=true
	input_line.grab_focus()
	
	
func end_dialog_group():
	if len(dialog_stack)>1:
		dialog_index = dialog_index_stack.pop_back()
		dialog_index+=current_group.index_change
		print("restart_index:",dialog_index)
		current_group = dialog_stack.pop_back()
		
		print("dialog_end:",dialog_stack)
		display_next_dialog()
	else:
		dialogs_end.emit()
		queue_free()
	#visible=false
	#Global.can_move=true
	#Global.is_talking=false
	#queue_free()
	#return
func menu_disappear():
	if !(option1.has_focus() or option2.has_focus() or option3.has_focus() or option4.has_focus()) and buttons.visible==true :#and menu.visible==false
		option1.grab_focus()


func append_character(character:String,special_text_effect:String=""):
	#print(special_text_effect)
	if !special_text_effect:
		text_box.append_text(character)
	else:
		text_box.append_text("["+special_text_effect+"]"+character+"[/"+special_text_effect+"]")
		
func skip(dialog:Dialog)->void:
	if dialog.can_skip:
		typing_tween.kill()
		text_box.text=""
		for text_group in dialog.content:
			text_group = text_group as TextGroup
			if text_group.special_effect:
				text_box.append_text("["+text_group.special_effect+"]")
				text_box.append_text(text_group.text)
				text_box.append_text("[/"+text_group.special_effect+"]")
			else:
				text_box.append_text(text_group.text)
	#if dialog.special_effect==null or dialog.special_effect=="":
		#text_box.text=dialog.content
	#else:
		#text_box.text='['+dialog.special_effect+']'+dialog.content
		#text_box.set_text(text_box.text)
		dialog_end(dialog)

func _on_click(event: InputEvent) -> void:

	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed and current_group.is_in_gaming==false:
		if typing_tween and typing_tween.is_running():
			skip(current_group.dialog_list[dialog_index])
			return
		if current_group.dialog_list[max(0,dialog_index-1)].is_branch() and !(current_group.dialog_list[max(0,dialog_index-1)] is InputDialog):
			#if current_group.dialog_list[max(0,dialog_index-1)].is_branch():
			display_next_dialog()
			#else:
				#skip(current_group.dialog_list[dialog_index])

func _on_option_1_pressed() -> void:
	print("!!!1")
	handle_choice_selected(0)
	option_pressed.emit(0)

func _on_option_2_pressed() -> void:
	print("!!!2")
	handle_choice_selected(1)
	option_pressed.emit(1)
func _on_option_3_pressed() -> void:
	print("!!!3")
	handle_choice_selected(2)
	option_pressed.emit(2)

func _on_option_4_pressed() -> void:
	print("!!!4")
	handle_choice_selected(3)
	option_pressed.emit(3)

func _on_input_ok_button_pressed() -> void:
	print(input_line.text)
	if input_line.text!="" and input_line.text!=null:
		latest_player_input=input_line.text
		player_input.emit(input_line.text)
		current_group.dialog_list[max(0,dialog_index-1)].player_input=input_line.text
		display_next_dialog()
		
