tool
extends Area2D

signal activated

class_name Checkpoint

const TEXTURE_SIZE:int = 32

export (CS.Colors) var color = CS.Colors.white setget set_color

func set_color(col):
    if not Engine.editor_hint:
        $Sprite.visible = false
    color = col
    update_sprite()
    if not Engine.editor_hint:
        $Sprite.visible = true

func update_sprite():
    $Sprite.texture.region.position.x = TEXTURE_SIZE * CS.id(color)
    $ColorAdd.color = color

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)
    if color == CS.Colors.white:
        for bit in range(11, 18):
            set_collision_mask_bit(bit, true)

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    update_sprite()

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()

func _on_Checkpoint_body_entered(body):
    if body is Player:
        if self.color != body.color:
            $CheckSound.play()
        self.color = body.color
        emit_signal("activated")
