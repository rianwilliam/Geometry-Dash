extends Button
class_name BackButton

## Button used to hide the current tab
##
## All tabs are displayed on top of the [MainMenu], and when this
## button is pressed, it hides the current tab, which is obtained through
## the [member tab] variable.

@export var tab: Control ## Holds the tab that should be hidden

func _ready() -> void:
	connect("pressed", _on_back_btn_pressed)

func _on_back_btn_pressed() -> void:
	tab.visible = false
