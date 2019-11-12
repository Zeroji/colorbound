extends Node2D

# Main code for all levels
class_name Level

func _ready():
    if get_tree().current_scene.name == 'Level':
        push_warning("Level node has not been renamed")
    var spawn = get_node("SpawnPoint")
    if spawn == null:
        push_error("Error: no spawn point defined in scene " + get_tree().current_scene.name)
    else:
        $Player.position = spawn.position
        $Player.color = spawn.color
        $Player.visible = true
    for elevator in $Elevators.get_children():
        var error = elevator.connect("activated", self, "_on_elevator_activated")
        error = elevator.connect("finished", self, "_on_elevator_finished")

# When player steps in elevator, lock them in
func _on_elevator_activated(elevator):
    $Player.immobilize()
    $Player.position = elevator.position

# When elevator doors close, transition to next level
func _on_elevator_finished():
    LL.next_level(get_tree())
