extends Node3D

## Nodo del jugador a seguir
@export var target: NodePath = ""
## Velocidad de respuesta
@export var speed: float = 5.0
## Velocidad de rotacion
@export var rotationSpeed: float = 5
## Habilitar camara siempre mirar al jugador
@export var lookAtTargetEn: bool = false
## Angulo minimo de rotación azimut
@export var azimutMinDegrees: float = -25
## Angulo máximo de rotación azimut
@export var azimutMaxDegrees: float = 25


# Nodos:
var player: CharacterBody3D = null

# Variables:
var currentPosition = Vector3()
var targetPosition  = Vector3()

func _ready():
	# Inicializamos la posición actual del nodo en su posicion global
	currentPosition = global_position
	
	# Cargamos el nodo target a la variable player
	if not target.is_empty():
		player = get_node(target)

func _process(delta):
	# Si player no esta definido, no hace nada
	if not player:
		return
	
	# Si habilitamos siempre ver al jugador
	if lookAtTargetEn:
		# Apuntamos con camara a player
		%Camera3D.look_at(player.global_position)
	
	# Tomamos entrada de rotacion de camara
	handle_input(delta)
	
	# Obtenemos la posición global de player
	targetPosition = player.global_position
	
	# Calcular la nueva posición del nodo basada en la velocidad de seguimiento
	currentPosition = currentPosition.lerp(targetPosition, speed * delta)

	# Actualizar la posición del nodo
	global_position = currentPosition

func handle_input(delta):
	# Obtenemos la rotación actual de la camara
	var currentRotation = %Gizmo.rotation_degrees
	
	# Obtenemos las entradas de telcado
	var cameraInput: Vector3 = Vector3.ZERO
	cameraInput.y = Input.get_action_strength("ui_camera_right") - Input.get_action_strength("ui_camera_left")
	cameraInput.x = Input.get_action_strength("ui_camera_down") - Input.get_action_strength("ui_camera_up")

	# Rotamos la cámara
	currentRotation += cameraInput * rotationSpeed
	currentRotation.x = limit(currentRotation.x, azimutMinDegrees, azimutMaxDegrees)  # Limitamos la rotación entre 10º y 80º

	# Rotamos cámara
	%Gizmo.rotation_degrees = currentRotation

## Limita value entre minValue y maxValue. 
func limit(value: float, minValue: float, maxValue: float) -> float:
	if value >= minValue and value <= maxValue:
		return value
	elif value > maxValue:
		return maxValue
	return minValue

## Devuelve el nodo gizmo
func get_gizmo():
	return %Gizmo
