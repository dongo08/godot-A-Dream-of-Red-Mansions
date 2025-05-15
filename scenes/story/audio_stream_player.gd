extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db=linear_to_db(Global.AL)
	Global.ALchanged.connect(func():volume_db=linear_to_db(Global.AL))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
