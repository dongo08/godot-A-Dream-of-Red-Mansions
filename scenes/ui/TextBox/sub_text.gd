extends Label


func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	if toggled_on:
		visible=false
	if !toggled_on and get_parent().text=="":
		visible=true
