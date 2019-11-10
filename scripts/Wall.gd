tool
extends StaticBody2D

class_name Wall

export (CS.Colors) var color = CS.Colors.red

func update_collision_bits():
    # Update layer/mask bits
    var collision_bit = CS.bit(color)
    set_collision_layer_bit(collision_bit, true)
    set_collision_mask_bit(collision_bit, true)
"""
func update_platform_length():
    # Update hitbox size
    $Hitbox.shape.extents.x = length/2
    $Hitbox.one_way_collision = true
    # Update sprite color and size
    $NinePatch.region_rect.position.y = CS.id(color) * 8
    $NinePatch.rect_size = Vector2(length, HEIGHT)
    $NinePatch.rect_position = $NinePatch.rect_size / -2
"""
func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    $ColorAdd.color = color

#func _process(delta):
    #$Label.text = CS.name(color)
    #if Engine.editor_hint:
     #   update_platform_length()
