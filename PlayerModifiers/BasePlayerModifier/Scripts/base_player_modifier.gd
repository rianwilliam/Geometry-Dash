extends Area2D
class_name PlayerModifier

## Base de modificador na gameplay do jogador
##
## O modificador recebe um o mais efeitos do tipo [enum MODIFIERS] e aplica ao 
## jogador quando o mesmo interaje com ele, sempre que uma classe que deriva dele é
## instanciada, a mesma deve determinar o valor da variável [member effect]

var effect: Dictionary[Enums.MODIFIERS, Variant]
var _type: Enums.MODIFIERS
var player_in_area: bool = false

func get_effect() -> Variant:
	assert(effect)
	return effect
	
func get_type() -> Enums.MODIFIERS:
	assert(_type)
	return _type

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = false
