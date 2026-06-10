extends ProgressBar

@onready var player = get_tree().get_first_node_in_group("player")
@onready var Toxic = get_parent()

func _ready():
	max_value = player.maxToxicity
	Toxic.visible = false

func _process(_delta):
	value = player.currentToxicity
	Toxic.visible = player.currentToxicity > 0
