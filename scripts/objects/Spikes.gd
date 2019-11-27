tool
extends Area2D

class_name Spikes

const TEXTURE_SIZE:int = 32
const TEXTURE_X = 8
var acc = 0

export (CS.Colors) var color = CS.Colors.red

func update_sprite():
    $Sprite.texture.region.position.y = TEXTURE_SIZE * CS.id(color)
    $ColorAdd.color = color

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    update_sprite()

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()
    if not Engine.editor_hint:
        acc += delta
        var pos = int(2.5 * sin(acc*20))
        $Sprite.texture.region.position.x = TEXTURE_X + pos

func _on_Spikes_body_entered(body):
    if body is Player:
        body.kill()
