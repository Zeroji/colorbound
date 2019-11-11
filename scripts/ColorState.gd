extends Node

class_name CS

enum Colors { white, red, yellow, blue, orange, green, purple, all }

# layer bit = what color the object actually is
# layer mask = what colors the object collides with

const ColorData = {
    Colors.white:   {id=0, layer=10, mask=[10], name = "white"},
    Colors.red:     {id=1, layer=11, mask=[11, 14, 16], name = "red"},
    Colors.yellow:  {id=2, layer=12, mask=[12, 14, 15], name = "yellow"},
    Colors.blue :   {id=3, layer=13, mask=[13, 15, 16], name = "blue"},
    Colors.orange:  {id=4, layer=14, mask=[14, 11, 12], name = "orange"},
    Colors.green:   {id=5, layer=15, mask=[15, 12, 13], name = "green"},
    Colors.purple:  {id=6, layer=16, mask=[16, 11, 13], name = "purple"},
    Colors.all:     {id=7, layer=17, mask=[17], name = "all"},
}

static func id(color):
    return ColorData[color].id
static func layer(color):
    return ColorData[color].layer
static func mask(color):
    return ColorData[color].mask
static func name(color):
    return ColorData[color].name
