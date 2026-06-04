extends ProgressBar

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	max_value = player.maxHealth

func _process(_delta):
	value = player.currentHealth
