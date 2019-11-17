extends StaticBody2D

var open_count = 0
var close_count = 0

func update_label():
    $Label.text = "Open: %d\nClose: %d" % [open_count, close_count]

func _ready():
    for node in get_children():
        if node is XButton:
            if not node.is_connected("button_on", self, "open"):
                node.connect("button_on", self, "open")
            if not node.is_connected("button_off", self, "close"):
                node.connect("button_off", self, "close")

func open():
    open_count += 1
    update_label()
    if open_count == close_count + 1:
        $Animation.play("open")

func close():
    close_count += 1
    update_label()
    if open_count == close_count:
        $Animation.play("close")
