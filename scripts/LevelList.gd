extends Node

const SCENE_PATH = "res://scenes/levels/%s/%s.tscn"
const TITLE_PATH = "res://scenes/Title.tscn"

const Levels = [{
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
        name = "Showcase", dir = '.', levels = [
            {key = 'Showcase', label = "Game Off 2019 showcase"},
        ]
    }
]

const first_level = SCENE_PATH % [Levels[0].dir, Levels[0].levels[0].key]

func get(level_name):
    var idx = get_indexes(level_name)
    return SCENE_PATH % [Levels[idx[0]].dir, level_name]

func get_indexes(level_name):
    for g_index in range(len(Levels)):
        var levels = Levels[g_index].levels
        for l_index in range(len(levels)):
            if levels[l_index].key == level_name:
                return [g_index, l_index]
    return [-1, 0]

func get_display_name(level_name):
    var idx = get_indexes(level_name)
    return Levels[idx[0]].levels[idx[1]].label

func get_display_index(level_name):
    var idx = get_indexes(level_name)
    if idx[0] == -1:
        push_error("Cannot find level: %s" % level_name)
    return '%d-%d' % [idx[0]+1, idx[1]+1]

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
    return SCENE_PATH % [Levels[g_index].dir, Levels[g_index].levels[l_index].key]
