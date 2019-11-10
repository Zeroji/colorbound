tool
extends Area2D

class_name XButton

signal button_on
signal button_off

export (CS.Colors) var color = CS.Colors.yellow
var state: bool = false

func update_collision_bits():
    # Update layer/mask bits
    var collision_bit = CS.bit(color)
    set_collision_layer_bit(collision_bit, true)
    set_collision_mask_bit(collision_bit, true)

func _ready():
    if not Engine.editor_hint:
        update_collision_bits()
    $ColorAdd.color = color

func _on_Button_body_entered(body):
    if body is Player:
        if not state:
            state = true
            emit_signal("button_on")
        $OffTimer.stop()

func _on_Button_body_exited(body):
    if body is Player and state:
        $OffTimer.start()

func _on_OffTimer_timeout():
    if state:
        state = false
        emit_signal("button_off")
