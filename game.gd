extends Node2D

#TODO Colocar para limpar todos os filhos de PlayerElements assim que o jogador morrer

@onready var die_counter: Label = %DieCounter
@onready var test: TileMapLayer = $LevelElements/Test
@onready var camera_2d: Camera2D = %Camera2D

var attemp_counter: int = 1
var text: String = "Attemp"
var player_pos: Vector2

func _process(delta: float) -> void:
	camera_2d.position = player_pos.round()

func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	Events.connect("player_pos", _on_player_pos)
	die_counter.text = text + " " + str(attemp_counter)
	
func _on_player_die() -> void:
	attemp_counter += 1
	die_counter.text = text + " " + str(attemp_counter)

func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos
