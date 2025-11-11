extends Node

## Holds the completion states of the levels
##
##

var level_one_complete: bool = false ## Completion state of level 1
var level_two_complete: bool = false ## Completion state of level 2
var level_three_complete: bool = false ## Completion state of level 3

## Responsible for changing the completion state of a level [br]
## The parameter [param level] defines which level was completed and updates the corresponding variable
func level_completed(level: Enums.LEVELSNUMBER) -> void:
	match level:
		Enums.LEVELSNUMBER.LEVEL_ONE: level_one_complete = true
		Enums.LEVELSNUMBER.LEVEL_TWO: level_two_complete = true
		Enums.LEVELSNUMBER.LEVEL_THREE: level_three_complete = true
