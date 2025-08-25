extends Node2D

#TODO Colocar para limpar todos os filhos de PlayerElements assim que o jogador morrer

@onready var die_counter: Label = %DieCounter
@onready var test: TileMapLayer = $LevelElements/Test

var attemp_counter: int = 1
var text: String = "Attemp"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	die_counter.text = text + " " + str(attemp_counter)
	
func _on_player_die() -> void:
	attemp_counter += 1
	die_counter.text = text + " " + str(attemp_counter)
