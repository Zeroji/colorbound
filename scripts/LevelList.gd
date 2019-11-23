extends Node

const SCENE_PATH = "res://scenes/levels/%s.tscn"
const TITLE_PATH = "res://scenes/Title.tscn"
const LEVEL_PATH = "res://scenes/LevelSelect.tscn"

var Levels = [{
        name = "Introduction", dir = '.', levels = [
            {key = 'Intro_01', label = "Red VS Blue"},
            {key = 'Intro_02', label = "Ready Player Yellow"},
            {key = 'Intro_03', label = "Head first in the wall"},
            {key = 'Intro_04', label = "Pushing your buttons"},
            {key = 'Intro_05', label = "Obvious, yet wrong"},
            {key = 'Intro_06', label = "Taste the rainbow!"},
            {key = 'Intro_07', label = "Final course"},
        ]
    }, {
        name = "Moves", dir = 'moves', levels = [
            {key = 'Moves_01', label = "Zoooooooom", req=['Intro_01']},
            {key = 'Moves_02', label = "Trigonometric"},
            {key = 'Moves_03', label = "Jumping down the rainbow"},
            {key = 'Moves_04', label = "4-Wheel Jump"},
            {key = 'Moves_05', label = "Rainbow Vomit Road"},
        ]
    }, {
        name = "Showcase", dir = '.', levels = [
            {key = 'Showcase', label = "Game Off 2019 showcase", req=['Moves_01']},
        ]
    }
]

func _init():
    var prev = null
    for g_index in range(len(Levels)):
        for l_index in range(len(Levels[g_index].levels)):
            if not Levels[g_index].levels[l_index].has('req'):
                Levels[g_index].levels[l_index].req = [prev] if prev else []
            prev = Levels[g_index].levels[l_index].key

func build_path(g_index, l_index):
    var dir = Levels[g_index].dir
    var name = Levels[g_index].levels[l_index].key
    var full_name = name if dir == "." else dir + "/" + name
    return SCENE_PATH % full_name

var first_level = build_path(0, 0)

func get(level_name):
    var idx = get_indexes(level_name)
    return build_path(idx[0], idx[1])

func get_indexes(level_name):
    for g_index in range(len(Levels)):
        var levels = Levels[g_index].levels
        for l_index in range(len(levels)):
            if levels[l_index].key == level_name:
                return [g_index, l_index]
    return [-1, -1]

func get_display_name(level_name):
    var idx = get_indexes(level_name)
    if idx[0] == -1:
        return '[ERR: UNKNOWN LEVEL]'
    return Levels[idx[0]].levels[idx[1]].label

func get_display_index(level_name):
    var idx = get_indexes(level_name)
    if idx[0] == -1:
        push_error("Cannot find level: %s" % level_name)
    return '%d-%d' % [idx[0]+1, idx[1]+1]

func is_completed(level_name):
    if Main.sd.levels.has(level_name) and Main.sd.levels[level_name].has('completed'):
        return Main.sd.levels[level_name].completed
    return false

func is_unlocked(level_name):
    var idx = get_indexes(level_name)
    var unlocked: bool = true
    for level in Levels[idx[0]].levels[idx[1]].req:
        unlocked = unlocked and is_completed(level)
    return unlocked

func next(level_name):
    var indexes = get_indexes(level_name)
    var g_index = indexes[0]
    var l_index = indexes[1]
    if g_index == -1:
        return TITLE_PATH
    l_index += 1
    if l_index >= len(Levels[g_index].levels):
        l_index = 0
        g_index += 1
    if g_index >= len(Levels):
        return TITLE_PATH
    if not is_unlocked(Levels[g_index].levels[l_index].key):
        return LEVEL_PATH
    return build_path(g_index, l_index)
