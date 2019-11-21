tool
extends Platform

export var seconds: float = 2
var acc: float = PI # Initialized so cos(acc) starts at -1

func _physics_process(delta):
    if Engine.editor_hint:
        return
    acc += delta / seconds * PI * 2.0
    acc = fmod(acc, PI * 2.0)
    var pos = (cos(acc)+1)/2 # Map cos [-1, 1] to [0, 1]
    $Path/Follow.unit_offset = max(0.001, min(0.999, pos))
    transform.origin = $Path/Follow.position

func _draw():
    if not Engine.editor_hint:
        return
    var half = Vector2(length/2, 0)
    var count = $Path.curve.get_point_count()
    for i in range(count):
        var pos = $Path.curve.get_point_position(i)
        draw_line(pos - half, pos + half, CS.col(color), 2 if i==0 or i==count-1 else 1)