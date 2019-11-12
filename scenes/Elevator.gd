tool
extends Node2D

signal activated
signal finished

export (CS.Colors) var color = CS.Colors.red
var opened: bool = false
var hit_left: bool = false
var hit_right: bool = false
var activated: bool = false
const TEXTURE_SIZE: int = 64

func update_collision_bits():
    var color_bit = CS.layer(color)
    $Approach.set_collision_layer_bit(color_bit, true)
    $Approach.set_collision_mask_bit(color_bit, true)

func update_sprite():
    $DoorLeft.texture.region.position.x = CS.id(color) * TEXTURE_SIZE
    $DoorRight.texture.region.position.x = CS.id(color) * TEXTURE_SIZE

func _ready():
    if not Engine.editor_hint:
        update_sprite()
        update_collision_bits()

func check_status():
    if opened and hit_left and hit_right:
        activated = true
        emit_signal("activated", self)
        $DoorLeft.z_index += 2
        $DoorRight.z_index += 2
        $Animation.play_backwards("open")

func _on_Animation_animation_finished(anim_name):
    if anim_name == "open" and activated:
        emit_signal("finished")

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()

func _on_Approach_body_entered(body):
    if body is Player and not opened:
        opened = true
        var pos = 0
        if $Animation.is_playing():
            pos = 1 - $Animation.current_animation_position / $Animation.current_animation_length
        $Animation.play("open")
        $Animation.seek(pos * $Animation.current_animation_length)

func _on_Approach_body_exited(body):
    if body is Player and opened:
        opened = false
        var pos = 0
        if $Animation.is_playing():
            pos = 1 - $Animation.current_animation_position / $Animation.current_animation_length
        $Animation.play("shut")
        $Animation.seek(pos * $Animation.current_animation_length)

func _on_HitboxLeft_body_entered(body):
    if body is Player:
        hit_left = true
        check_status()

func _on_HitboxLeft_body_exited(body):
    if body is Player:
        hit_left = false

func _on_HitboxRight_body_entered(body):
    if body is Player:
        hit_right = true
        check_status()

func _on_HitboxRight_body_exited(body):
    if body is Player:
        hit_right = false

