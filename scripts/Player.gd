extends KinematicBody2D

class_name Player

const GRAVITY = 1500.0
const WALK_SPEED = 300
const JUMP_SPEED = 550
const JUMP_TIME = 0.5

var velocity = Vector2()
var target_velx = 0
var jump: float = 0
export (CS.Colors) var color = CS.Colors.white setget set_color
export (bool) var mobile = true

func _physics_process(delta):
    var snap = Vector2(0, 20)
    jump = max(0, jump-delta)
    if jump:
        snap.y = 0
    if !is_on_floor():
        velocity.y += delta * GRAVITY
    
    velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1), true, 4, PI/3)
    
    var walk_speed = 0
    if mobile:
        if Input.is_action_pressed("left"):
            walk_speed -= 1
        if Input.is_action_pressed("right"):
            walk_speed += 1
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = -JUMP_SPEED
            jump = JUMP_TIME
    
    target_velx = lerp(target_velx, walk_speed*WALK_SPEED, 15*delta)
    velocity.x = target_velx # walk_speed*WALK_SPEED
    #velocity +=  + get_floor_velocity()
    """
    var sprite: AnimatedSprite = $AnimatedSprite
    if velocity.x > 0:
        sprite.flip_h = false
    elif velocity.x < 0:
        sprite.flip_h = true
    if abs(velocity.x) > 10:
        sprite.animation = "running"
    else:
        sprite.animation = "default"
        """

func set_color(col):
    # Update collision layers
    if color != col:
        set_collision_layer_bit(CS.layer(color), false)
        set_collision_layer_bit(CS.layer(col), true)
    color = col
    $ColorAdd.set_color(color)
    $AnimatedSprite.animation = CS.name(color)

func immobilize():
    velocity.x = 0
    target_velx = 0
    mobile = false
