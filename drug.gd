extends Area2D

@onready var enemy = get_tree().get_first_node_in_group("enemy")

@export var healAmount: int = 10

@export var toxicAmount: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if !body.is_in_group("player"):
		return
		
	body.currentHealth = min (body.currentHealth + healAmount, body.maxHealth)
	
	body.add_toxicity(toxicAmount)
	
	body.healthChange.emit()
	
	print("Recovered health: ", healAmount)
	print("Current health: ", body.currentHealth)
	print("Toxic amount: ", toxicAmount)
	print("Current toxic: ", body.currentToxicity)
	
	queue_free()
