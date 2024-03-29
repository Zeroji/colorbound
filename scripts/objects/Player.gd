extends KinematicBody2D

class_name Player

signal death

const GRAVITY = 1500.0
const WALK_SPEED = 300
const JUMP_SPEED = 550
const JUMP_TIME = 0.5
const TEXTURE_SIZE:int = 32
const TEXTURE_SIZE_DEATH:int = 64

var alive: bool = false
var invincible: float = 0
var velocity = Vector2()
var last_position = Vector2()
var actual_velocity = Vector2()
var target_velx = 0
var jump: float = 0
export (CS.Colors) var color = CS.Colors.white setget set_color
export (bool) var mobile = true

func _ready():
    set_color(color)
    set_collision_layer_bit(CS.layer(color), true)
    var touch_node = get_node("TouchInput%d" % Main.sd.settings.touchinput)
    if touch_node != null:
        for node in touch_node.get_children():
            # Hide menu on title screen
            if node.name == 'ButtonMenu' and Main.level_name == 'Title':
                continue
            node.visible = true

func _physics_process(delta):
    invincible = max(0, invincible - delta)
    var snap = Vector2(0, 20)
    jump = max(0, jump-delta)
    if jump:
        snap.y = 0
    if !is_on_floor():
        velocity.y += delta * GRAVITY
    
    velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1), true, 4, PI/3)
    
    var walk_speed = 0
    if mobile and alive:
        if Input.is_action_pressed("left"):
            walk_speed -= 1
        if Input.is_action_pressed("right"):
            walk_speed += 1
        if Input.is_action_just_pressed("jump") and is_on_floor():
            velocity.y = -JUMP_SPEED
            jump = JUMP_TIME
            #$JumpSound.play()
    # Only lerp when going at normal speeds - when exiting portals, go whoosh
    if is_on_floor() or abs(velocity.x) <= WALK_SPEED * 1.05:
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
    actual_velocity = (position - last_position) / delta
    last_position = position

func set_color(col):
    # Update collision layers
    if color != col:
        set_collision_layer_bit(CS.layer(color), false)
        set_collision_layer_bit(CS.layer(col), true)
    color = col
    $ColorAdd.set_color(color)
    # dirty fix
    $Sprite.visible = false
    $Sprite.texture.region.position.x = TEXTURE_SIZE * CS.id(color)
    $Sprite.visible = true

func immobilize():
    velocity.x = 0
    target_velx = 0
    mobile = false

onready var was_coloradd_visible = $ColorAdd.visible

func spawn():
    visible = true
    target_velx = 0
    $ColorAdd.visible = was_coloradd_visible
    $Sprite.visible = true
    mobile = true
    alive = true
    invincible = 0.1

func kill():
    if not alive or invincible > 0:
        return
    alive = false
    $Death.texture.region.position.y = TEXTURE_SIZE_DEATH * CS.id(color)
    $Death.visible = true
    $Sprite.visible = false
    was_coloradd_visible = $ColorAdd.visible
    $ColorAdd.visible = false
    $Death/Anim.play("death")
    $DeathSound.play()

func _on_Anim_animation_finished(anim_name):
    if anim_name == "death":
        $Death.visible = false
        $Death/Anim.seek(0)
        emit_signal("death")
