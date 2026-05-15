## bastion_facility_panel_ui.gd
## Panel lateral que muestra el estado de una facilidad y permite dar órdenes.

extends PanelContainer

# ============================================================
# SEÑALES
# ============================================================
signal order_issued(instance_id: String, order: FacilityData.Order, option_id: String)
signal panel_closed

# ============================================================
# NODOS
# ============================================================
@onready var title_label: Label          = $VBox/Title
@onready var status_label: Label         = $VBox/Status
@onready var result_panel: PanelContainer = $VBox/ResultPanel
@onready var result_label: Label         = $VBox/ResultPanel/Label
@onready var collect_btn: Button         = $VBox/ResultPanel/CollectButton
@onready var orders_container: VBoxContainer = $VBox/OrdersContainer
@onready var close_btn: Button           = $VBox/CloseButton

# ============================================================
# ESTADO
# ============================================================
var _instance: BastionFacilityInstance = null

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	close_btn.pressed.connect(func(): panel_closed.emit(); hide())
	result_panel.hide()

func show_facility(instance: BastionFacilityInstance) -> void:
	_instance = instance
	_rebuild()
	show()

# ============================================================
# UI
# ============================================================

func _rebuild() -> void:
	if _instance == null:
		return

	var data := _instance.facility_data
	title_label.text = data.display_name

	# Estado actual
	if not _instance.is_operational:
		status_label.text = "⚠ Dañada — se repara el próximo turno"
		status_label.add_theme_color_override("font_color", Color(1, 0.4, 0.2))
	elif _instance.missions_remaining > 0:
		status_label.text = "En progreso: %s (%d misión/es restante/s)" % [
			_instance.current_option_id, _instance.missions_remaining
		]
		status_label.add_theme_color_override("font_color", Color(0.8, 0.9, 1))
	else:
		status_label.text = "Lista para recibir órdenes"
		status_label.remove_theme_color_override("font_color")

	# Resultado pendiente
	if _instance.has_result():
		result_panel.show()
		result_label.text = _describe_result(_instance.pending_result)
		collect_btn.pressed.connect(_on_collect_pressed, CONNECT_ONE_SHOT)
	else:
		result_panel.hide()

	# Opciones de órdenes
	for child in orders_container.get_children():
		child.queue_free()

	if _instance.is_operational and _instance.missions_remaining == 0:
		_build_order_buttons(data)

func _build_order_buttons(data: FacilityData) -> void:
	for option in data.order_options:
		# Comprobar requisito de nivel de Bastión
		var req_level: int = option.get("requires_bastion_level", 0)
		if req_level > 0 and BastionManager.bastion_level < req_level:
			continue

		var btn := Button.new()
		btn.text = option.get("name", "Orden")
		btn.tooltip_text = option.get("description", "")
		btn.custom_minimum_size = Vector2(0, 48)

		var order_int: int    = option.get("order", FacilityData.Order.MAINTAIN)
		var option_id: String = option.get("id", "")
		var iid: String       = _instance.instance_id

		btn.pressed.connect(func():
			if BastionManager.issue_order(iid, order_int as FacilityData.Order, option_id):
				order_issued.emit(iid, order_int, option_id)
				_rebuild()
		)
		orders_container.add_child(btn)

# ============================================================
# ACCIONES
# ============================================================

func _on_collect_pressed() -> void:
	if _instance == null:
		return
	var result := _instance.claim_result()
	_apply_result(result)
	_rebuild()

func _apply_result(result: Dictionary) -> void:
	var type: String   = result.get("type", "")
	var option: String = result.get("option", "")
	# Por ahora solo mostramos un bark. Cada tipo de resultado
	# tendrá su lógica específica en iteraciones posteriores.
	EventBus.narrator_bark.emit("Resultado recogido: %s — %s" % [type, option], 3.0)

func _describe_result(result: Dictionary) -> String:
	var type: String   = result.get("type", "")
	var option: String = result.get("option", "")
	match type:
		"harvest":  return "Cosecha lista: %s" % option
		"craft":    return "Fabricación lista: %s" % option
		"research": return "Investigación lista: %s" % option
		"empower":  return "Potenciación lista: %s" % option
		"recruit":  return "Reclutamiento listo: %s" % option
		"trade":    return "Comercio listo: %s" % option
		_:          return "Resultado disponible"
