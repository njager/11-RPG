extends MeshInstance

onready var DialogueCast = get_node("DialogueCast")

func _physics_process(delta):
	if DialogueCast.is_colliding():
		if DialogueCast.get_collider().has_method("dialogue"):
			DialogueCast.get_collider().dialogue()

