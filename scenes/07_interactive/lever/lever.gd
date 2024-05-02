extends Node3D

signal trigger(currentState)

var isInteractiveEn: 	bool = false		# indica si el nodo esta habilitado para recibir interacciones
var currentState: 		bool = false		# estado actual del interruptor


func _ready():
	# Conectamos señales de animacion
	%AnimationPlayer.animation_finished.connect(func (anim_name):
		trigger.emit(currentState)
		)

## Entradas de usuario
func _input(event):
	if not isInteractiveEn:
		return

	if event.is_action_pressed("ui_interact"):
		currentState = !currentState
		if currentState:
			%AnimationPlayer.play("turn_on")
		else:
			%AnimationPlayer.play("turn_off")

## Difumina en pantalla un mensaje de interacción
func fade(targetNode, waitTime: float = 1.0 ,fadeIn: bool = true) -> void:
	var modulateWhite: Color = Color.WHITE if fadeIn else Color(1,1,1,0)
	var modulateBlack: Color = Color.BLACK if fadeIn else Color(0,0,0,0)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(targetNode,"modulate",modulateWhite,waitTime)
	tween.set_parallel()
	tween.tween_property(targetNode,"outline_modulate",modulateBlack,waitTime)

## Se ejecuta cuando player entra en la zona de detección
func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		isInteractiveEn = true
		# Mostramos label en pantalla
		fade(%Label3D, 1.0, true)

func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		isInteractiveEn = false
		# Mostramos label en pantalla
		fade(%Label3D, 1.0, false)
