extends CanvasLayer

var currentScore = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pickable in get_tree().get_nodes_in_group("pickable"):
		pickable.picked.connect(func (score):
			currentScore += score
			$HBoxContainer/Label.text = "x " + str(currentScore)
			)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
