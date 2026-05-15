## combat_ui.gd
## HUD de combate completo:
##   - Izquierda: HP y estrés de la party
##   - Abajo: barra de habilidades del personaje activo
##   - Sobre cada enemigo: barra de HP flotante + info si se conoce

extends CanvasLayer

# ============================================================
# NODOS
# ============================================================
@onready var party_panel: VBoxContainer      = $PartyPanel
@onready var ability_bar: HBoxContainer      = $AbilityBar
@onready var active_name: Label              = $AbilityBar/ActiveName
@onready var abilities_container: HBoxContainer = $AbilityBar/Abilities
@onready var move_btn: Button                = $AbilityBar/MoveButton
@onready var end_turn_btn: Button            = $AbilityBar/EndTurnButton
@onready var turn_order_bar: HBoxContainer   = $TurnOrderBar

# ============================================================
# SEÑALES → el CombatManager las escucha
# ============================================================
signal ability_selected(ability: AbilityData)
signal move_mode_toggled(active: bool)
signal end_turn_pressed
signal potion_used

# ============================================================
# ESTADO
# ============================================================
var _active_character: BaseCharacter = null
var _combat_manager: CombatManager   = null
var _move_mode_active: bool          = false
var _enemy_hud_nodes: Dictionary     = {}   # BaseCharacter → Control

# ============================================================
# SETUP
# ============================================================

func setup(combat_manager: CombatManager) -> void:
	_combat_manager = combat_manager
	combat_manager.waiting_for_player_input.connect(_on_player_turn_started)
	combat_manager.combat_ended.connect(_on_combat_ended)
	EventBus.health_changed.connect(_on_health_changed) if false else null
	EventBus.turn_started.connect(_on_turn_started)
	end_turn_btn.pressed.connect(func(): end_turn_pressed.emit())
	move_btn.pressed.connect(_on_move_toggled)
	ability_bar.hide()

## Llama esto una vez al inicio del combate para registrar los personajes.
func register_characters(heroes: Array[BaseCharacter], enemies: Array[BaseCharacter]) -> void:
	_build_party_panel(heroes)
	_build_enemy_huds(enemies)
	_build_turn_order_bar(combat_manager.turn_manager.get_turn_order() if _combat_manager else [])

# ============================================================
# PARTY PANEL (izquierda)
# ============================================================

func _build_party_panel(heroes: Array[BaseCharacter]) -> void:
	for child in party_panel.get_children():
		child.queue_free()

	for hero in heroes:
		var row := _build_party_row(hero)
		party_panel.add_child(row)
		hero.health_changed.connect(func(hp, max_hp):
			_update_party_row(row, hp, max_hp, hero.stats.current_stress, hero.stats.max_stress)
		)
		hero.stress_changed.connect(func(stress, max_stress):
			_update_party_row(row, hero.stats.current_health, hero.stats.max_health, stress, max_stress)
		)

func _build_party_row(hero: BaseCharacter) -> Control:
	var container := VBoxContainer.new()
	container.name = "Row_" + hero.get_display_name()
	container.custom_minimum_size = Vector2(200, 60)

	# Nombre + nivel
	var name_lbl := Label.new()
	name_lbl.name = "NameLabel"
	name_lbl.text = "%s  Nv.%d" % [hero.get_display_name(), hero.data.level if hero.data else 1]
	name_lbl.add_theme_font_size_override("font_size", 11)
	container.add_child(name_lbl)

	# Barra de HP
	var hp_bar := ProgressBar.new()
	hp_bar.name = "HPBar"
	hp_bar.max_value = hero.stats.max_health
	hp_bar.value     = hero.stats.current_health
	hp_bar.custom_minimum_size = Vector2(200, 12)
	hp_bar.add_theme_color_override("font_color", Color(0.2, 0.8, 0.3))
	container.add_child(hp_bar)

	# Barra de estrés
	var stress_bar := ProgressBar.new()
	stress_bar.name = "StressBar"
	stress_bar.max_value = hero.stats.max_stress
	stress_bar.value     = hero.stats.current_stress
	stress_bar.custom_minimum_size = Vector2(200, 8)
	stress_bar.add_theme_color_override("font_color", Color(0.8, 0.4, 0.1))
	container.add_child(stress_bar)

	return container

func _update_party_row(row: Control, hp: int, max_hp: int, stress: int, max_stress: int) -> void:
	var hp_bar    := row.get_node_or_null("HPBar")    as ProgressBar
	var stress_bar := row.get_node_or_null("StressBar") as ProgressBar
	if hp_bar:
		hp_bar.max_value = max_hp
		hp_bar.value     = hp
	if stress_bar:
		stress_bar.max_value = max_stress
		stress_bar.value     = stress

func _on_health_changed(_character: BaseCharacter, _hp: int, _max_hp: int) -> void:
	pass  # Cada fila se conecta directamente al signal de su personaje

