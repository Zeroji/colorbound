extends Control

class_name TitleScreen

func _ready():
    if Main.sd.has("checkpoint"):
        $Map/Buttons/Continue.position.y += 32
        $Map/Buttons/Continue/LevelName.text = Main.sd.checkpoint.level

func button_quit(body):
    Main.quit()

func button_new_game(body):
    if body is Player:
        Main.start_new()

func button_continue(body):
    if body is Player:
        Main.resume()

func button_settings(body):
    if body is Player:
        Main.settings()

func _on_SettingsButton_pressed():
    Main.settings()

func _on_QuitButton_pressed():
    Main.quit()
