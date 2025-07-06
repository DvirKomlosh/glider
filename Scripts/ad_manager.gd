extends Node

@onready var admob: Admob = $"../Admob"

var is_initialized: bool = false
var ad_loaded: bool = false
var should_be_rewarded: bool = false

signal watched_fully(earned_reward :bool)


func _ready():
	call_deferred("init_admob")
	
func init_admob():
	if Engine.has_singleton("AdmobPlugin"):
		admob.initialize()
	else:
		push_error("AdMob singleton not found!")

func _load_rewarded_ad():
	if is_initialized:
		admob.load_rewarded_ad()
		

func _show_reward_ad():
	if is_initialized and ad_loaded:
		admob.show_rewarded_ad()
		ad_loaded = false
		_load_rewarded_ad()
		

func is_ad_loaded() -> bool:
	if not ad_loaded:
		_load_rewarded_ad() # try to load one for next time
	return ad_loaded

func try_get_reward() -> bool:
	'''
	returns true if the user should get rewarded
	'''
	_show_reward_ad()
	await admob.rewarded_ad_dismissed_full_screen_content
	if should_be_rewarded:
		should_be_rewarded = false
		return true
	return false

func _on_admob_rewarded_ad_loaded(ad_id: String) -> void:
	ad_loaded = true

func _on_admob_rewarded_ad_user_earned_reward(ad_id: String, reward_data: RewardItem) -> void:
	should_be_rewarded = true



func _on_admob_initialization_completed(status_data: InitializationStatus) -> void:
	is_initialized = true
	_load_rewarded_ad()


func _on_admob_rewarded_ad_failed_to_load(ad_id: String, error_data: LoadAdError) -> void:
	ad_loaded = false
	
func _on_admob_rewarded_ad_dismissed_full_screen_content(ad_id: String) -> void:
	emit_signal("watched_fully", false)
	#$"../CanvasLayer/HeadsUpDisplay/debug".text = "dismissed"

func _on_admob_rewarded_ad_failed_to_show_full_screen_content(ad_id: String, error_data: AdError) -> void:
	emit_signal("watched_fully", false)


func _on_admob_rewarded_ad_showed_full_screen_content(ad_id: String) -> void:
	pass
