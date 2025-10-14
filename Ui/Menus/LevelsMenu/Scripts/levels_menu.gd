extends Control
class_name LevelsMenu

## Aba responsável pela seleção de níveis
##
##

@onready var lvl_1_btn: Button = %Lvl1Btn ## Botão responsável por mudar para a cena do nível 1 
@onready var lvl_2_btn: Button = %Lvl2Btn ## Botão responsável por mudar para a cena do nível 2
@onready var lvl_3_btn: Button = %Lvl3Btn ## Botão responsável por mudar para a cena do nível 3

func _ready() -> void:
	_connect_events()

## Conecta os eventos de clique dos botões
func _connect_events() -> void:
	lvl_1_btn.connect("pressed", _on_lvl_1_btn_pressed)
	lvl_2_btn.connect("pressed", _on_lvl_2_btn_pressed)
	lvl_3_btn.connect("pressed", _on_lvl_3_btn_pressed)

func _on_lvl_1_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_ONE)

func _on_lvl_2_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_TWO)

func _on_lvl_3_btn_pressed() -> void:
	SceneChanger.change_scene(Enums.SCENES.LEVEL_THREE)
