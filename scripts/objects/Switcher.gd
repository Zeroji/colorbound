tool
extends Area2D

class_name Switcher

const TEXTURE_SIZE:int = 32

export (CS.Colors) var color = CS.Colors.red

func update_sprite():
    $Sprite.texture.region.position.x = TEXTURE_SIZE * CS.id(color)
    $ColorAdd.color = color

func _ready():
    if not Engine.editor_hint:
        update_sprite()

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()

func _on_Switcher_body_entered(body):
    if body is Player:
        body.color = self.color
