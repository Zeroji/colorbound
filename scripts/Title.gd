extends Control

class_name TitleScreen

func button_quit(body):
    get_tree().quit()

func button_new_game(body):
    get_tree().change_scene("res://scenes/levels/Showcase.tscn")
