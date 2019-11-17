extends Node

const SCENE_PATH = "res://scenes/levels/%s.tscn"
const TITLE_PATH = "res://scenes/Title.tscn"

const Levels = [
    "Intro_01",
    "Intro_02",
    "Intro_03",
    "Intro_04",
    "Intro_05",
    "Intro_06",
    "Intro_07",
    "Showcase",
]

const first_level = SCENE_PATH % Levels[0]

func get(level_name):
    return SCENE_PATH % level_name

func next(level_name):
    var index = Levels.find(level_name)
    if index == -1 or index + 1 >= len(Levels):
        return TITLE_PATH
    else:
        return SCENE_PATH % Levels[index + 1]
