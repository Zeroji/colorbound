tool
extends StaticBody2D

class_name Wall

const TEXTURE_SIZE:int = 32

export (CS.Colors) var color = CS.Colors.red

func update_sprite():
    $Sprite.texture.region.position.x = TEXTURE_SIZE * CS.id(color)
    $ColorAdd.color = color

func update_collision_bits():
    # Update layer/mask bits
    for collision_bit in CS.bits(color):
        set_collision_layer_bit(collision_bit, true)
        set_collision_mask_bit(collision_bit, true)

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    update_sprite()

func _process(delta):
    if Engine.editor_hint:
        update_sprite()