# ============================================================
# HUD DE ENEMIGOS (flotante sobre cada sprite)
# ============================================================

func _build_enemy_huds(enemies: Array[BaseCharacter]) -> void:
	for enemy in enemies:
		_create_enemy_hud(enemy)

func _create_enemy_hud(enemy: BaseCharacter) -> void:
	var hud := _build_enemy_hud_node(enemy)
	add_child(hud)
	_enemy_hud_nodes[enemy] = hud

	enemy.health_changed.connect(func(hp, max_hp): _update_enemy_hud(enemy, hp, max_hp))
	enemy.died.connect(func(): _enemy_hud_nodes.get(enemy, Node.new()).queue_free())

func _build_enemy_hud_node(enemy: BaseCharacter) -> Control:
	var container := VBoxContainer.new()
	container.name = "EnemyHUD_" + enemy.get_display_name()

	# Barra de HP (siempre visible)
	var hp_bar := ProgressBar.new()
	hp_bar.name = "HPBar"
	hp_bar.max_value = enemy.stats.max_health
	hp_bar.value     = enemy.stats.current_health
	hp_bar.custom_minimum_size = Vector2(80, 10)
	hp_bar.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
	container.add_child(hp_bar)

	# Nombre (si se conoce el tipo)
	var name_lbl := Label.new()
	name_lbl.name = "NameLabel"
	name_lbl.add_theme_font_size_override("font_size", 9)
	var knowledge := WorldState.enemy_knowledge.get_level(enemy.data.character_id if enemy.data else "")
	name_lbl.text = enemy.get_display_name() if knowledge >= EnemyKnowledge.KnowledgeLevel.SIGHTED else "???"
	container.add_child(name_lbl)

	# Panel de info conocida (visible si conocimiento nivel ≥ FAMILIAR)
	var info_panel := _build_enemy_info_panel(enemy)
	info_panel.name = "InfoPanel"
	container.add_child(info_panel)

	# Posicionar sobre el sprite del enemigo en el mundo
	_anchor_hud_to_character(container, enemy)

	return container

func _build_enemy_info_panel(enemy: BaseCharacter) -> Control:
	var panel := VBoxContainer.new()
	if enemy.data == null:
		return panel

	var enemy_id  := enemy.data.character_id
	var knowledge := WorldState.enemy_knowledge

	if knowledge.get_level(enemy_id) < EnemyKnowledge.KnowledgeLevel.FAMILIAR:
		panel.hide()
		return panel

	# Habilidades conocidas
	var abilities := knowledge.get_known_abilities(enemy_id)
	for ability_id in abilities:
		var lbl := Label.new()
		lbl.text = "⚔ " + abilities[ability_id]
		lbl.add_theme_font_size_override("font_size", 8)
		lbl.add_theme_color_override("font_color", Color(1, 0.8, 0.5))
		panel.add_child(lbl)

	if knowledge.get_level(enemy_id) >= EnemyKnowledge.KnowledgeLevel.STUDIED:
		for res in knowledge.get_known_resistances(enemy_id):
			var lbl := Label.new()
			lbl.text = "🛡 " + res
			lbl.add_theme_font_size_override("font_size", 8)
			lbl.add_theme_color_override("font_color", Color(0.4, 0.8, 1))
			panel.add_child(lbl)
		for weak in knowledge.get_known_weaknesses(enemy_id):
			var lbl := Label.new()
			lbl.text = "⚡ " + weak
			lbl.add_theme_font_size_override("font_size", 8)
			lbl.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
			panel.add_child(lbl)

	return panel

func _anchor_hud_to_character(hud: Control, character: BaseCharacter) -> void:
	# Posicionar el HUD siguiendo al personaje en pantalla
	# Se actualiza en _process
	pass

func _update_enemy_hud(enemy: BaseCharacter, hp: int, max_hp: int) -> void:
	var hud := _enemy_hud_nodes.get(enemy) as Control
	if hud == null:
		return
	var bar := hud.get_node_or_null("HPBar") as ProgressBar
	if bar:
		bar.max_value = max_hp
		bar.value     = hp

func _process(_delta: float) -> void:
	# Actualizar posición de los HUDs de enemigos para que sigan a los sprites
	for enemy in _enemy_hud_nodes:
		var hud := _enemy_hud_nodes[enemy] as Control
		if hud == null or not is_instance_valid(enemy):
			continue
		# Convertir posición del personaje en el mundo a coordenadas de pantalla
		var screen_pos := (enemy as Node2D).get_viewport_transform() * (enemy as Node2D).global_position
		hud.position = screen_pos + Vector2(-40, -80)

# ============================================================
# BARRA DE HABILIDADES (abajo, cambia según el turno)
# ============================================================

func _on_player_turn_started(character: BaseCharacter) -> void:
	_active_character = character
	_build_ability_bar(character)
	ability_bar.show()
	_move_mode_active = false
	_update_move_button()

