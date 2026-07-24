extends RichTextLabel

# should use a monospace font

@export var timer: Timer
	
func _ready() -> void:
	update_text(timer.wait_time)

func _process(_delta: float) -> void:
	if timer.is_stopped():
		return
		
	update_text(timer.time_left)

func update_text(new_time: float) -> void:
	text = "[shake rate=10 level=1]%10.2fs" % new_time
