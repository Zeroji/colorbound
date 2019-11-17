extends Node

var scene: Node = null
var level_name: String = ""
var debug_mode: bool = true

# Save data management
const save_path = 'user://colorbound.json'
const SAVE_VER: int = 1
const base_data = {
    ver = SAVE_VER,
    levels = {},
    settings = {},
}
const base_settings = {"colorblind": false, "touchinput": 2}

var sd = null # save data

func update_save_data():
    for key in base_data.keys():
        if not sd.has(key):
            sd[key] = base_data[key]
    for key in base_settings.keys():
        if not sd.settings.has(key):
            sd.settings[key] = base_settings[key]
    save_game()
func init_save_data():
    sd = base_data
    sd.settings = base_settings
    save_game()
func load_game():
    # Load saved game data
    var save_file = File.new()
    if not save_file.file_exists(save_path):
        print('Cannot find save file: %s' % save_path)
        return false
    save_file.open(save_path, File.READ)
    sd = parse_json(save_file.get_as_text())
    return sd.has('ver')
func save_game():
    # Save game data
    sd.ver = SAVE_VER
    var save_file = File.new()
    save_file.open(save_path, File.WRITE)
    save_file.store_line(to_json(sd))
    save_file.close()

func start_new():
    Main.switch_to(LL.first_level)

func resume():
    Main.switch_to(LL.get(sd.checkpoint.level), sd.checkpoint)

func _init():
    OS.set_low_processor_usage_mode(true)
    if load_game():
        print("Successfully loaded save data")
        if sd.ver < SAVE_VER:
            update_save_data()
            print("Updated save data to version ", SAVE_VER)
    else:
        init_save_data()

func _ready():
    var root = get_tree().root
    scene = root.get_child(root.get_child_count()-1)
    level_name = scene.name
    if level_name == "Title":
        debug_mode = false

func level_checkpoint(level_name, checkpoint_name, color_name):
    if debug_mode:
        return
    if not sd.levels.has(level_name):
        sd.levels[level_name] = {}
    sd.levels[level_name].checkpoint = {name = checkpoint_name, color = color_name}
    sd.checkpoint = {level = level_name, name = checkpoint_name, color = color_name}
    save_game()

func level_completed():
    if debug_mode:
        get_tree().quit()
    else:
        # Store level completion data
        if sd.levels.has(level_name):
            # Update scores and whatnot
            pass
        else:
            sd.levels[level_name] = { completed = true }
        save_game()
        switch_to(LL.next(level_name))

func switch_to(scene_path, checkpoint=null):
    call_deferred("_deferred_switch_to", scene_path, checkpoint)

func _deferred_switch_to(scene_path, checkpoint=null):
    scene.free()
    var s = ResourceLoader.load(scene_path)
    scene = s.instance()
    level_name = scene.name
    get_tree().root.add_child(scene)
    get_tree().set_current_scene(scene)
    if scene is Level and checkpoint != null:
        (scene as Level).resume(checkpoint.name, checkpoint.color)
