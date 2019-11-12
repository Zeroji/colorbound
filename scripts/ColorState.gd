extends Node

class_name CS

enum Colors { white, red, yellow, blue, orange, green, purple, all }

# layer bit = what color the object actually is
# layer mask = what colors the object collides with

const ColorData = {
    Colors.white:   {id=0, layer=10, mask=[10],         name = "white",  col = Color("#ffffff")},
    Colors.red:     {id=1, layer=11, mask=[11, 14, 16], name = "red",    col = Color("#ff0000")},
    Colors.yellow:  {id=2, layer=12, mask=[12, 14, 15], name = "yellow", col = Color("#ffff00")},
    Colors.blue :   {id=3, layer=13, mask=[13, 15, 16], name = "blue",   col = Color("#0000ff")},
    Colors.orange:  {id=4, layer=14, mask=[14, 11, 12], name = "orange", col = Color("#ff8800")},
    Colors.green:   {id=5, layer=15, mask=[15, 12, 13], name = "green",  col = Color("#00ff00")},
    Colors.purple:  {id=6, layer=16, mask=[16, 11, 13], name = "purple", col = Color("#ff00ff")},
    Colors.all:     {id=7, layer=17, mask=[17],         name = "all",    col = Color("#000000")},
}

static func id(color):
    return ColorData[color].id
static func layer(color):
    return ColorData[color].layer
static func mask(color):
    return ColorData[color].mask
static func name(color):
    return ColorData[color].name
static func col(color):
    return ColorData[color].col
