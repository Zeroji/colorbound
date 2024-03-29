tool
extends Platform

enum Loop {Linear, Sin}

export var seconds: float = 2
export var loop: bool = true
export (float) var initial_pi = 0
export (Loop) var loop_type = Loop.Sin

var acc: float = 0
var origin: Vector2
var max_acc: float
var path: Path2D = null
var follow: PathFollow2D = null

func _ready():
    ._ready()
    origin = transform.origin
    acc = initial_pi * PI
    max_acc = PI * 2 if loop else PI
    for node in get_children():
        if node is Path2D and node.name != 'BasePath':
            path = node
            follow = PathFollow2D.new()
            follow.name = 'Follow'
            path.add_child(follow)
            break
    if path == null:
        path = $BasePath
        follow = $BasePath/Follow
        push_warning("Could not find a child path")

func _physics_process(delta):
    if Engine.editor_hint or follow == null:
        return
    acc += delta / seconds * max_acc
    acc = fmod(acc, max_acc)
    var pos
    match(loop_type):
        Loop.Sin:
            pos = (cos(acc-PI)+1)/2 # Map cos [-1, 1] to [0, 1]
        Loop.Linear:
            pos = acc/PI # Map [0, max_acc] to [0, 1]
            if pos > 1:
                pos = 2-pos
    follow.unit_offset = max(0.001, min(0.999, pos))
    transform.origin = origin + follow.position

func _draw():
    if not Engine.editor_hint or path == null:
        return
    var half = Vector2(length/2, 0)
    var count = path.curve.get_point_count()
    for i in range(count):
        var pos = path.curve.get_point_position(i)
        draw_line(pos - half, pos + half, CS.col(color), 2 if i==0 or i==count-1 else 1)