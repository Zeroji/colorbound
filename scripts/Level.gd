extends Node2D

# Main code for all levels
class_name Level

signal checkpoint
signal completed

var last_checkpoint = null

func save_checkpoint(checkpoint):
    last_checkpoint = checkpoint
    emit_signal("checkpoint", name, checkpoint.name, CS.name(checkpoint.color))

func load_checkpoint(checkpoint):
    $Player.position = checkpoint.position
    $Player.color = checkpoint.color
    $Player.visible = true

func resume(checkpoint_name, color_name):
    var checkpoint = get_node(checkpoint_name)
    checkpoint.color = CS.Colors[color_name]
    load_checkpoint(checkpoint)

func _ready():
    connect("checkpoint", Main, "level_checkpoint")
    connect("completed", Main, "level_completed")
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

# When player steps in elevator, lock them in
func _on_elevator_activated(elevator):
    $Player.immobilize()
    $Player.position = elevator.position

# When elevator doors close, transition to next level
func _on_elevator_finished():
    emit_signal("completed")
