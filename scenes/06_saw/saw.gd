extends MovilPlatform

func _ready():
	super()

func _physics_process(delta):
	super(delta)
	rotation_degrees.z += delta*200
	
