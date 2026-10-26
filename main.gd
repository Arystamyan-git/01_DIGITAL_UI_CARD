extends Control

var name_input: LineEdit
var class_input: OptionButton
var hp_input: SpinBox


func _ready() -> void:
	# Фон окна.
	var background := ColorRect.new()
	background.color = Color("#101827")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	# Контейнер помещает панель в центр окна.
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(440, 380)
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
	column.add_theme_constant_override("separation", 12)
	margin.add_child(column)

	column.add_child(make_label("СОЗДАЙ ГЕРОЯ", 27))
	column.add_child(make_label("Пример UI на Godot 4", 15))

	column.add_child(make_label("Имя персонажа:", 16))
	name_input = LineEdit.new()
	name_input.placeholder_text = "Например, Алекс"
	column.add_child(name_input)

	column.add_child(make_label("Класс:", 16))
	class_input = OptionButton.new()
	class_input.add_item("Воин")
	class_input.add_item("Маг")
	class_input.add_item("Исследователь")
	column.add_child(class_input)

	column.add_child(make_label("Здоровье (1–200):", 16))
	hp_input = SpinBox.new()
	hp_input.min_value = 1
	hp_input.max_value = 200
	column.add_child(hp_input)

	var create_button := Button.new()
	create_button.text = "СОЗДАТЬ ПЕРСОНАЖА"
	create_button.custom_minimum_size.y = 44
	column.add_child(create_button)
	create_button.pressed.connect(_on_create_pressed)


func make_label(value: String, font_size: int) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", font_size)
	return item


func _on_create_pressed() -> void:
	GameData.hero_name = name_input.text.strip_edges()
	if GameData.hero_name.is_empty():
		GameData.hero_name = "Безымянный герой"
	GameData.hero_class = class_input.get_item_text(class_input.selected)
	GameData.hp = int(hp_input.value)
	get_tree().change_scene_to_file("res://result.tscn")
