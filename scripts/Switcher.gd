tool
extends Area2D

export (CS.Colors) var state = CS.Colors.red

func update_animation_state():
    $Sprite.animation = CS.name(state)

func _ready():
    if not Engine.editor_hint:
        update_animation_state()

func _process(delta):
    if Engine.editor_hint:
        update_animation_state()

func _on_Switcher_body_entered(body):
    if body is Player:
        body.set_color(state)
