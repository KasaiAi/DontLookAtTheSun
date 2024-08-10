extends Area2D

func _on_patrol_area_body_exited(body):
	if body.is_in_group("enemy"):
		body.scale.x = -body.scale.x

func _on_patrol_area2_body_exited(body):
	if body.is_in_group("enemy"):
		body.motion.x = -body.motion.x
