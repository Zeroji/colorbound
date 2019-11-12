tool
extends Node2D

export (CS.Colors) var color = CS.Colors.white

func _ready():
    if not Engine.editor_hint:
        $Rect.visible = false

#ignore_warning:unused_parameter
func _process(delta):
    if Engine.editor_hint:
        $Rect.color = CS.col(color)
