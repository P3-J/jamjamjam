extends Control

var main_menu_scene =  ResourceLoader.load("res://src/scenes/main_menu.tscn") as PackedScene

var time_text: RichTextLabel
var list: ItemList
var text_edit: TextEdit
var has_submit: bool

@onready var timer = $Timer2

func _ready() -> void:
	time_text = get_node("timer_text")
	list = get_node("ItemList")
	text_edit = get_node("TextEdit")

	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	var minute_str = str(Signalbus.minutes).pad_zeros(2)
	var second_str = str(Signalbus.seconds).pad_zeros(2)
	var millisecond_str = str(Signalbus.milliseconds).pad_zeros(3)
	time_text.text = minute_str + ":" + second_str + ":" + millisecond_str
	#refresh()



func time_to_int(minutes: int, seconds: int, milliseconds: int) -> int:
	return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds

func int_to_time(total_mils: int):

	var total_milliseconds = abs(total_mils)
	var minutes = total_milliseconds / 60000
	var seconds = (total_milliseconds % 60000) / 1000 
	var milliseconds = total_milliseconds % 1000  

	var minute_str = str(minutes ).pad_zeros(2)
	var second_str = str(seconds).pad_zeros(2)
	var millisecond_str = str(milliseconds).pad_zeros(3)
	return minute_str + ":" + second_str + ":" + millisecond_str

func submit():
	print("sending_data")
	#SilentWolf.Scores.save_score(text_edit.text, -time_to_int(Signalbus.minutes, Signalbus.seconds, Signalbus.milliseconds))
	timer.start()

func refresh():
	print("getting")
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores().sw_get_scores_complete
	add_to_list(sw_result.scores)


func add_to_list(results):
	list.clear()

	for score in results:
		print(score["score"])
		var line_string: String = str(score["player_name"]) + " : " + int_to_time(score["score"])
		print(line_string)
		list.add_item(line_string)



func _on_submit_pressed() -> void:
	if !has_submit:
		has_submit = true
		submit()


func _on_refresh_pressed() -> void:
	refresh()


func _on_timer_timeout() -> void:
	refresh()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_timer_2_timeout() -> void:
	refresh()
