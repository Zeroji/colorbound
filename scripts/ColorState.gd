extends Node

class_name CS

enum Colors { white, red, yellow, blue, orange, green, purple, all }

const ColorData = {
    Colors.white:   {id=0, bit=10, name = "white"},
    Colors.red:     {id=1, bit=11, name = "red"},
    Colors.yellow:  {id=2, bit=12, name = "yellow"},
    Colors.blue :   {id=3, bit=13, name = "blue"},
    Colors.orange:  {id=4, bit=14, name = "orange"},
    Colors.green:   {id=5, bit=15, name = "green"},
    Colors.purple:  {id=6, bit=16, name = "purple"},
    Colors.all:     {id=7, bit=17, name = "all"},
}

static func id(color):
    return ColorData[color].id
static func bit(color):
    return ColorData[color].bit
static func name(color):
    return ColorData[color].name
