tool
extends Area2D

class_name XButton

const TEXTURE_SIZE:int = 16

signal button_on
signal button_off

export (CS.Colors) var color = CS.Colors.yellow
export (float) var wait_time = 0.5
var state: bool = false

func update_collision_bits():
    # Update layer/mask bits
    set_collision_layer_bit(CS.layer(color), true)
    for mask_bit in CS.mask(color):
        set_collision_mask_bit(mask_bit, true)

func update_color():
    $ColorAdd.color = color
    $Sprite.texture.region.position.x = CS.id(color) * TEXTURE_SIZE
    

func _ready():
    update_color()
    if not Engine.editor_hint:
        update_collision_bits()
        $OffTimer.wait_time = wait_time

func _process(delta):
    if Engine.editor_hint:
        update_color()

func _on_Button_body_entered(body):
    if body is Player:
        if not state:
            state = true
            emit_signal("button_on")
        $OffTimer.stop()
        var seek = 0
        if $Anim.is_playing():
            seek = 1 - $Anim.current_animation_position / $Anim.current_animation_length
            $Anim.stop()
        $Anim.playback_speed = 1
        $Anim.play("push")
        $Anim.seek(seek)

func _on_Button_body_exited(body):
    if body is Player and state:
        $Anim.playback_speed = 1 / $OffTimer.wait_time
        $Anim.play("release")
        $OffTimer.start()

func _on_OffTimer_timeout():
    if state:
        state = false
        emit_signal("button_off")
