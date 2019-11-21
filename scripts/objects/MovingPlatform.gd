tool
extends Platform

export var seconds: float = 2
export var loop: bool = true
export var initial_pi: float = 0
var acc: float = 0
var origin: Vector2
var max_acc: float

func _ready():
    ._ready()
    origin = transform.origin
    acc = initial_pi * PI
    max_acc = PI * 2 if loop else PI

func _physics_process(delta):
    if Engine.editor_hint:
        return
    acc += delta / seconds * max_acc
    acc = fmod(acc, max_acc)
    var pos = (cos(acc-PI)+1)/2 # Map cos [-1, 1] to [0, 1]
    $Path/Follow.unit_offset = max(0.001, min(0.999, pos))
    transform.origin = origin + $Path/Follow.position

func _draw():
    if not Engine.editor_hint:
        return
    var half = Vector2(length/2, 0)
    var count = $Path.curve.get_point_count()
    for i in range(count):
        var pos = $Path.curve.get_point_position(i)
        draw_line(pos - half, pos + half, CS.col(color), 2 if i==0 or i==count-1 else 1)