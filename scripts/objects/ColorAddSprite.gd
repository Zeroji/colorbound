tool
extends Sprite

const SIZE: int = 16
enum Style { Centered, Horizontal, Vertical }

export (CS.Colors) var color = CS.Colors.white setget set_color
export (Style) var style = Style.Centered

func update_sprite():
    texture.region.position = Vector2(CS.id(color) * SIZE, style * SIZE)

func set_color(col):
    color = col
    var was_visible = visible
    visible = false
    update_sprite()
    visible = was_visible

func _ready():
    if not Engine.editor_hint:
        visible = Main.sd.settings.colorblind
        update_sprite()
    # Compensate for external rotations
    rotate(-get_global_transform_with_canvas().get_rotation())

# warning-ignore:unused_argument
func _process(delta):
    if Engine.editor_hint:
        update_sprite()

func _input(event):
    if event.is_action_pressed("colorblind_mode"):
        visible = not visible