tool
extends StaticBody2D

class_name Wall

const TEXTURE_SIZE:int = 32

export (CS.Colors) var color = CS.Colors.red
export var height: float = 64

func update_sprite():
    $Sprite.texture.region.position.x = TEXTURE_SIZE * CS.id(color)
    $Sprite.scale.y = height / 64
    $ColorAdd.color = color

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)
    $CollisionShape2D.shape.extents.y = height / 2

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    update_sprite()

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()
