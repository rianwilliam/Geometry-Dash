extends Area2D
class_name PlayerModifier

## Base class for gameplay modifiers of the player
##
## The modifier receives one or more effects of type [enum MODIFIERS] and applies them to 
## the player when they interact with it. Whenever a class that inherits from it is
## instantiated, it must set the value of the [member effect] variable.

## Aqui é determinado os efeitos que o modificador vai possuir
## Ele deve receber como [code]key[/code] do dicionário um valor de
## [enum Enums.MODIFIERS] e no [code]value[/code] da chave ele vai receber
## O modificador correspondente a [code]key[/code]
## Exemplo da estrutura abaixo:
## [codeblock]
## effect = {
##	Enums.MODIFIERS.JUMP: Enums.JUMPS.SMALL,
## 	Enums.MODIFIERS.GRAVITY: Enums.GRAVITY_DIR.FLIP
## }
## [/codeblock]
var effect: Dictionary[Enums.MODIFIERS, Variant]
var player_in_area: bool = false

## Obtém o [member effect]
func get_effect() -> Variant:
	assert(effect)
	return effect

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	if body is not Player: return
	player_in_area = false
