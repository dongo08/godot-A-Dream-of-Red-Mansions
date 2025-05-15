extends Node
var AL:float=0.8:
	set(value):
		AL=value
		ALchanged.emit()
		
signal ALchanged
signal fullscreen(mode:bool)
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		
		
		if DisplayServer.window_get_mode()==DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen.emit(true)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen.emit(false)
