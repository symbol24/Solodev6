extends Node2D


@export var scenes:Dictionary = {}
@export var min_loading_time:float = 1

var ui:CanvasLayer
var active_world:Node2D
var is_loading := false
var to_load := ""
var load_complete := false
var loading_id:String
var loading_status := 0.0
var progress := []


func _ready() -> void:
	# Process mode is set to "always" through code
	process_mode = PROCESS_MODE_ALWAYS

	Signals.LoadScene.connect(_load_scene)


func _process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		
		# When loading is complete in ResourceLoader, launch the _complete_load function.
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()


func _load_scene(_id:String = "", display_loading:bool = true) -> void:
	if display_loading: Signals.ToggleDisplay.emit("loading_screen", "")
	get_tree().paused = true
	
	_clear_active_scene()

	# If path is empty, dont try to load.
	var path:String = scenes[_id] if scenes.has(_id) else ""
	if path == "":
		print("Path to load is empty.")
		return

	# Starting the ResourceLoader.
	loading_id = _id
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)


func _complete_load() -> void:
	is_loading = false

	# Get the new level from the ResourceLoader and instantiate it.
	var new_scene := ResourceLoader.load_threaded_get(to_load)
	var new = new_scene.instantiate()
	# If there is an active level, queue_free it.
	if active_world != null and new is World: 
		var temp := active_world
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()

	if new is CanvasLayer:
		ui = new
	else:
		active_world = new

	add_child.call_deferred(new)
	
	if not new.is_node_ready():
		await new.ready
	
	await get_tree().create_timer(min_loading_time).timeout

	get_tree().paused = false
	Signals.LoadSceneComplete.emit(loading_id)


func _clear_active_scene() -> void:
	if active_world != null:
		active_world.queue_free()
		active_world = null
