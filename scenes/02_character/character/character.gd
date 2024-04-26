extends CharacterBody3D

# Variables de exportación:
## Ruta de la camara en el nivel
@export var cameraNodePath: NodePath = ""
## Fuerza de salto
@export var jump_strength = 200

# Nodos:
var camera: Node3D = null

# Variables
var speed = 3.0  				# Velocidad de movimiento
var gravityForce = -9.8  		# Gravedad
var rotationDirection: float	
var gravity: float
var stateMachine
var wasFalling: bool			# Bandera que estaba en el aire

func _ready():
	# Obtenemos nodo de la cámara
	if not cameraNodePath.is_empty():
		camera = get_node(cameraNodePath).get_gizmo()
	stateMachine = %AnimationTree["parameters/playback"]
	
func _physics_process(delta):
	if not camera:
		return
	
	if not is_on_floor():
		gravity = gravityForce
	else:
		gravity = 0
		if wasFalling:
			wasFalling = false
			%character2/root.scale = Vector3(1.5, 0.5, 1.5)
			
	# Reestablece la escala del la mappa
	%character2/root.scale = %character2/root.scale.lerp(Vector3(1,1,1),10*delta)

	# Obtener la input del jugador
	var movement = Vector3()
	
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	movement = movement.rotated(Vector3.UP, camera.rotation.y).normalized()
	movement = movement.normalized()  # Normalizar el vector de movimiento
	
	if Input.is_action_just_pressed("ui_jump"):
		wasFalling = true
		%character2/root.scale = Vector3(0.5, 1.5, 0.5)
		gravity = jump_strength

	# Mover el personaje en función de la entrada del jugador y la velocidad
	
	velocity.x = movement.x * speed
	velocity.z = movement.z * speed

	# Aplicar gravedad
	velocity.y += gravity * delta

	# Rotacion
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotationDirection = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotationDirection, delta * 10)

	if is_on_floor():
		if movement.length() != 0:
			stateMachine.travel("walk")
		else:
			stateMachine.travel("idle")
	else:
		stateMachine.travel("jump")
	
	# Aplicar movimiento
	move_and_slide()

