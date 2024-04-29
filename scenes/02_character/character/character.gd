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
	# Obtenemos maquina de estados
	stateMachine = %AnimationTree["parameters/playback"]
	
func _physics_process(delta):
	# Si la camara no esta establecida
	if not camera:
		# Sale
		return
	
	# Si no esta en el suelo
	if not is_on_floor():
		# Aplica gravedad
		gravity = gravityForce
	else:
		# Si no esta en suelo 
		gravity = 0
		# Si esta aterrizando
		if wasFalling:
			wasFalling = false
			%character2/root.scale = Vector3(1.5, 0.5, 1.5)
			
	# Reestablece la escala del la malla
	%character2/root.scale = %character2/root.scale.lerp(Vector3(1,1,1),10*delta)

	# Obtener la input del jugador
	var movement = get_player_input()
	
	# Obtener el salto del jugador	
	if Input.is_action_just_pressed("ui_jump"):
		handle_jump()

	# Mover el personaje en función de la entrada del jugador y la velocidad
	velocity.x = movement.x * speed
	velocity.z = movement.z * speed

	# Aplicar gravedad
	velocity.y += gravity * delta

	# Aplicamos rotacion
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotationDirection = Vector2(velocity.z, velocity.x).angle()
	
	rotation.y = lerp_angle(rotation.y, rotationDirection, delta * 10)

	# actualizamos animaciones del personaje:
	update_animation(movement)

	# Aplicar movimiento
	move_and_slide()

func get_player_input() -> Vector3:
	var movement = Vector3()
	
	# Obtenemos entradas de teclado o joystick
	movement.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Aplicamos rotación de la cámara
	movement = movement.rotated(Vector3.UP, camera.rotation.y).normalized()

	return movement.normalized()  # Normalizar el vector de movimiento

func handle_jump() -> void:
	wasFalling = true
	%character2/root.scale = Vector3(0.5, 1.5, 0.5)
	gravity = jump_strength
	
func update_animation(movement: Vector3) -> void:
	# Si el personaje esta en el suelo
	if is_on_floor():
		if movement.length() != 0:
			stateMachine.travel("walk")
		else:
			stateMachine.travel("idle")
	# Si esta en el aire
	else:
		stateMachine.travel("jump")
