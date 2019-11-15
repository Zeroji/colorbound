extends StaticBody2D

var open_count = 0
var close_count = 0

func update_label():
    $Label.text = "Open: %d\nClose: %d" % [open_count, close_count]

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
