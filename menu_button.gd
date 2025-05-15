extends Button

@onready var panel_container: PanelContainer = $"../PanelContainer"
@onready var check_box: CheckBox = $"../PanelContainer/VBoxContainer/HBoxContainer2/CheckBox"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fullscreen.connect(check_box_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	panel_container.visible=!panel_container.visible


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
func check_box_toggled(mode:bool):
	check_box.button_pressed=mode
