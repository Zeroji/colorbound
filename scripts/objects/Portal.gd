tool
extends Area2D

class_name Portal

signal discombobulated

const TEXTURE_SIZE_FRAME:int = 96
const TEXTURE_SIZE_ANIM = 16

export (CS.Colors) var color = CS.Colors.red
var g_rotation: float

func update_sprite():
    $Background.texture.region.position.x = TEXTURE_SIZE_FRAME * CS.id(color)
    $Middle.texture.region.position.y = TEXTURE_SIZE_ANIM * CS.id(color)
    $ColorAdd.color = color

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    $Blocking.set_collision_layer_bit(CS.layer(color), false)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)
        $Blocking.set_collision_mask_bit(mask_bit, false)
    if color == CS.Colors.white:
        for bit in range(11, 18):
            set_collision_mask_bit(bit, true)
            $Blocking.set_collision_mask_bit(bit, false)

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    update_sprite()
    $Middle/AnimationPlayer.play("anim")
    g_rotation = get_global_transform_with_canvas().get_rotation()
    if abs(fmod(g_rotation, PI)) > 0.1 and PI - abs(fmod(g_rotation, PI)) > 0.1:
        $Background/ColorRect.margin_bottom = 24

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()

var sent_player = null
var sent_velocity = null

func _on_Portal_body_entered(body):
    if body is Player and body.alive:
        sent_player = body
        sent_velocity = body.actual_velocity
        body.immobilize()
        body.visible = false
        $InSound.play()

func _on_InSound_finished():        
    emit_signal("discombobulated", g_rotation, sent_player, sent_velocity)

func recombobulate(entry_rot, player, velocity):
    $OutSound.play()
    var rot = PI + entry_rot + g_rotation
    player.mobile = true
    player.visible = true
    player.position = position
    player.velocity = velocity.rotated(rot)
    player.target_velx = player.velocity.x

