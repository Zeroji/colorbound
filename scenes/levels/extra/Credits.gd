extends Level

var acc: float = 0

func _process(delta):
    acc += delta
    var hue = fmod(acc/4, 1)
    $Logo.material.set_shader_param("shift", hue)
