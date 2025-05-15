extends Control

@onready var text_box: DialogManager = $TextBox
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await text_box.dialogs_end
	color_rect.modulate=Color(1,1,1,0)
	color_rect.visible=true
	var tween=create_tween()
	tween.tween_property(color_rect,"modulate:a",1,1)
	tween.tween_callback(func():get_tree().quit())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
