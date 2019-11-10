extends Node

class_name CS

enum Colors { red, yellow, blue }

const ColorData = {
    Colors.red:    {id=0, bit=10, name = "red"},
    Colors.yellow: {id=1, bit=11, name = "yellow"},
    Colors.blue :  {id=2, bit=12, name = "blue"},
}

static func id(color):
    return ColorData[color].id
static func bit(color):
    return ColorData[color].bit
static func name(color):
    return ColorData[color].name
