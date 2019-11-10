extends Node

class_name CS

enum Colors { white, red, yellow, blue, orange, green, purple, all }

const ColorData = {
    Colors.white:   {id=0, bits=[10], name = "white"},
    Colors.red:     {id=1, bits=[11], name = "red"},
    Colors.yellow:  {id=2, bits=[12], name = "yellow"},
    Colors.blue :   {id=3, bits=[13], name = "blue"},
    Colors.orange:  {id=4, bits=[11, 12], name = "orange"},
    Colors.green:   {id=5, bits=[12, 13], name = "green"},
    Colors.purple:  {id=6, bits=[11, 13], name = "purple"},
    Colors.all:     {id=7, bits=[11, 12, 13], name = "all"},
}

static func id(color):
    return ColorData[color].id
static func bits(color):
    return ColorData[color].bits
static func name(color):
    return ColorData[color].name
