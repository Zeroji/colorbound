extends Control

class_name Settings

const SETTINGS = [
    {key="colorblind", label="Colorblind mode",
     values=[["ON", true], ["OFF", false]]},
    {key="touchinput", label="Touch input size",
     values=[["2X", 2], ["1X", 1], ["FULL", 3], ["OFF", 0]]},
    {key="sfx", label="SFX volume",
     values=[["OFF", null], ["1", -21], ["2", -15], ["3", -9]]},
]

var opt_indexes = {}

const color_idle = Color("#999999")
const color_focus = Color("#eeeeee")

func apply_new_settings():
    for st in SETTINGS:
        var value = st.values[opt_indexes[st.key]][1]
        Main.sd.settings[st.key] = value
    Main.apply_settings()
    Main.save_game()

func connect_label(node: Control, key, group):
    if not node.is_connected("focus_entered", self, "_on_enter_focus"):
        node.connect("focus_entered", self, "_on_enter_focus", [node])
    if not node.is_connected("focus_exited", self, "_on_exit_focus"):
        node.connect("focus_exited", self, "_on_exit_focus", [node])
    if not node.is_connected("gui_input", self, "_on_gui_input"):
        node.connect("gui_input", self, "_on_gui_input", [node, key, group])

func option_deselect(label: Label):
    label.text = label.text.substr(1, len(label.text) - 2)
    label.add_color_override("font_color", color_idle)

func option_select(label: Label):
    label.text = '[%s]' % label.text
    label.add_color_override("font_color", color_focus)

func option_next(key, options: Container, inc=1):
    var index = opt_indexes[key]
    if index > -1:
        option_deselect(options.get_child(index))
    index += inc
    if index >= options.get_child_count():
        index = 0
    elif index < 0:
        index = options.get_child_count() - 1
    option_select(options.get_child(index))
    opt_indexes[key] = index
    if key == 'sfx':
        test_sfx()

func _ready():
    var font = load("res://assets/settings_font.tres")
    var grid = $Margin/VBox/Grid
    
    for st in SETTINGS:
        var label = Label.new()
        grid.add_child(label)
        label.text = ' ' + st.label
        label.autowrap = true
        label.add_font_override("font", font)
        label.focus_mode = Control.FOCUS_ALL
        label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        label.add_color_override("font_color", color_idle)
        #label.font_color = color_idle
        var options = HBoxContainer.new()
        options.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        options.alignment = BoxContainer.ALIGN_CENTER
        grid.add_child(options)
        opt_indexes[st.key] = -1
        var idx = 0
        for opt in st.values:
            var option = Label.new()
            var lbl = opt[0]
            option.add_color_override("font_color", color_idle)
            if Main.sd.settings[st.key] == opt[1]:
                option.add_color_override("font_color", color_focus)
                lbl = "[%s]" % lbl
                opt_indexes[st.key] = idx
            options.add_child(option)
            option.size_flags_horizontal = Control.SIZE_EXPAND + Control.SIZE_SHRINK_CENTER
            option.text = lbl
            option.add_font_override("font", font)
            option.mouse_filter = Control.MOUSE_FILTER_STOP
            option.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
            option.connect("gui_input", self, "_on_option_click", [options, idx, st.key])
            idx += 1
        connect_label(label, st.key, options)
    connect_label($Margin/VBox/Apply, null, null)
    connect_label($Margin/VBox/Discard, null, null)
    $Margin/VBox/Apply.grab_focus()

func _on_enter_focus(node: Label):
    node.text = '>' + node.text.substr(1, 99)
    node.add_color_override("font_color", color_focus)
    if node.name == 'Discard':
        node.add_color_override("font_color", Color("#ff2020"))

func _on_exit_focus(node: Label):
    node.text = ' ' + node.text.substr(1, 99)
    node.add_color_override("font_color", color_idle)
    if node.name == 'Discard':
        node.add_color_override("font_color", Color("#ff8080"))

func _on_gui_input(event: InputEvent, node: Label, key, group):
    if group != null:
        if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_select"):
            option_next(key, group)
        if event.is_action_pressed("ui_left"):
            option_next(key, group, -1)
    elif event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
        if node.name == 'Apply':
            apply_new_settings()
            Main.title()
        elif node.name == 'Discard':
            Main.apply_settings()  # Fix audio modifications
            Main.title()

func _on_option_click(event: InputEvent, options, index, key):
    if event is InputEventMouseButton:
        event = event as InputEventMouseButton
        if event.button_index == BUTTON_LEFT and event.is_pressed():
            if opt_indexes[key] > -1:
                option_deselect(options.get_child(opt_indexes[key]))
            opt_indexes[key] = index
            option_select(options.get_child(index))
            if key == 'sfx':
                test_sfx()

func test_sfx():
    var sfx_bus = AudioServer.get_bus_index('SFX')
    var volume = null
    for st in SETTINGS:
        if st.key != 'sfx':
            continue
        volume = st.values[opt_indexes['sfx']][1]
    AudioServer.set_bus_mute(sfx_bus, volume == null)
    if volume != null:
        AudioServer.set_bus_volume_db(sfx_bus, volume)
    $SoundTest.play()
