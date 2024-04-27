extends Node3D

signal picked(score)

@export var score: int = 1

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		emit_signal("picked",score)
		queue_free()
