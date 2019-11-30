extends Control

class_name TitleScreen

var acc: float = 0

func _ready():
    if Main.sd.has("checkpoint"):
        $Map/Buttons/Continue.position.y += 32
        $Map/Buttons/Continue/LevelName.text = "Level %s" % LL.get_display_index(Main.sd.checkpoint.level)
    else:
        $CanvasLayer/ContinueButton.visible = false
    $Map/Player.spawn()

func button_quit(body):
    if body is Player:
        Main.quit()

func button_new_game(body):
    if body is Player:
        Main.start_new()

func button_continue(body):
    if body is Player:
        Main.resume()

func button_levels(body):
    if body is Player:
        Main.levels()

func button_settings(body):
    if body is Player:
        Main.settings()

# Handlers for clickable buttons

func _on_NewGameButton_pressed():
    Main.start_new()

func _on_ContinueButton_pressed():
    Main.resume()

func _on_LevelButton_pressed():
    Main.levels()

func _on_SettingsButton_pressed():
    Main.settings()

func _on_QuitButton_pressed():
    Main.quit()

# Shader hue shifter

func _process(delta):
    acc += delta
    var hue = fmod(acc/2+sin(acc/2)/2, 1)
    $CanvasLayer/MarginContainer/VBoxContainer/CenterContainer/TextureRect.material.set_shader_param("shift", hue)
