tool
extends PhysicsBody2D

class_name Platform

export (CS.Colors) var color = CS.Colors.red
export var length = 64
const HEIGHT = 8

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)

func update_platform_length():
    # Update hitbox size
    $Hitbox.shape.extents.x = length/2
    $Hitbox.one_way_collision = true
    # Update sprite color and size
    $ColorAdd.color = color
    $NinePatch.region_rect.position.y = CS.id(color) * 8
    $NinePatch.rect_size = Vector2(length, HEIGHT)
    $NinePatch.rect_position = $NinePatch.rect_size / -2

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
        update_platform_length()

# warning-ignore:unused_argument
func _process(delta):
    $Label.text = CS.name(color)
    if Engine.editor_hint:
        update_platform_length()
