extends Node2D

# Main code for all levels
class_name Level

signal checkpoint
signal completed

var last_checkpoint = null
var base_name = null

func save_checkpoint(checkpoint):
    last_checkpoint = checkpoint
    emit_signal("checkpoint", base_name, checkpoint.name, CS.name(checkpoint.color))

func load_checkpoint(checkpoint):
    $Player.position = checkpoint.position
    $Player.color = checkpoint.color
    $Player.visible = true

func resume(checkpoint_name, color_name):
    var checkpoint = get_node(checkpoint_name)
    checkpoint.color = CS.Colors[color_name]
    load_checkpoint(checkpoint)

func connect_label(node: Label):
    if not node.is_connected("focus_entered", self, "_on_menu_focus_entered"):
        node.connect("focus_entered", self, "_on_menu_focus_entered", [node])
    if not node.is_connected("focus_exited", self, "_on_menu_focus_exited"):
        node.connect("focus_exited", self, "_on_menu_focus_exited", [node])
    if not node.is_connected("gui_input", self, "_on_menu_input_event"):
        node.connect("gui_input", self, "_on_menu_input_event", [node])

func _ready():
    connect("checkpoint", Main, "level_checkpoint")
    connect("completed", Main, "level_completed")
    base_name = filename.substr(filename.find_last("/") + 1, 99).replace('.tscn', '')
    if name != base_name:
        push_warning("Level node name differs from file name: %s" % filename)
    if name == 'Level':
        push_warning("Level node has not been renamed")
    var spawn = get_node("SpawnPoint")
    if spawn == null:
        push_error("Error: no spawn point defined in level " + name)
    else:
        save_checkpoint(spawn)
        load_checkpoint(spawn)
    for elevator in $Elevators.get_children():
        elevator.connect("activated", self, "_on_elevator_activated")
        elevator.connect("finished", self, "_on_elevator_finished")
    $CL/Menu/Container/Panel/VBox/LevelCount.text = "Level %s" % LL.get_display_index(name)
    $CL/Menu/Container/Panel/VBox/LevelName.text = LL.get_display_name(name)
    for label in $CL/Menu/Container/Panel/VBox.get_children():
        if not label.name.begins_with('Level'):
            connect_label(label)
    if OS.has_touchscreen_ui_hint():
        $CL/Menu.set_scale(Vector2(2, 2))
        $CL/Menu.margin_right = 0
        $CL/Menu.margin_bottom = 0

# When player steps in elevator, lock them in
func _on_elevator_activated(elevator):
    $Player.immobilize()
    $Player.position = elevator.position

# When elevator doors close, transition to next level
func _on_elevator_finished():
    emit_signal("completed")

func _input(event):
    if event.is_action_pressed("ui_menu"):
        get_tree().paused = true
        $CL/Menu.visible = true
        $CL/Menu/Container/Panel/VBox/Resume.grab_focus()
        get_tree().set_input_as_handled()

func _on_menu_focus_entered(node: Label):
    node.text = '>' + node.text + '<'

func _on_menu_focus_exited(node: Label):
    node.text = node.text.substr(1, len(node.text)-2)

func _on_menu_input_event(event: InputEvent, node: Label):
    if event.is_action_pressed("ui_menu"):
        $CL/Menu.visible = false
        get_tree().paused = false
    if event.is_action_released("ui_accept"):
        get_tree().paused = false
        get_tree().set_input_as_handled()
        match node.name:
            "Resume":
                $CL/Menu.visible = false
            "Restart":
                $CL/Menu.visible = false
                # TODO: add code to reset moving elements
                $Player.target_velx = 0
                load_checkpoint($SpawnPoint)
            "Settings":
                Main.settings()
            "Title":
                Main.title()
            "Quit":
                Main.quit()
