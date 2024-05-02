extends MovilPlatform

signal game_over

func _physics_process(delta):
	# Llamamos a la función _physics_process de la clase Padre
	super(delta)
	# Rotamos malla 
	%saw.rotation_degrees.z += delta*500

# Se ejecuta cuando un cuerpo entra en el área de detección
func _on_area_3d_body_entered(body):
	# Si body es del grupo player
	if body.is_in_group("player"):
		# emite evento de game over
		game_over.emit()