func _build_ability_bar(character: BaseCharacter) -> void:
	active_name.text = character.get_display_name()

	for child in abilities_container.get_children():
		child.queue_free()

	# Habilidades del personaje
	for ability in character.get_abilities():
		var btn := _build_ability_button(ability, character)
		abilities_container.add_child(btn)

	# Acción de bonus: beber poción si tiene en inventario
	var potion_btn := Button.new()
	potion_btn.text = "🧪 Poción"
	potion_btn.custom_minimum_size = Vector2(90, 52)
	potion_btn.pressed.connect(func(): potion_used.emit())
	abilities_container.add_child(potion_btn)

	# Esconderse (acción de bonus)
	var hide_btn := Button.new()
	hide_btn.text = "👁 Esconder"
	hide_btn.custom_minimum_size = Vector2(100, 52)
	hide_btn.tooltip_text = "Acción de bonus. Tirada de Sigilo vs Percepción pasiva de enemigos."
	abilities_container.add_child(hide_btn)

func _build_ability_button(ability: AbilityData, character: BaseCharacter) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(110, 52)

	# Mostrar nombre y tipo de tirada
	var type_str := _ability_type_string(ability)
	btn.text = "%s\n%s" % [ability.display_name, type_str]
	btn.tooltip_text = ability.description

	# Desactivar si el personaje ya actuó
	btn.disabled = not character.can_act()

	btn.pressed.connect(func():
		ability_selected.emit(ability)
		_disable_all_abilities()
	)
	return btn

func _ability_type_string(ability: AbilityData) -> String:
	match ability.ability_type:
		AbilityData.AbilityType.ATTACK:
			return "Ataque %s" % ability.attack_ability.to_upper()
		AbilityData.AbilityType.SPELL_ATTACK:
			return "Conjuro %s" % ability.attack_ability.to_upper()
		AbilityData.AbilityType.SAVING_THROW:
			return "Sal. %s CD%d" % [ability.save_ability.to_upper(), ability.save_dc]
		AbilityData.AbilityType.HEAL:
			return "Curación"
		AbilityData.AbilityType.BUFF:
			return "Buff"
		AbilityData.AbilityType.DEBUFF:
			return "Debuff"
		_: return ""

func _disable_all_abilities() -> void:
	for child in abilities_container.get_children():
		if child is Button:
			child.disabled = true

func _on_move_toggled() -> void:
	_move_mode_active = not _move_mode_active
	move_mode_toggled.emit(_move_mode_active)
	_update_move_button()

func _update_move_button() -> void:
	if _active_character == null:
		return
	var tiles_left := _active_character.tiles_remaining()
	move_btn.text   = "Mover (%d cas.)" % tiles_left
	move_btn.modulate = Color(0.4, 1, 0.4) if _move_mode_active else Color(1, 1, 1)
	move_btn.disabled = tiles_left == 0

# ============================================================
# BARRA DE ORDEN DE TURNO (arriba)
# ============================================================

func _build_turn_order_bar(order: Array[BaseCharacter]) -> void:
	for child in turn_order_bar.get_children():
		child.queue_free()
	for character in order:
		var icon := ColorRect.new()
		icon.size = Vector2(32, 32)
		icon.color = Color(0.3, 0.5, 0.9) if character.is_hero else Color(0.9, 0.3, 0.3)
		var lbl := Label.new()
		lbl.text = character.get_display_name().substr(0, 2)
		lbl.add_theme_font_size_override("font_size", 9)
		lbl.position = Vector2(2, 8)
		icon.add_child(lbl)
		turn_order_bar.add_child(icon)

func _on_turn_started(character: BaseCharacter) -> void:
	# Resaltar en la barra de orden quién está actuando
	var i := 0
	for child in turn_order_bar.get_children():
		var col := Color(1, 1, 0.4) if i == 0 else (Color(0.3, 0.5, 0.9) if character.is_hero else Color(0.9, 0.3, 0.3))
		if child is ColorRect:
			child.color = col
		i += 1

# ============================================================
# FINAL DE COMBATE
# ============================================================

func _on_combat_ended(_victory: bool) -> void:
	ability_bar.hide()

# ============================================================
# INTEGRACIÓN CON EL CONOCIMIENTO DE ENEMIGOS
# ============================================================

## Llama esto desde CombatManager cuando un enemigo usa una habilidad.
func reveal_enemy_ability(enemy: BaseCharacter, ability: AbilityData) -> void:
	if enemy.data == null:
		return
	WorldState.enemy_knowledge.reveal_ability(
		enemy.data.character_id,
		ability.ability_id,
		ability.display_name
	)
	# Reconstruir el panel de info de ese enemigo
	var hud := _enemy_hud_nodes.get(enemy) as Control
	if hud:
		var old_panel := hud.get_node_or_null("InfoPanel")
		if old_panel:
			old_panel.queue_free()
		var new_panel := _build_enemy_info_panel(enemy)
		new_panel.name = "InfoPanel"
		hud.add_child(new_panel)
