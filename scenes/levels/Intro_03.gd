extends Level

func _ready():
    $Text/EndInfo.visible = false

func _on_DetectEnd_body_entered(body):
    if body is Player:
        $Text/EndInfo.visible = true
