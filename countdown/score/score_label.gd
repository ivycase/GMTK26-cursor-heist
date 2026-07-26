extends RichTextLabel

func _ready() -> void:
	Global.update_score.connect(update_text)
	await get_tree().physics_frame
	update_text(0, Global.active_quota.current_score)
	
func update_text(_old_score: int, new_score: int) -> void:
	text = "[wave amp=1]$%s" % new_score
