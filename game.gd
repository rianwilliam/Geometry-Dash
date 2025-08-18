extends Node2D

@onready var die_counter: Label = %DieCounter
@onready var wave_trial: Line2D = %WaveTrial

var death_counter: int = 1
var text: String = "Attemp"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("player_died", _on_player_die)
	die_counter.text = text + " " + str(death_counter)
	
func _on_player_die() -> void:
	wave_trial.clear_points()
	death_counter += 1
	die_counter.text = text + " " + str(death_counter)
