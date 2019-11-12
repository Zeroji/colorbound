extends Node

class_name LL

const Levels = [
    "Intro_00",
    "Intro_01",
    "Intro_02",
    "Intro_03",
    "Showcase",
]

static func next_level(tree: SceneTree):
    var name = tree.current_scene.name
    var index = Levels.find(name)
    if index == -1 or index + 1 >= len(Levels):
        change_level(tree, "res://scenes/Title.tscn")
    else:
        change_level(tree, "res://scenes/levels/%s.tscn" % Levels[index + 1])

static func change_level(tree: SceneTree, scene: String):
    tree.change_scene(scene)
