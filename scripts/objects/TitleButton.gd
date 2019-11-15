tool
extends Area2D

export var text: String = "button"
export var width: int = 160
const border: int = 4

func update():
    $Label.text = text
    $Border.margin_left = -width/2.0
    $Border.margin_right = width/2.0
    $Background.margin_left = -width/2.0 + border
    $Background.margin_right = width/2.0 - border

func _ready():
    update()
    $Hitbox.shape.extents.x = width/2.0

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update()
