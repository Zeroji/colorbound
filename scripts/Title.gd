extends Control

class_name TitleScreen

# warning-ignore:unused_argument
func button_quit(body):
    get_tree().quit()

# warning-ignore:unused_argument
func button_new_game(body):
    # warning-ignore:return_value_discarded
    get_tree().change_scene("res://scenes/levels/Showcase.tscn")
