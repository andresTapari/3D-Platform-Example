class_name MovilPlatform extends AnimatableBody3D

## Ruta al nodo de posición inicial
@export var targetAPath: NodePath = ""
## Ruta al nodo de posición final
@export var targetBPath: NodePath = ""
## Tiempo de espera
@export var waitTime:       float = 2
## Velocidad de movimiento
@export var speed:          float = 5

var targetA: Marker3D = null		# Posición A
var targetB: Marker3D = null		# Posición A

var targetToMove: Marker3D = null	# Posición actual a donde moverse
var tolerance: float = 0.01			# Tolerancia final de movimiento

var restTimer: Timer = null

func _ready():
	# Cargamos nodos
	targetA = load_node(targetAPath)
	targetB = load_node(targetBPath)
	# Configuramos timer
	restTimer = Timer.new()
	add_child(restTimer)
	restTimer.wait_time = waitTime
	restTimer.one_shot  = true
	restTimer.autostart = true
	restTimer.timeout.connect(_on_restTimer_timeout)
	restTimer.start()

func _physics_process(delta):
	# Si targetToMove no es valido
	if not targetToMove:
		# sale
		return

	# Si estamos dentro de la tolerancia 
	if (global_position - targetToMove.global_position).length() < tolerance:
		# Y el timer esta detenido, iniciamos timer y salimos
		if restTimer.is_stopped():
			restTimer.start()
		return

	# Determinamos posicion a donde mover y desplazamos
	var movement = (targetToMove.global_position - global_position).normalized()
	global_position += movement*speed*delta

## Esta función carga el nodo
func load_node(path: NodePath) -> Object:
	# Si el path no esta vacio
	if not path.is_empty():
		# carga y devuelve el nodo
		return get_node(path)
	# Si no, emite una advertencia y retorna nulo
	push_warning("At ", self.name, ", path is empty.")
	return null

## Devuelve el nodo mas lejano
func get_farest(markerA: Marker3D, markerB: Marker3D) -> Marker3D:
	# Si los nodos no son 
	if not markerA or not markerB:
		return null
	if (global_position - markerA.global_position).length() > (global_position - markerB.global_position).length():
		return markerA
	return markerB

## Se ejecuta cuando el timer dispara
func _on_restTimer_timeout():
	# determinamos el nodo mas lejano
	targetToMove = get_farest(targetA,targetB)
