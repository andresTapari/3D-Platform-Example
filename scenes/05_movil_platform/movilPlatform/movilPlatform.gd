extends AnimatableBody3D


@export var targetAPath: NodePath = ""
@export var targetBPath: NodePath = ""
@export var waitTime:       float = 2
@export var speed:          float = 5

var targetA: Marker3D = null
var targetB: Marker3D = null

var targetToMove: Marker3D = null
var tolerance: float = 2

func _ready():
	if not targetAPath.is_empty():
		targetA = get_node(targetAPath)
	if not targetBPath.is_empty():
		targetB = get_node(targetBPath)
	%Timer.wait_time = waitTime
	%Timer.start()

func _physics_process(delta):
	if not targetToMove:
		return

	if (global_position - targetToMove.global_position).length() < tolerance:
		if %Timer.is_stopped():
			%Timer.start()
		return

	var movement = (targetToMove.global_position - global_position).normalized()
	global_position += movement*speed*delta
	

func get_farest(targetA: Marker3D, targetB: Marker3D) -> Marker3D:
	if not targetA or not targetB:
		return null
	if (global_position - targetA.global_position).length() > (global_position - targetB.global_position).length():
		return targetA
	return targetB

func _on_timer_timeout():
	targetToMove = get_farest(targetA,targetB)
