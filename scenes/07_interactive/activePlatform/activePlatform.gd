extends MovilPlatform

@export var triggerNode: NodePath = ""

func _ready():
	super()
	if not triggerNode.is_empty():
		get_node(triggerNode).trigger.connect(_handle_trigger_event)
	isEnable = false

## 
func _handle_trigger_event(turn_state: bool) -> void:
	isEnable = turn_state

