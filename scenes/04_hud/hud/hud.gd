extends CanvasLayer

# Puntaje actual
var currentScore = 0

func _ready() -> void:
	# Conectamos señales de los nodos recolectables
	for pickable in get_tree().get_nodes_in_group("pickable"):
		pickable.picked.connect(func (score):
			currentScore += score
			$HBoxContainer/Label.text = "x " + str(currentScore)
			)
