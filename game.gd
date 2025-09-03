extends Node2D

#TODO Colocar para limpar todos os filhos de PlayerElements assim que o jogador morrer

@onready var die_counter: Label = %DieCounter
@onready var test: TileMapLayer = $LevelElements/Test
@onready var camera_2d: Camera2D = %Camera

var attemp_counter: int = 1
var attemp_text: String = "Attemp"
var player_pos: Vector2

func _process(delta: float) -> void:
	camera_2d.position = player_pos.round()

func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	Events.connect("player_pos", _on_player_pos)
	_refresh_attemp_text()
	
func _on_player_die() -> void:
	attemp_counter += 1
	_refresh_attemp_text()

func _refresh_attemp_text() -> void:
	die_counter.text = attemp_text + " " + str(attemp_counter)

func _on_player_pos(pos: Vector2) -> void:
	player_pos = pos
