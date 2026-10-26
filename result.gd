extends Control

var hp_label: Label
var hp_bar: ProgressBar
var clock_label: Label


func _ready() -> void:
	var background := ColorRect.new()
	background.color = Color("#101827")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(440, 350)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#26364d")
	style.set_corner_radius_all(14)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var margin := MarginContainer.new()
	for side in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + side, 28)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 16)
	margin.add_child(column)

	column.add_child(make_label("КАРТОЧКА ГЕРОЯ", 27))
	column.add_child(make_label("Имя: " + GameData.hero_name, 20))
	column.add_child(make_label("Класс: " + GameData.hero_class, 20))
	column.add_child(make_label("Уровень: 1", 20))

	hp_label = make_label("", 20)
	column.add_child(hp_label)

	hp_bar = ProgressBar.new()
	hp_bar.max_value = 200
	hp_bar.show_percentage = false
	column.add_child(hp_bar)
	update_hp()

	clock_label = make_label("", 17)
	column.add_child(clock_label)
	update_clock()

	var timer := Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(update_clock)

	var heal_button := Button.new()
	heal_button.text = "Восстановить +10 HP"
	column.add_child(heal_button)
	heal_button.pressed.connect(heal)

	var back_button := Button.new()
	back_button.text = "Назад к настройкам"
	column.add_child(back_button)
	back_button.pressed.connect(go_back)


func make_label(value: String, font_size: int) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", font_size)
	return item


func update_hp() -> void:
	hp_label.text = "Здоровье: %d / 200 HP" % GameData.hp
	hp_bar.value = GameData.hp


func update_clock() -> void:
	clock_label.text = "Текущее время: " + Time.get_time_string_from_system()


func heal() -> void:
	GameData.hp = min(GameData.hp + 10, 200)
	update_hp()


func go_back() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
