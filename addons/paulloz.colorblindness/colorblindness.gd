tool
class_name Colorblindness
extends Node

enum TYPE { None, Protanopia, Deuteranopia, Tritanopia, Achromatopsia }

export(TYPE) onready var Type = TYPE.None setget set_type

var rect = ColorRect.new()

func set_type(value):
    if rect.material:
        rect.material.set_shader_param("type", value)
        Type = value

func _ready():
    self.add_child(rect)
    rect.rect_min_size = rect.get_viewport_rect().size
    rect.material = load("res://addons/paulloz.colorblindness/colorblindness.material")

const names = ["", "Protanopia", "Deuteranopia", "Tritanopia", "Achromatopsia"]

# Added input handler to change colorblindness mode at runtime
# Added label to show colorblindness name at truntime
func _input(event):
    if event.is_action_pressed("colorblind_switch"):
        set_type((Type + 1) % len(TYPE))
        if not Type:
            $ColorLabel.text = ""
        else:
            $ColorLabel.text = "Colorblindness mode:\n%s" % names[Type]
