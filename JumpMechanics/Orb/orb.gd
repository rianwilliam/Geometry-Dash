extends Area2D
class_name Orb

#TODO Orbe amarela: pulo normal
# Orbe rosa: pulo pequeno
# Orbe azul: inverte a gravidade (Precisa clicar)

func _on_body_entered(body: Player) -> void:
	if not body is Player: return
	body.is_on_orb = true

func _on_body_exited(body: Player) -> void:
	if not body is Player: return
	body.is_on_orb = false
