extends Control

const COLOR_COMPLETE = Color('#808080')
const COLOR_UNLOCKED = Color('#49ad35')
const COLOR_BLOCKING = Color('#b20b0b')
const COLOR_LOCKED = Color('#404040')

const BOX_OFFSET = Vector2(32, 32)
const TX_AVAIL = ['normal', 'focused']

var initialized: bool = false

func add_line(key, dest: Vector2, complete: bool):
    var idx = LL.get_indexes(key)
    var node: Node = $Margin/VBox/Levels.get_child(idx[0]).get_child(idx[1])
    var line = Line2D.new()
    line.add_point(node.get_global_transform_with_canvas().origin + BOX_OFFSET)
    line.add_point(dest + BOX_OFFSET)
    line.width = 4
    if LL.is_completed(key):
        line.default_color = COLOR_COMPLETE if complete else COLOR_UNLOCKED
    elif LL.is_unlocked(key):
        line.default_color = COLOR_BLOCKING
    else:
        line.default_color = COLOR_LOCKED
    $Lines.add_child(line)

func _ready():
    # Load all level icon textures
    var tx = {}
    for link_type in ['complete', 'unlocked', 'locked']:
        tx[link_type] = {}
        for tx_type in TX_AVAIL:
            tx[link_type][tx_type] = load("res://assets/ui/level_%s_%s.png" % [link_type, tx_type])
    var font = load("res://assets/settings_font.tres")
    # Create every level button
    var lvl = $Margin/VBox/Levels
    var g_index = 0
    for group in LL.Levels:
        g_index += 1
        # HBox for levels
        var box: HBoxContainer = HBoxContainer.new()
        box.name = 'G%s' % g_index
        box.add_constant_override("separation", 16)
        lvl.add_child(box)
        var l_index = 0
        for level in group.levels:
            l_index += 1
            var button = TextureButton.new()
            button.name = 'L%s' % l_index
            var link_type = 'locked'
            if LL.is_completed(level.key):
                link_type = 'complete'
            elif LL.is_unlocked(level.key):
                link_type = 'unlocked'
            button.texture_normal = tx[link_type]['normal']
            button.texture_focused = tx[link_type]['focused']
            button.focus_mode = Control.FOCUS_ALL
            button.mouse_default_cursor_shape = CURSOR_POINTING_HAND
            button.connect("focus_entered", self, "on_button_focused", [level.key])
            button.connect("button_down", self, "on_button_down", [level.key])
            box.add_child(button)
    # Focus last level played if possible
    if Main.sd.has('checkpoint'):
        var idx = LL.get_indexes(Main.sd.checkpoint.level)
        lvl.get_child(idx[0]).get_child(idx[1]).grab_focus()
    else:
        lvl.get_child(0).get_child(0).grab_focus()

# This is used as a second _ready function
# Calling get_global_transform_with_canvas in _ready gives invalid values
func _process(delta):
    if initialized:
        return
    var lvl = $Margin/VBox/Levels
    for g_index in len(LL.Levels):
        for l_index in len(LL.Levels[g_index].levels):
            var level = LL.Levels[g_index].levels[l_index]
            var complete = LL.is_completed(level.key)
            var dest = lvl.get_child(g_index).get_child(l_index).get_global_transform_with_canvas().origin
            for key in level.req:
                add_line(key, dest, complete)
    initialized = true

func on_button_focused(level_name):
    var idx = LL.get_indexes(level_name)
    $Margin/VBox/WorldName.text = "World %d - %s" % [idx[0]+1, LL.Levels[idx[0]].name]
    $Margin/VBox/LevelName.text = "%d - %s" % [idx[1]+1, LL.get_display_name(level_name)]

func on_button_down(level_name):
    if LL.is_unlocked(level_name):
        Main.play_level(level_name)

func _input(event: InputEvent):
    if event.is_action_pressed("ui_menu"):
        Main.title()

func _on_XButton_gui_input(event):
    if event.is_action_pressed("ui_accept"):
        Main.title()
