## facility_data.gd
## Define un tipo de facilidad del Bastión (Biblioteca, Forja, Herbolario, etc.)

class_name FacilityData
extends Resource

enum Order {
	CRAFT,      # Fabricar un objeto
	HARVEST,    # Recolectar un recurso
	RESEARCH,   # Investigar un tema
	EMPOWER,    # Potenciar a un personaje
	RECRUIT,    # Reclutar defensores o NPCs
	TRADE,      # Comprar / vender
	MAINTAIN,   # Solo mantenimiento (no produce nada)
}

enum Space { CRAMPED, ROOMY, VAST }

# ============================================================
# IDENTIDAD
# ============================================================
@export var facility_id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""

# ============================================================
# REQUISITOS
# ============================================================
## Nivel mínimo del Bastión para desbloquear esta facilidad
@export_range(1, 4) var required_bastion_level: int = 1
## Flag de lore o clase requerida (ej: "can_use_spellcasting_focus")
@export var prerequisite_flag: String = ""

# ============================================================
# PROPIEDADES
# ============================================================
@export var space: Space = Space.ROOMY
@export var hireling_count: int = 1
@export var available_orders: Array[int] = [Order.MAINTAIN]

## Coste en oro para construir / añadir al Bastión
@export var build_cost: int = 500
## Días que tarda en construirse (en términos de misiones = build_missions)
@export var build_missions: int = 1

# ============================================================
# OPCIONES DE ÓRDENES
## Cada entrada describe una opción concreta: id, nombre, descripción, efecto
# ============================================================
@export var order_options: Array[Dictionary] = []
