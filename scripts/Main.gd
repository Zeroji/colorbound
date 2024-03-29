extends Node

var scene: Node = null
var level_name: String = ""
var debug_mode: bool = true

# Save data management
const save_path = 'user://colorbound.json'
const SAVE_VER: int = 3
const base_data = {
    ver = SAVE_VER,
    levels = {},
    settings = {},
}
const base_level_data = { completed = false }
const base_settings = {"colorblind": false, "touchinput": 2, "sfx": -15}

var sd = null # save data

func update_save_data():
    if sd.has('checkpoint') and sd.checkpoint.level == 'Intro_00':
        sd.checkpoint.level = 'Intro_01'
    for key in base_data.keys():
        if not sd.has(key):
            sd[key] = base_data[key]
    sd.levels.erase('Intro_00')
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

func title():
    if debug_mode:
        get_tree().quit()
    else:
        Main.switch_to("res://scenes/Title.tscn")

func start_new():
    Main.switch_to(LL.first_level)

func resume():
    Main.switch_to(LL.get(sd.checkpoint.level), sd.checkpoint)

func levels():
    Main.switch_to("res://scenes/LevelSelect.tscn")

func play_level(level_name):
    if debug_mode:
        print('[DBG] Switching to ', level_name)
        return
    Main.switch_to(LL.get(level_name))

func settings():
    Main.switch_to("res://scenes/Settings.tscn")

func quit():
    if debug_mode:
        get_tree().quit()
        return
    save_game()
    Main.switch_to("res://scenes/Quit.tscn")
    get_tree().call_deferred("set_pause", true)
    get_tree().call_deferred("quit")

func apply_settings():
    # colorblind: nothing to be done (see ColorAddSprite.gd)
    # touchinput: nothing to be done (see Player.gd)
    var sfx_bus = AudioServer.get_bus_index('SFX')
    AudioServer.set_bus_mute(sfx_bus, sd.settings.sfx == null)
    if sd.settings.sfx != null:
        AudioServer.set_bus_volume_db(sfx_bus, sd.settings.sfx)
    pass

func _init():
    OS.set_low_processor_usage_mode(true)
    if load_game():
        print("Successfully loaded save data")
        if sd.ver < SAVE_VER:
            update_save_data()
            print("Updated save data to version ", SAVE_VER)
        apply_settings()
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
        sd.levels[level_name] = base_level_data
    sd.levels[level_name].checkpoint = {name = checkpoint_name, color = color_name}
    sd.checkpoint = {level = level_name, name = checkpoint_name, color = color_name}
    save_game()

func level_completed():
    if debug_mode:
        get_tree().quit()
    else:
        # Store level completion data
        if not sd.levels.has(level_name):
            sd.levels[level_name] = base_level_data
            # Update scores and whatnot
        sd.levels[level_name].completed = true
        save_game()
        switch_to(LL.next(level_name))

func switch_to(scene_path, checkpoint=null):
    call_deferred("_deferred_switch_to", scene_path, checkpoint)

func _deferred_switch_to(scene_path, checkpoint=null):
    var s = ResourceLoader.load(scene_path)
    if s == null:
        push_error("Failed to load scene: %s" % scene_path)
        return
    scene.free()
    scene = s.instance()
    level_name = scene.filename.substr(scene.filename.find_last("/")+1, 99).replace('.tscn', '')
    get_tree().root.add_child(scene)
    get_tree().set_current_scene(scene)
    if scene is Level and checkpoint != null:
        (scene as Level).resume(checkpoint.name, checkpoint.color)
