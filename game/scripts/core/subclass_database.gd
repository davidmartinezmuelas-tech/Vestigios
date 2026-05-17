## subclass_database.gd
## Base de datos de subclases D&D 2024 con nombres y lore de Vestigios.
## Autoload. Uso: SubclassDatabase.get_subclass("juramento_vida")
##
## Los NOMBRES son originales de Vestigios. Las MECÃNICAS son equivalentes D&D 2024.
## Cada subclase tiene su lore integrado en el mundo del juego.

extends Node

var _subclasses: Dictionary = {}

func _ready() -> void:
	_register_all()

# ============================================================
# API PÚBLICA
# ============================================================

func get_subclass(subclass_id: String) -> Dictionary:
	return _subclasses.get(subclass_id, {})

func get_subclasses_for_class(class_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for id in _subclasses:
		if _subclasses[id].get("class_id") == class_id:
			result.append(_subclasses[id])
	return result

func get_feature(subclass_id: String, level: int) -> Array[Dictionary]:
	return _subclasses.get(subclass_id, {}).get("features", {}).get(level, [])

func get_always_prepared_spells(subclass_id: String) -> Array[String]:
	return _subclasses.get(subclass_id, {}).get("always_prepared", [])

# ============================================================
# REGISTRO
# ============================================================

func _register_all() -> void:
	_reg_paladin_subclasses()
	_reg_bardo_subclasses()
	_reg_guerrero_subclasses()
	_reg_explorador_subclasses()
	_reg_picaro_subclasses()
	_reg_monje_subclasses()
	_reg_barbaro_subclasses()
	_reg_hechicero_subclasses()
	_reg_brujo_subclasses()
	_reg_clerigo_subclasses()
	_reg_druida_subclasses()
	_reg_mago_subclasses()

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# PALADÃN — JURAMENTOS
# Niveles de rasgo: 3, 7, 15, 20
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_paladin_subclasses() -> void:

	## JURAMENTO DE LA VIDA (= Juramento de los Antiguos)
	## Vael es el paradigma. Paladines elegidos por El Antiguo de la Vida.
	## Su cicatriz detecta la Corrupción — y el Juramento los compromete a erradicarla.
	_s("juramento_vida", "Juramento de la Vida", "paladin",
		"Elegido por El Antiguo de la Vida. Tu cicatriz late ante la Corrupción. Proteger lo vivo es tu ley — no importa el coste.",
		["curar_heridas", "heroismo", "hablar_con_los_animales", "luz_del_dia", "restauracion_mayor"],
		{
			3: [
				_f("encadenamiento_luz", "Encadenamiento de Luz",
					"Canalizar Divinidad: criaturas hostiles en 9m quedan Apresadas (no infernales/muertos vivientes).",
					"action", "short", "channel_divinity"),
				_f("magia_vida", "Magia de la Vida",
					"Conjuros de la Vida siempre preparados. Lanzar curación cuenta como magia de combate.",
					"none", "none", ""),
			],
			7: [
				_f("presencia_antigua", "Presencia de la Vida",
					"Tus aliados en el aura son inmunes a veneno y enfermedad. Tú regeneras 1 PG por turno.",
					"none", "none", ""),
			],
			15: [
				_f("guardian_eterno", "Guardián Eterno",
					"Al caer a 0 PG: una vez puedes quedar a 1 PG en lugar de caer. Se recarga al amanecer.",
					"none", "long", ""),
			],
			20: [
				_f("avatar_vida", "Avatar de la Vida",
					"1/día: te transformas 1 min. +10 CA; ataques hacen +1d8 radiante; aliados en aura recuperan 1d6 PG/turno.",
					"action", "long", ""),
			],
		}
	)

	## JURAMENTO DEL FARO (= Juramento de Entrega/Devotion)
	## Los Cinco Pilares de Velthar los llaman así: los que mantienen el faro encendido
	## cuando el mundo se oscurece. Luz contra Corrupción.
	_s("juramento_faro", "Juramento de Tordran", "paladin",
		"Los guardianes de Velthar que mantienen encendida la llama de la civilización. " + "Aldric los usa como escudo. Algunos no saben que el rey también es una amenaza.",
		["proyectil_magico", "heroismo", "luz", "luz_del_dia", "ojo_de_aguila"],
		{
			3: [
				_f("arma_sagrada_faro", "Arma del Faro",
					"Canalizar Divinidad: bonus action, tu arma emite luz 6m y +CHA a tiradas de ataque 1min.",
					"bonus", "short", "channel_divinity"),
				_f("expulsar_profanos", "Expulsar lo Profano",
					"Canalizar Divinidad: muertos vivientes e infernales en 9m hacen SAB save o huyen 1 min.",
					"action", "short", "channel_divinity"),
			],
			7: [
				_f("aura_devota", "Aura Devota",
					"Aliados en el aura no pueden ser Hechizados. Tienes ventaja en saves vs Hechizado.",
					"none", "none", ""),
			],
			15: [
				_f("pureza_del_faro", "Pureza del Faro",
					"Eres inmune a Hechizado. Cuando eres Hechizado puedes repetir el save inmediatamente.",
					"none", "none", ""),
			],
			20: [
				_f("nimbo_sagrado", "Nimbo Sagrado",
					"1/día: aura 9m 1 min; infernales/muertos vivientes: SAB save cada turno o Asustados; +10 daño radiante.",
					"action", "long", ""),
			],
		}
	)

	## JURAMENTO DE LA BALANZA (= Juramento de Venganza)
	## Cazadores de Corrupción que actúan fuera de la ley de Velthar cuando la ley no basta.
	## Conocen a Maerek Solden mejor que sus propios hombres.
	_s("juramento_tejedora", "Juramento de la Tejedora", "paladin",
		"La justicia que la ley no puede dar. Operan en las sombras de Velthar. " + "Saben que Maerek no es el villano que parece — y eso los complica.",
		["manos_ardientes", "hechizar_persona", "sugesion", "disipar_magia", "miedo"],
		{
			3: [
				_f("escrutinio_juez", "Escrutinio del Juez",
					"Canalizar Divinidad: marca 1 objetivo 1 min. Ventaja en ataques vs él, no se beneficia de invisibilidad.",
					"bonus", "short", "channel_divinity"),
				_f("voto_enemistad", "Voto de Enemistad",
					"Canalizar Divinidad: ventaja en tiradas de ataque vs 1 criatura 10 min.",
					"bonus", "short", "channel_divinity"),
			],
			7: [
				_f("persecucion_implacable", "Persecución Implacable",
					"Si el marcado te ve, no puede ocultarse. Sabes siempre dónde está en 18m.",
					"none", "none", ""),
			],
			15: [
				_f("alma_del_justiciero", "Alma del Justiciero",
					"Cuando matas una criatura: recuperas tantos PG como tu nivel de paladín.",
					"none", "none", ""),
			],
			20: [
				_f("angel_sentencia", "Ãngel de la Sentencia",
					"1/día: alas 1 hora; +2 AC; ataques hacen 2d8 radiante extra; puedes lanzar Baneo sin espacio.",
					"action", "long", ""),
			],
		}
	)

	## JURAMENTO DE GLORIA (= Juramento de Gloria)
	## Los campeones ceremoniales de Velthar. Los Pilares los admiran. El rey los exhibe.
	## Algunos empiezan a cuestionar si la gloria de Velthar justifica sus métodos.
	_s("juramento_gloria", "Juramento de Gloria", "paladin",
		"Los campeones del Rey. La cara visible de Velthar en los campos de batalla. " + "Bofri Ironmantle los equipa. Erevan los adorna. Aldric los usa.",
		["heroismo", "prestidigitacion", "velocidad", "libertad_de_movimiento", "globo_vigilante"],
		{
			3: [
				_f("inspiracion_heroica", "Inspiración Heroica",
					"Canalizar Divinidad: hasta 6 aliados que te oigan ganan PG temporales = tu CHA + nivel.",
					"action", "short", "channel_divinity"),
				_f("plenitud_de_accion", "Plenitud de Acción",
					"Canalizar Divinidad: bonus action, rompes Aturdido/Paralizado/Petrificado de aliado.",
					"bonus", "short", "channel_divinity"),
			],
			7: [
				_f("aura_aliento", "Aura del Campeón",
					"Aliados en el aura tienen velocidad +3m y ventaja en checks de Atletismo.",
					"none", "none", ""),
			],
			15: [
				_f("figura_mitica", "Figura Mítica",
					"No puedes ser Asustado. Cuando un aliado falla un save vs miedo, puede repetirlo.",
					"none", "none", ""),
			],
			20: [
				_f("apoteosis_gloriosa", "Apoteosis Gloriosa",
					"1/día: 1 hora; velocidad doble; inmunidad condiciones; cuando matas, aliados ganan 1d4 a ataques hasta tu siguiente turno.",
					"action", "long", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# BARDO — COLEGIOS
# Niveles de rasgo: 3, 6, 14
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_bardo_subclasses() -> void:

	## COLEGIO DE ILVERNIS (= Colegio del Conocimiento)
	## Los bardos que buscan verdades ocultas. No estudian en La Aguja — la buscan.
	## El conocimiento que más importa es el que alguien decidió que no debías tener.
	_s("colegio_ilvernis", "Colegio de Ilvernis", "bardo",
		"La Aguja de Marfil no forma a sus bardos "" los atrae. " + "Quienes siguen esta tradición llegaron solos al conocimiento, buscando lo que se les negó.",
		[],
		{
			3: [
				_f("palabras_cortantes", "Palabras Cortantes",
					"Bonus action: imponer -1d6 a una tirada de ataque, salvación o check de una criatura (ya hecha). 1/turno.",
					"bonus", "none", "bardic_inspiration"),
				_f("secretos_adicionales", "Secretos de Ilvernis",
					"Aprende 3 conjuros de cualquier lista de clase que no sean de bardo.",
					"none", "none", ""),
			],
			6: [
				_f("funcion_extra_ilvernis", "Función Extra",
					"Puedes usar la Inspiración Bárdica para darte el dado a ti mismo.",
					"none", "none", ""),
			],
			14: [
				_f("capacidad_inesperada", "Capacidad Inesperada",
					"Al usar Palabras Cortantes: si la criatura falla la tirada, también queda Aturdida hasta inicio de su turno.",
					"none", "none", ""),
			],
		}
	)

	## COLEGIO DE MIRSEL (= Colegio de la Danza)
	## Los bardos viajeros de la tradición de Mirsel los Siete Mares. JOHANNES.
	## Nacen en movimiento. Algunos trabajan para Calder Reth sin saberlo.
	_s("colegio_mirsel", "Colegio de Mirsel", "bardo",
		"Johannes creció en una caravana. Aprendió que moverse es sobrevivir "" " + "y que la música es lo único que no te pueden quitar cuando no tienes nada más.",
		[],
		{
			3: [
				_f("danza_esquiva", "Danza Esquiva",
					"No provocas ataques de oportunidad. Bonus: moverte hasta tu velocidad sin gastar movimiento.",
					"bonus", "none", "bardic_inspiration"),
			],
			6: [
				_f("magia_cinetica", "Magia Cinética",
					"Cuando lanzas conjuro de bonus action, puedes moverte hasta tu velocidad antes o después.",
					"none", "none", ""),
			],
			14: [
				_f("flujo_perpetuo", "Flujo Perpetuo",
					"Cuando eres golpeado: puedes moverte hasta la mitad de tu velocidad como reacción sin AoO.",
					"reaction", "none", ""),
			],
		}
	)

	## COLEGIO DEL ESPEJO (= Colegio del Glamour)
	## Los bardos que sirven a los poderosos usando ilusión y encantamiento.
	## Vaela Mirage (Cadena 6) vino de aquí — o de algo peor.
	_s("colegio_selven", "Colegio de Selven el Oculto", "bardo",
		"Vaela Mirage fue su alumna más brillante. O quizás la crearon ellos. " + "La diferencia entre una ilusión perfecta y la realidad es solo perspectiva.",
		[],
		{
			3: [
				_f("presencia_mantle", "Presencia del Espejo",
					"Cuando usas Inspiración Bárdica: también otorgas PG temporales = dado bárdico + CAR.",
					"bonus", "none", "bardic_inspiration"),
				_f("aspecto_onirico", "Aspecto Onírico",
					"Bonus action: hasta 5 criaturas en 18m quedan Hechizadas o Asustadas 1 turno (SAB save).",
					"bonus", "long", ""),
			],
			6: [
				_f("refugio_miradas", "Refugio de Miradas",
					"Bonus action: otorga ventaja en saves vs Hechizado/Asustado a aliados hasta inicio tu turno.",
					"bonus", "none", ""),
			],
			14: [
				_f("espejo_de_almas", "Espejo de Almas",
					"Puedes usar Palabras Cortantes de Glamour sobre ti mismo como reacción al ser atacado.",
					"reaction", "none", "bardic_inspiration"),
			],
		}
	)

	## COLEGIO DE LOS CINCO PILARES (= Colegio del Valor)
	## Bardos militares de Velthar que inspiran tropas en campaña.
	## Han cantado en las batallas contra Kethara durante décadas.
	_s("colegio_cinco_pilares", "Colegio de los Cinco Pilares", "bardo",
		"Cantan en los frentes de guerra de Velthar. Sus baladas mueven ejércitos. " + "Erevan Duskwhisper (Pilar 1) fue uno de ellos antes de ascender.",
		[],
		{
			3: [
				_f("inspiracion_combate", "Inspiración de Combate",
					"La Inspiración Bárdica puede añadirse a tiradas de daño o de AC (reacción vs ataque).",
					"none", "none", "bardic_inspiration"),
				_f("competencia_extra_valor", "Competencia de Combate",
					"Ganas competencia con escudos y armaduras medias.",
					"none", "none", ""),
			],
			6: [
				_f("ataque_extra_bardo", "Ataque Adicional",
					"2 ataques al usar la acción de atacar.",
					"none", "none", ""),
			],
			14: [
				_f("armadura_magica_bardo", "Armadura Mágica",
					"Puedes conjurar armaduras mágicas para ti y tus aliados con tu Inspiración.",
					"bonus", "none", "bardic_inspiration"),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# GUERRERO — ARQUETIPO
# Niveles de rasgo: 3, 7, 10, 15, 18
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_guerrero_subclasses() -> void:

	## SENDA DEL ARCO ANTIGUO (= Ãrbol del Mundo / Bárbaro, o Campeón adaptado)
	## BICHO lleva el Arco Antiguo. Este arquetipo de guerrero canaliza energía antigua
	## sin necesitar acceso a conjuros. El arma es el canal.
	_s("arco_antiguo_guerrero", "Portador del Arco Antiguo", "guerrero",
		"Bicho no eligió este camino. El arco lo eligió a él. Ahora cada golpe resuena " + "con algo que no es exactamente magia — es más antiguo que eso.",
		[],
		{
			3: [
				_f("critico_mejorado", "Resonancia Antigua",
					"Crítico con 19-20 (en lugar de solo 20). El arco amplifica tu instinto.",
					"none", "none", ""),
				_f("combatiente_sobresaliente", "Combatiente Sobresaliente",
					"Cuando atacas, tienes ventaja en 1 tirada de ataque por turno.",
					"none", "none", ""),
			],
			7: [
				_f("aguante_extraordinario", "Aguante Extraordinario",
					"Cuando recibes daño y tienes más de 1 PG, puedes reducirlo a 1. 1/descanso largo.",
					"reaction", "long", ""),
			],
			10: [
				_f("critico_19_20", "Filo del Arco",
					"Crítico con 18-20. El arma conoce el punto débil de todo.",
					"none", "none", ""),
			],
			15: [
				_f("golpe_certero_campeon", "Golpe Certero",
					"Si fallas una tirada de ataque, puedes gastar Inspiración Heroica para repetirla.",
					"none", "none", ""),
			],
			18: [
				_f("critico_18_20_camp", "Resonancia Máxima",
					"Crítico con 17-20. En zonas de Corrupción: el daño del crítico ignora resistencias.",
					"none", "none", ""),
			],
		}
	)

	## MAESTRE DE ARMAS DE VELTHAR (= Maestro del Combate)
	## Los instructores de las academias de Velthar. Bofri Ironmantle los aprecia.
	_s("maestre_armas_velthar", "Maestre de Armas de Velthar", "guerrero",
		"Las academias militares de Velthar producen los mejores combatientes del mundo conocido. " + "Un Maestre sabe que toda pelea tiene solución técnica.",
		[],
		{
			3: [
				_f("maniobras_combate", "Maniobras de Combate",
					"4 maniobras de combate a elección (dados de superioridad d8, escala con nv).",
					"none", "none", ""),
				_f("dados_superioridad", "Dados de Superioridad",
					"4 dados d8 de superioridad. Se recuperan en descanso corto o largo.",
					"none", "short", ""),
			],
			7: [
				_f("conoce_tu_enemigo", "Conoce tu Enemigo",
					"Tras 1 min observando: el DM te dice si un objetivo supera, iguala o está por debajo en 2 estadísticas.",
					"none", "none", ""),
			],
			10: [
				_f("maniobras_extra_maestre", "Maniobras Adicionales",
					"2 maniobras más. Dados d10 ahora.",
					"none", "none", ""),
			],
			15: [
				_f("implacable_maestre", "Implacable",
					"Al usar Indomable, puedes compartir el resultado con hasta 3 aliados que también fallaron ese save.",
					"none", "none", ""),
			],
			18: [
				_f("maestria_combate_suprema", "Maestría Suprema",
					"Cuando usas Indomable, ganas 1 dado de superioridad gratis hasta inicio de tu siguiente turno.",
					"none", "none", ""),
			],
		}
	)

	## CABALLERO DE LA AGUJA (= Caballero Arcano)
	## Los guardianes de la Aguja de Marfil en Ilvernis. Arcano + acero.
	## Algunos sospechan que hay algo más que conocimiento bajo la torre.
	_s("caballero_aguja", "Caballero de la Aguja", "guerrero",
		"Ilvernis tiene sus propios guerreros. No los envía a la guerra — los usa para " + "proteger lo que hay bajo la Aguja. Nadie pregunta qué es exactamente.",
		[],
		{
			3: [
				_f("lanzamiento_conjuros_cab", "Lanzamiento de Conjuros",
					"Conjuros de mago usando INT. 2 trucos, espacios limitados (ver tabla Caballero Arcano).",
					"none", "long", "spell_slot"),
				_f("vínculo_arma", "Vínculo de Arma",
					"Crea vínculo con 2 armas. Nunca las pierdes involuntariamente. Las invocas como bonus action.",
					"bonus", "none", ""),
			],
			7: [
				_f("magia_de_guerra", "Magia de Guerra",
					"Cuando lanzas un conjuro como acción: bonus action para hacer 1 ataque de arma.",
					"bonus", "none", ""),
			],
			10: [
				_f("carga_arcana", "Carga Arcana",
					"Al usar Acción Súbita: puedes lanzar conjuro en lugar de 1 de los ataques adicionales.",
					"none", "none", ""),
			],
			15: [
				_f("golpe_arcano", "Golpe Arcano",
					"Una vez por turno: al golpear con arma vinculada, el objetivo hace INT save o queda bajo 1 de tus conjuros.",
					"none", "none", ""),
			],
			18: [
				_f("maestria_magia_guerra", "Maestría de Magia de Guerra",
					"Cuando lanzas conjuro como acción: puedes hacer un ataque COMPLETO (todas tus tiradas) como bonus action.",
					"bonus", "none", ""),
			],
		}
	)

	## ADEPTO DE LAS PROFUNDIDADES (= Guerrero Psiónico)
	## Las Profundidades tienen campeones involuntarios. No todos lo saben.
	## El conocimiento arcano de Las Profundidades filtra de formas inesperadas.
	_s("camino_orvyn", "Camino de Orvyn el Sordo", "guerrero",
		"Las Profundidades actúan sin campeones directos — pero su influencia se filtra. " + "Algunos guerreros descubren que su mente hace cosas que el cuerpo no debería poder.",
		[],
		{
			3: [
				_f("poder_psionico", "Poder de las Profundidades",
					"Energía Psiónica: d6 dados (escala). Úsalos para proteger aliados, dañar o moverte.",
					"none", "short", ""),
				_f("impacto_psionico", "Impacto Psiónico",
					"Añadir 1 dado de Energía Psiónica al daño 1Óturno. El daño es psíquico.",
					"none", "none", ""),
			],
			7: [
				_f("paso_telepatico", "Paso Telepático",
					"Bonus action: teletransportarte hasta 9m a un espacio visible. Gasta 1 dado de Energía.",
					"bonus", "none", ""),
			],
			10: [
				_f("guardia_mental", "Guardia Mental",
					"Inmunidad a Hechizado. Ventaja en saves vs efectos mentales.",
					"none", "none", ""),
			],
			15: [
				_f("torrente_telepatico", "Torrente Telepático",
					"Cuando usas Impacto: objetivo hace INT save o queda Aturdido hasta inicio de tu siguiente turno.",
					"none", "none", ""),
			],
			18: [
				_f("maestria_psionico", "Maestría de las Profundidades",
					"Los dados de Energía pasan a d12. Recuperas 1 dado al inicio de cada turno.",
					"none", "none", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# EXPLORADOR — ARQUETIPO
# Niveles de rasgo: 3, 7, 11, 15
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_explorador_subclasses() -> void:

	## CAZADOR DE CORRUPCIÃ"N (= Acechador en la Penumbra)
	## LYTH. La Iglesia de Cazadores de Meredan. Entrenan para rastrear lo que
	## la Corrupción de Kethara crea. Garreth Ashveil es el objetivo máximo.
	_s("senda_kolvek", "Senda de Kolvek", "explorador",
		"Kolvek el Primero fundó la Iglesia de Cazadores de Meredan hace 500 años. " + "Sus tres principios: Rastrear, Evaluar, Decidir. El tercero sigue siendo debatido.",
		[],
		{
			3: [
				_f("susurro_sombras", "Susurro de las Sombras",
					"Bonus: te ocultas aunque solo tengas cobertura media. Siempre puedes esconderte si solo eres visto por 1.",
					"bonus", "none", ""),
				_f("golpe_sombra", "Golpe de Sombra",
					"1 vez/turno: si atacas desde oculto, el golpe hace +3d6 daño extra (tipo del arma).",
					"none", "none", ""),
			],
			7: [
				_f("acecho_fantasmal", "Acecho Fantasmal",
					"Puedes ocultarte en cualquier luz tenue o oscuridad como bonus action. Gastar 1 uso de Marca.",
					"bonus", "none", "favored_enemy_uses"),
			],
			11: [
				_f("vision_oscura_corrupcion", "Visión de Corrupción",
					"Visión en la oscuridad 36m. Puedes ver a través de la magia oscura de la Corrupción.",
					"none", "none", ""),
			],
			15: [
				_f("emboscada_cazador", "Emboscada del Cazador",
					"Al inicio del combate si estás oculto: tienes ventaja en todas las tiradas de ataque del primer turno.",
					"none", "none", ""),
			],
		}
	)

	## EXPLORADOR DE FRONTERA (= Cazador)
	## Los soldados fronterizos de Velthar. Conocen cada paso de montaña entre los reinos.
	_s("centinelas_aldren", "Centinelas de Aldren", "explorador",
		"Los ojos de Velthar más allá de sus muros. Saben cuándo los ejércitos de Kethara se mueven " + "antes de que las capitales lo descubran.",
		[],
		{
			3: [
				_f("presa_cazador", "Presa del Cazador",
					"Cuando golpeas a tu Marca: +1d6 extra. Alternatively: Barrera de Acero (reducir daño a ti 1d6+SAB).",
					"none", "none", ""),
			],
			7: [
				_f("defensas_tacticas", "Defensas Tácticas",
					"Cuando un aliado visible muere: tiras inmediatamente 1 ataque vs el responsable como reacción.",
					"reaction", "none", ""),
			],
			11: [
				_f("asalto_multiple", "Asalto Múltiple",
					"Cuando usas Extra Attack: uno de los ataques puede apuntar a un objetivo diferente sin coste.",
					"none", "none", ""),
			],
			15: [
				_f("escapada_superior", "Escapada Superior",
					"Si estás Apresado o Agarrado, puedes esconderte antes de escapar. Sin AoO al hacerlo.",
					"none", "none", ""),
			],
		}
	)

	## ECO DEL BOSQUE (= Errante Feérico)
	## Los exploradores que han pasado demasiado tiempo en los Bosques sin Nombre
	## cerca de Kethara. Algo cambió en ellos. No del todo para mal.
	_s("senda_bosque_gris", "Senda del Bosque Gris", "explorador",
		"Los Bosques sin Nombre al norte de Kethara tienen memoria. Los exploradores " + "que los atraviesan demasiadas veces regresan... diferentes.",
		["hechizar_persona", "paso_brumoso", "confusion", "mayor_invisibilidad"],
		{
			3: [
				_f("magia_ferica_eco", "Magia del Eco",
					"Aprendes Hechizar Persona y otro conjuro de encantamiento/ilusión de nivel 1 o 2.",
					"none", "none", ""),
				_f("risa_ferica", "Risa del Eco",
					"Bonus action: una criatura a 18m hace SAB save o queda incapacitada de risa hasta inicio de tu siguiente turno.",
					"bonus", "short", ""),
			],
			7: [
				_f("presencia_desplazada", "Presencia Desplazada",
					"Advantage en el primer ataque de cada combate. Los enemigos que fallan vs ti quedan Asustados 1 turno.",
					"none", "none", ""),
			],
			11: [
				_f("paso_bosque", "Paso del Bosque",
					"Puedes usar Desplazamiento Feérico como bonus action 2Ódescanso largo.",
					"bonus", "long", ""),
			],
			15: [
				_f("mente_inescrutable", "Mente Inescrutable",
					"Inmunidad a Hechizado. Ventaja en saves vs ilusiones. Puedes ver Invisibilidad 9m.",
					"none", "none", ""),
			],
		}
	)

	## VINCULADO A LA VIDA (= Señor de las Bestias)
	## Los que sienten el murmullo de El Antiguo de la Vida y lo expresan
	## a través del vínculo con criaturas. Vael lo siente diferente — estos lo viven.
	_s("senda_tavar", "Senda de Tavar la Primera", "explorador",
		"El Antiguo de la Vida habla en ecos. Algunos exploradores aprenden a escuchar " + "esos ecos en las bestias que los rodean. No es magia — es parentesco.",
		[],
		{
			3: [
				_f("companero_bestia", "Compañero de la Vida",
					"Tienes un compañero animal (bestia VD â‰¤ nivel/4). Actúa en tu turno, usa tus stats de salvación.",
					"none", "none", ""),
			],
			7: [
				_f("vinculo_excepcional", "Vínculo Excepcional",
					"Tu compañero puede atacar 2 veces y tiene PG máximos = sus PG + 5Ó tu nivel.",
					"none", "none", ""),
			],
			11: [
				_f("bestia_mitica", "Bestia Mítica",
					"Tu compañero gana +2 a tiradas de ataque y daño. Sus golpes son mágicos.",
					"none", "none", ""),
			],
			15: [
				_f("union_total", "Unión Total",
					"Puedes ver y oír a través de tu compañero (acción). Mientras lo haces, puedes lanzar conjuros.",
					"action", "none", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# PÃCARO — ARQUETIPO
# Niveles de rasgo: 3, 9, 13, 17
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_picaro_subclasses() -> void:

	## AGENTE DE LA IGLESIA (= Asesino)
	## Los operativos de la Iglesia de Cazadores de Meredan que no cazan con arco.
	## Alderich los conoce. Gideon los respeta. Algunos trabajan para Calder Reth.
	_s("agente_iglesia", "Agente de la Iglesia", "picaro",
		"La Iglesia de Cazadores tiene dos ramas: los que rastrean y los que eliminan. " + "Los agentes aprenden que a veces la misericordia no existe.",
		[],
		{
			3: [
				_f("maestria_disfraces", "Maestría de Disfraces",
					"Competencia en útiles de disfraz. Crear disfraz completo en 1 min. Nadie lo detecta sin magia.",
					"none", "none", ""),
				_f("maestria_venenos_ag", "Maestría en Venenos",
					"Competencia en útiles de envenenador. Fabricar venenos en descanso corto. Resistencia al veneno.",
					"none", "none", ""),
				_f("sorpresa_mortal", "Sorpresa Mortal",
					"En primer turno de combate: Ataque Furtivo automático sin importar ventaja.",
					"none", "none", "sneak_attack_dice"),
			],
			9: [
				_f("infiltrado_habil", "Infiltrado Hábil",
					"Crear identidad falsa completa en 7 días. Prueba CAR te permite asumir personalidad NPC.",
					"none", "none", ""),
			],
			13: [
				_f("impostores_maestros", "Impostor Maestro",
					"Al atacar a alguien sorprendido o que no te ha visto atacar antes: crítico automático.",
					"none", "none", ""),
			],
			17: [
				_f("golpe_de_muerte", "Golpe de Muerte",
					"Al golpear criatura paralizada o inconsciente: duplicar el dado de daño del arma (no Ataque Furtivo).",
					"none", "none", ""),
			],
		}
	)

	## CONTRABANDISTA DE MEREDAN (= Ladrón)
	## Los mejores dedos de la ciudad portuaria. Trabajan para Calder Reth o independientemente.
	## Johannes conoce a algunos de ellos. Sela también.
	_s("contrabandista_meredan", "Contrabandista de Meredan", "picaro",
		"Meredan tiene dos economías: la visible y la que mueve Calder Reth. " + "Los contrabandistas conocen ambas y no sirven a ninguna — salvo al oro.",
		[],
		{
			3: [
				_f("manos_rapidas", "Manos Rápidas",
					"Bonus action: Prestidigitación, robar objeto, usar herramienta o abrir cerradura.",
					"bonus", "none", ""),
				_f("escalar_rapido", "Escalar Rápido",
					"Subir no cuesta movimiento extra. Esconderse en descanso corto no requiere acción.",
					"none", "none", ""),
			],
			9: [
				_f("uso_magico_supremo", "Uso Mágico",
					"Puedes usar objetos mágicos que normalmente requieren habilidades que no tienes.",
					"none", "none", ""),
			],
			13: [
				_f("reflejos_ladrón", "Reflejos del Contrabandista",
					"En el primer turno de combate: puedes actuar dos veces (turno 1 en iniciativa + turno fantasma).",
					"none", "none", ""),
			],
			17: [
				_f("ladrón_de_almas", "Ladrón de Todo",
					"Cuando usas Manos Rápidas en combate: puedes robar 1 objeto equipado sin tirada si ya atacaste.",
					"none", "none", ""),
			],
		}
	)

	## DISCÃPULO DE ARCANIS (= Embaucador Arcano)
	## Los estudiantes de segunda categoría de la Aguja de Marfil que no llegaron a magos
	## pero encontraron otro camino. Más peligrosos de lo que parecen.
	_s("discipulo_ilvernis_pic", "Discípulo de Ilvernis", "picaro",
		"No todos los que estudian en Ilvernis acaban siendo magos. " + "Algunos aprenden que es más útil saber cuándo lanzar que cómo hacerlo.",
		[],
		{
			3: [
				_f("lanzamiento_conjuros_pic", "Lanzamiento de Conjuros",
					"Trucos: Mano de Mago + 2 trucos de mago. Conjuros de mago de nv1-2 (tabla Embaucador).",
					"none", "long", "spell_slot"),
				_f("mano_mago_pic", "Mano Arcana",
					"Mano de Mago invisible. Usarla en combate como Bonus action. Distancia 18m.",
					"bonus", "none", ""),
			],
			9: [
				_f("emboscada_magica", "Emboscada Mágica",
					"Si estás oculto al lanzar conjuro: el objetivo tiene desventaja en el save.",
					"none", "none", ""),
			],
			13: [
				_f("versatilidad_magica", "Versatilidad Mágica",
					"Puedes cambiar 1 truco y 1 conjuro preparado tras cada descanso largo.",
					"none", "none", ""),
			],
			17: [
				_f("ladrón_hechizos", "Ladrón de Hechizos",
					"Reacción: cuando fallas una tirada de salvación vs conjuro, puedes 'robar' el conjuro 1 vez.",
					"reaction", "long", ""),
			],
		}
	)

	## PORTADOR DEL VACÃO (= Rebanaalmas / Soul Knife)
	## Gideon Wulf, campeón del Vacío, no tiene discípulos conocidos.
	## Pero el Vacío actúa a través de campeones involuntarios.
	_s("portador_vacio", "Portador del Vacío", "picaro",
		"El Vacío no tiene fragmento físico. Actúa solo a través de campeones. " + "Gideon lo es conscientemente. Otros son elegidos sin saberlo — y sin poder rechazarlo.",
		[],
		{
			3: [
				_f("cuchillas_psiquicas", "Cuchillas del Vacío",
					"Manifiestas 2 cuchillas psíquicas (1d6 psíquico, fineza). Desaparecen al soltar. Gratis siempre.",
					"bonus", "none", ""),
				_f("punalada_nervios", "Puñalada a los Nervios",
					"Al golpear con cuchilla: objetivo hace INT save o queda Aturdido hasta inicio de tu siguiente turno.",
					"none", "none", "sneak_attack_dice"),
			],
			9: [
				_f("poder_psiquico", "Poder del Vacío",
					"Energía Psíquica (dados): usar para curar, teleportarte 9m o dar ventaja a aliado en save.",
					"none", "short", ""),
			],
			13: [
				_f("teletransporte_psiquico", "Teletransporte del Vacío",
					"Puedes teletransportarte hasta 18m como bonus action al golpear con tu Ataque Furtivo.",
					"bonus", "none", ""),
			],
			17: [
				_f("barrera_psiquica", "Barrera del Vacío",
					"Reacción: cuando serías golpeado, interpones escudo psíquico que reduce el daño a 0.",
					"reaction", "short", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# MONJE — TRADICIÃ"N
# Niveles de rasgo: 3, 6, 11, 17
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_monje_subclasses() -> void:

	## DISCÃPULOS DE SYLVARA DUSK (= Guerrero de la Sombra) — MÃA
	## La Orden de Sylvara (Cadena 5 de Kethara). Mía se fue por conflicto moral.
	## Pero el entrenamiento no se olvida.
	_s("discipulos_sylvara", "Discípulos de Sylvara Dusk", "monje",
		"Sylvara Dusk (Cadena 5) creó esta orden hace décadas. Sus métodos son eficaces. " + "Mía fue su alumna más prometedora antes de que la moral se interpusiera.",
		["pasar_sin_rastro", "invisibilidad", "espiar", "puerta_dimensional"],
		{
			3: [
				_f("artes_sombra", "Artes de la Sombra",
					"Lanzar Invisibilidad, Silencio o Pasar sin Rastro usando puntos de Energía Marcial.",
					"bonus", "none", "ki_points"),
				_f("paso_noche", "Paso de la Noche",
					"En oscuridad/luz tenue: invisible hasta atacar. +60m de visión nocturna.",
					"none", "none", ""),
			],
			6: [
				_f("paso_sombra", "Paso de la Sombra",
					"Bonus action: teletransportarte hasta 18m entre sombras visibles.",
					"bonus", "none", "ki_points"),
			],
			11: [
				_f("manto_noche", "Manto de la Noche",
					"Puedes crear oscuridad mágica 3m radio gastando 1 punto. Puedes ver dentro de ella.",
					"action", "none", "ki_points"),
			],
			17: [
				_f("presencia_vacia", "Presencia Vacía",
					"Reacción al ser atacado: te vuelves invisible hasta inicio de tu siguiente turno (los ataques fallan).",
					"reaction", "none", "ki_points"),
			],
		}
	)

	## ORDEN DEL EQUILIBRIO (= Guerrero de la Mano Abierta)
	## La orden más antigua del mundo conocido. Neutrales. Aparecen donde el equilibrio
	## se rompe — y siempre se rompe donde los Cinco Antiguos están involucrados.
	_s("escuela_tarek", "Escuela de Tarek el Inmóvil", "monje",
		"Ni Velthar ni Kethara los reclaman. Ni los Cinco Antiguos los controlan. " + "Cuando el equilibrio se rompe, aparecen. Nadie sabe cómo saben.",
		[],
		{
			3: [
				_f("tecnica_abierta", "Técnica Abierta",
					"Tras Ráfaga de Golpes: puedes derribar al objetivo, empujarlo 4.5m, o quitarle su reacción.",
					"none", "none", "ki_points"),
			],
			6: [
				_f("paz_interior", "Paz Interior",
					"El descanso de 1 hora te permite acceder al estado de Trance: inmune a veneno y enfermedad 8h.",
					"none", "none", ""),
			],
			11: [
				_f("golpe_vaciante", "Golpe Vaciante",
					"Gastar 3 puntos: el objetivo hace CON save o queda a 1 PG (muertos vivientes: destrucción).",
					"none", "none", "ki_points"),
			],
			17: [
				_f("cuerpo_puro", "Cuerpo Puro",
					"Inmunidad a veneno y enfermedad. Puedes curar tu propio envenenamiento gastando 3 puntos.",
					"none", "none", "ki_points"),
			],
		}
	)

	## SANADORES DE MEREDAN (= Guerrero de la Misericordia)
	## Los monjes que curan en la ciudad portuaria. Conocen los venenos de Kethara mejor
	## que nadie. También saben aplicarlos.
	_s("sanadores_meredan", "Sanadores de Meredan", "monje",
		"Meredan es puerto de entrada para todo — incluyendo las enfermedades de la guerra. " + "Los Sanadores curan lo que pueden y eliminan lo que no tiene cura.",
		["pasar_sin_rastro"],
		{
			3: [
				_f("manos_sanadoras_mv", "Manos Sanadoras",
					"Gastar 1 punto: curar 1d10+SAB PG a criatura tocada. También eliminar 1 condición.",
					"bonus", "none", "ki_points"),
				_f("toque_agonizante", "Toque Agonizante",
					"Gastar 1 punto: golpe hace daño necrótico adicional = Dados de Artes Marciales. El objetivo pierde 1 PG al inicio de sus turnos.",
					"none", "none", "ki_points"),
			],
			6: [
				_f("medico_campo", "Médico de Campo",
					"Gastar 2 puntos: estabilizar a criatura a 0 PG sin tirada; ella recupera 1 PG.",
					"none", "none", "ki_points"),
			],
			11: [
				_f("curación_veloz", "Curación Veloz",
					"Puedes usar Manos Sanadoras como reacción cuando un aliado adyacente cae a 0 PG.",
					"reaction", "none", "ki_points"),
			],
			17: [
				_f("sanación_suprema", "Sanación Suprema",
					"Gastar 6 puntos: restaurar a una criatura a sus PG máximos + eliminar todas las condiciones.",
					"action", "none", "ki_points"),
			],
		}
	)

	## VOCES DE LOS ANTIGUOS (= Guerrero de los Elementos)
	## Los monjes que canalizan a los Cinco Antiguos sin ser sus campeones directos.
	## Peligroso. No siempre controlable.
	_s("voces_antiguos", "Voces de los Antiguos", "monje",
		"Los Cinco Antiguos hablan a través de todo — algunos monjes aprenden a escuchar. " + "No son campeones. Son receptores. La diferencia puede no importar cuando el Antiguo habla.",
		[],
		{
			3: [
				_f("discipulo_elementos", "Discípulo de los Antiguos",
					"Ataques sin armas hacen daño elemental. Gastar 1 punto: conjuro elemental menor (Quemar, Helar, etc.).",
					"none", "none", "ki_points"),
			],
			6: [
				_f("golpes_elementales", "Golpes Elementales",
					"Ataques sin armas ignoran resistencia al tipo de daño elegido. +1d6 daño elemental.",
					"none", "none", ""),
			],
			11: [
				_f("paso_elemental", "Paso Elemental",
					"Gastar 3 puntos: moverte sin provocar AoO y atravesar objetos sólidos hasta 1m de grosor.",
					"action", "none", "ki_points"),
			],
			17: [
				_f("forma_elemental", "Forma Elemental",
					"Gastar 4 puntos: 1min transformarte en elemental de aire/agua/tierra/fuego (stats del elemental).",
					"action", "none", "ki_points"),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# BÃRBARO — SENDAS
# Niveles de rasgo: 3, 6, 10, 14
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_barbaro_subclasses() -> void:

	## SENDA DEL ARCO ANTIGUO (= Ãrbol del Mundo) — BICHO
	## Bicho lleva el Arco Antiguo, el único capaz de herir a los Cinco Antiguos.
	## Su senda de bárbaro canaliza esa energía antigua que aún no comprende.
	_s("senda_arco_antiguo", "Senda del Arco Antiguo", "barbaro",
		"El Arco Antiguo eligió a Bicho, no al revés. En zonas de Corrupción reacciona solo. " + "Bicho no sabe qué fue antes de que le borraran la memoria. El arco parece saberlo.",
		[],
		{
			3: [
				_f("espiritu_totemico", "Espíritu del Arco",
					"Elegir espíritu: Ãguila (movimiento), Lobo (caza), Oso (resistencia). Bonos en Furia.",
					"none", "none", ""),
				_f("comunion_antigua", "Comunión Antigua",
					"En Furia: tus ataques cuentan como mágicos y pueden herir seres con inmunidades.",
					"none", "none", "rage_uses"),
			],
			6: [
				_f("aspecto_espiritu", "Aspecto del Espíritu",
					"Segundo espíritu elegido. Beneficios fuera de la Furia también.",
					"none", "none", ""),
			],
			10: [
				_f("caminante_espiritual", "Caminante Espiritual",
					"Comunión con tu espíritu: ventaja en Percepción e Investigación 10 min (meditación).",
					"action", "long", ""),
			],
			14: [
				_f("fusión_totem", "Fusión con el Arco",
					"En Furia: eres indetectable por magia de adivinación y tus ataques ignoran resistencias.",
					"none", "none", "rage_uses"),
			],
		}
	)

	## SENDA DEL SOLDADO CORROMPIDO (= Berserker)
	## Los soldados de Kethara corrompidos por el fragmento de El Poder.
	## Algunos escapan del control y sirven a quien pueden.
	_s("senda_soldado_corrompido", "Senda del Soldado Corrompido", "barbaro",
		"El fragmento de El Poder corrompe a los soldados de Kethara. Algunos luchan contra ello. " + "Muchos no. La línea entre fuerza y locura es más delgada de lo que parece.",
		[],
		{
			3: [
				_f("frenesí_berserker", "Frenesí",
					"En Furia: bonus action para atacar con arma. Al terminar: 1 nivel de Cansancio.",
					"bonus", "none", "rage_uses"),
			],
			6: [
				_f("mente_imperturbable", "Mente Imperturbable",
					"No puedes ser Hechizado ni Asustado. Ventaja en saves mentales mientras en Furia.",
					"none", "none", ""),
			],
			10: [
				_f("intimidación_feroz", "Intimidación Feroz",
					"En Furia: acción para Intimidar. Si fallas el check, la Furia no termina igualmente.",
					"action", "none", "rage_uses"),
			],
			14: [
				_f("matanza_corrupcion", "Matanza",
					"Cuando un objetivo cae a 0 PG: bonus attack contra otro objetivo en 9m.",
					"none", "none", ""),
			],
		}
	)

	## SENDA DE LAS PROFUNDIDADES (= Corazón Salvaje)
	## El Antiguo de las Profundidades actúa sin campeones directos — pero su influencia
	## llega a los que pasan demasiado tiempo cerca de lo antiguo.
	_s("senda_profundidades_bar", "Senda de las Profundidades", "barbaro",
		"Las Profundidades llevan eternidades esperando. No necesitan campeones — " + "se filtran en los que están cerca de lo suficientemente viejo.",
		[],
		{
			3: [
				_f("furia_animal", "Furia Primordial",
					"Elegir animal primordial. En Furia: su instinto guía tus ataques (ventaja o efecto especial).",
					"none", "none", "rage_uses"),
			],
			6: [
				_f("resistencia_primal", "Resistencia Primordial",
					"En Furia: resistencia a un tipo extra de daño (no físico) según tu animal.",
					"none", "none", ""),
			],
			10: [
				_f("ataque_bestial", "Ataque Bestial",
					"En Furia: puedes usar mordisco o garra (1d8 + tu mod de FUE) como ataque adicional.",
					"bonus", "none", "rage_uses"),
			],
			14: [
				_f("forma_primordial", "Forma Primordial",
					"En Furia: ganar características físicas del animal (nadar, trepar, visión especial).",
					"none", "none", "rage_uses"),
			],
		}
	)

	## SENDA DEL PODER (= Fanático / Zealot)
	## Los que han sentido la presencia de El Poder — el Antiguo que Kethara usa.
	## Algunos luchan en su nombre conscientes. Otros no saben que sirven a algo mayor.
	_s("senda_poder", "Senda del Poder", "barbaro",
		"El Poder no necesita convencerte. Entra cuando bajas la guardia. " + "Los que sirven a Kethara más ferozmente suelen sentir algo que no pueden nombrar.",
		[],
		{
			3: [
				_f("furia_divina", "Furia del Poder",
					"En Furia: +1d6 radiante o necrótico a 1 ataque/turno.",
					"none", "none", "rage_uses"),
				_f("guerrero_de_los_dioses", "Guerrero del Poder",
					"No mueres por caer a 0 PG durante la Furia — pero caes al final de ella.",
					"none", "none", "rage_uses"),
			],
			6: [
				_f("fanático_poderoso", "Fanático",
					"Ventaja en saves vs Asustado en Furia. Al tirar iniciativa, puedes iniciar Furia aunque te sorprendan.",
					"none", "none", ""),
			],
			10: [
				_f("presencia_abrumadora", "Presencia Abrumadora",
					"Bonus action: una criatura en 9m hace WIS save o queda Asustada de ti 1 turno.",
					"bonus", "none", ""),
			],
			14: [
				_f("existencia_indomable", "Existencia Indomable",
					"Al caer: si tu Furia está activa, continúa aunque estés a 0 PG durante 1 turno antes de caer.",
					"none", "none", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# HECHICERO — ORIGEN
# Niveles de rasgo: 1, 6, 14, 18
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_hechicero_subclasses() -> void:

	## HERENCIA DEL ARQUITECTO (= Magia Salvaje) — NAEREN
	## El Arquitecto actúa a través de Naeren y Seraphel sin ser su campeón directo.
	## Naeren perdió la voz cuando su magia psíquica emergió sin control.
	_s("herencia_arquitecto", "Herencia del Arquitecto", "hechicero",
		"El Arquitecto toca sin avisar. Naeren no eligió el psionismo — le llegó. " + "Cuando emite su primera Sobrecarga Mental, algo en el tejido de la realidad tiembla.",
		[],
		{
			1: [
				_f("oleada_magia_salvaje", "Oleada de la Herencia",
					"Al lanzar conjuro nv1+: 5% de activar efecto aleatorio de Magia Salvaje (1d20 = 1).",
					"none", "none", ""),
				_f("marea_herencia", "Marea de la Herencia",
					"Después de una tirada d20 contra ti: el DM puede activar una Oleada sin tirada.",
					"none", "none", ""),
			],
			6: [
				_f("caos_bendito", "Caos Bendito",
					"Cuando provocas Oleada: ganas ventaja en tiradas de ataque hasta fin de tu siguiente turno.",
					"none", "none", ""),
			],
			14: [
				_f("control_caos", "Control del Caos",
					"1/largo: garantizar que la próxima Oleada se activa. Elegir el resultado de la tabla (1-20).",
					"none", "long", ""),
			],
			18: [
				_f("control_magia_salvaje", "Control de la Herencia",
					"Puedes usar Hechicería Innata para activar o suprimir Oleadas a voluntad.",
					"none", "none", ""),
			],
		}
	)

	## TOQUE DE LAS PROFUNDIDADES (= Hechicería Aberrante)
	## El fragmento de Las Profundidades está bajo Ilvernis. Su influencia llega
	## a los hechiceros de la isla en formas que los académicos prefieren ignorar.
	_s("toque_profundidades", "Toque de las Profundidades", "hechicero",
		"El sello bajo la Aguja de Marfil se debilita. Los hechiceros de Ilvernis " + "que estudian demasiado cerca desarrollan... peculiaridades.",
		["detectar_pensamientos", "abrir", "telepatia", "dominar_persona"],
		{
			1: [
				_f("mente_aberrante", "Mente de las Profundidades",
					"Telequinesia innata: mover objeto 4.5 kilos hasta 9m (bonus action). Telepatía 9m.",
					"bonus", "none", ""),
			],
			6: [
				_f("pasos_extraños", "Pasos Extraños",
					"Bonus action: teletransportarte 9m. Gastar 1 punto de hechicería: no provocas AoO el turno.",
					"bonus", "none", "sorcery_points"),
			],
			14: [
				_f("cuerpo_aberrante", "Cuerpo Aberrante",
					"Resistencia a psíquico. Cuando el objetivo falla un save vs ti: incapacitado 1 turno.",
					"none", "none", ""),
			],
			18: [
				_f("iluminacion_profunda", "Iluminación Profunda",
					"Visión verdadera 18m. Al usar Hechicería Innata: Escrutinio Mental a todos en 9m (WIS save).",
					"none", "none", ""),
			],
		}
	)

	## LINAJE DE DRAGÃ"N (= Linaje Dracónico)
	## No hay dragones conocidos en Vestigios actualmente — pero el linaje persiste.
	## Algunos dicen que el linaje dracónico viene de algo anterior incluso a los Cinco Antiguos.
	_s("linaje_erdrath", "Linaje de Erdrath", "hechicero",
		"Erdrath el Escarlata fue uno de los dragones más importantes documentados, hace 1000 años. " + "No murió — se transformó en algo que los mortales no pueden percibir. " + "Su sangre sigue apareciendo en hechiceros. No es herencia. Es contacto.",
		[],
		{
			1: [
				_f("ancestro_draconico", "Ancestro Dracónico",
					"Elegir tipo de dragón (fuego/frío/ácido/etc.). Resistencia a ese daño. Hablar Dragónico.",
					"none", "none", ""),
				_f("resiliencia_draconica", "Resiliencia Dracónica",
					"PG extra = nivel de hechicero. CA = 13+DES si no llevas armadura.",
					"none", "none", ""),
			],
			6: [
				_f("afinidad_elemental", "Afinidad Elemental",
					"Al lanzar conjuro del tipo de tu ancestro: +CHA al daño. Gastar 1 punto: resistencia ese tipo 1h.",
					"none", "none", "sorcery_points"),
			],
			14: [
				_f("alas_draconicas", "Alas Dracónicas",
					"Bonus action: manifestar alas de dragón. Vuelo = velocidad (no requiere puntos).",
					"bonus", "none", ""),
			],
			18: [
				_f("presencia_del_dragon", "Presencia del Dragón",
					"Gastar 5 puntos: 60m radio, criaturas que fallen WIS save â†' Asustadas/Fascinadas 1 min.",
					"action", "long", "sorcery_points"),
			],
		}
	)

	## AUTÃ"MATAS DE ARCANIS (= Hechicería Mecánica)
	## Los ingenieros mágicos de Ilvernis que combinan tecnología y conjuros.
	## Bofri Ironmantle los financia. Nadie sabe exactamente para qué.
	_s("automatas_ilvernis", "Autómatas de Ilvernis", "hechicero",
		"Ilvernis construye cosas que la magia no debería poder construir. " + "Los hechiceros de la Hechicería Mecánica son su experimento más peligroso.",
		["detectar_magia", "identificar", "abrir", "fabricar", "muro_de_fuerza"],
		{
			1: [
				_f("chispa_magica", "Chispa Mágica",
					"Siempre tienes 1 punto de hechicería incluso si gastas todos. Identificar como acción.",
					"none", "none", "sorcery_points"),
			],
			6: [
				_f("construto_magico", "Constructo Mágico",
					"Bonus action: invocar constructo pequeño (AC 13, 3d6 PG, 1 ataque). Dura 1h o hasta destruido.",
					"bonus", "long", "sorcery_points"),
			],
			14: [
				_f("mejora_arcana", "Mejora Arcana",
					"Puedes preparar 1 elemento arcano para tu constructo: lo hace volar, curar o proteger.",
					"none", "none", ""),
			],
			18: [
				_f("mecanismo_supremo", "Mecanismo Supremo",
					"El constructo pasa a tener tus saves y BC. Puede lanzar 2 de tus trucos por turno.",
					"none", "none", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# BRUJO — PATRÃ"N
# Niveles de rasgo: 1, 6, 10, 14
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_brujo_subclasses() -> void:

	## PACTO DE LA VIDA (= Patrón Celestial)
	## El Antiguo de la Vida actúa a través de sus campeones directos (Vael).
	## Pero también puede establecer pactos con mortales que lo merecen.
	_s("pacto_vida", "Pacto de la Vida", "brujo",
		"El Antiguo de la Vida elige sus campeones con cuidado. " + "Pero cuando necesita presencia en el mundo, establece pactos con los que sirven a la vida.",
		["curar_heridas", "luz", "llama_sagrada", "restauracion_menor", "luz_del_dia"],
		{
			1: [
				_f("magia_curativa_bru", "Magia de la Vida",
					"Conjuros de Vida siempre preparados. Estallido Mágico puede curar en lugar de dañar.",
					"none", "none", ""),
			],
			6: [
				_f("escudo_radiante_bru", "Escudo de la Vida",
					"Cuando reduces a 0 PG a una criatura: tú o un aliado en 18m recupera 2d8+CHA PG.",
					"none", "none", ""),
			],
			10: [
				_f("presencia_celeste", "Presencia Celestial",
					"Puedes lanzar Descanso Menor sin espacio. Resistencia a necrótico y radiante.",
					"none", "none", ""),
			],
			14: [
				_f("forma_celestial", "Forma Celestial",
					"Bonus action: alas (vuelo = velocidad), +2d6 radiante o fuego a tus ataques, 1 hora.",
					"bonus", "long", ""),
			],
		}
	)

	## PACTO DEL BOSQUE (= Patrón Feérico)
	## Los Bosques sin Nombre entre Velthar y Kethara tienen entidades que ofrecen pactos.
	## No son los Cinco Antiguos. Son algo diferente. Más pequeño. Más caprichoso.
	_s("pacto_bosque", "Pacto del Bosque", "brujo",
		"Los bosques fronterizos guardan entidades que los Cinco Antiguos ignoraron. " + "Que sean menores no las hace menos peligrosas.",
		["hechizar_persona", "paso_brumoso", "confusión", "mayor_invisibilidad"],
		{
			1: [
				_f("presencia_ferica", "Presencia del Bosque",
					"Bonus action: la criatura que falle WIS save queda Encantada o Asustada de ti hasta fin de turno.",
					"bonus", "short", ""),
			],
			6: [
				_f("evasion_ferica", "Evasión Feérica",
					"Cuando eres atacado: teletransportarte 9m y hacer invisible hasta inicio de tu siguiente turno.",
					"reaction", "short", ""),
			],
			10: [
				_f("brumas_ferica", "Brumas del Bosque",
					"Bonus action: invocar brumas de 9m radio centradas en ti. Duran 10 min. Ver 1.5m dentro.",
					"bonus", "long", ""),
			],
			14: [
				_f("regalo_feérico", "Regalo del Bosque",
					"Al reducir criatura a 0 PG: teletransportarte hasta 18m y hacerte invisible hasta próximo turno.",
					"none", "none", ""),
			],
		}
	)

	## PACTO DEL PODER (= Patrón Infernal)
	## El fragmento de El Poder en Kethara ofrece pactos a los desesperados.
	## Maerek Solden lo usa con plena consciencia del coste. Otros no.
	_s("pacto_poder", "Pacto del Poder", "brujo",
		"El fragmento de El Poder en Kethara otorga fuerza a cambio de algo que no siempre se ve venir. " + "Maerek lo sabe. Sus soldados corrompidos también lo aprenden — tarde.",
		["manos_ardientes", "represalia_infernal", "bola_fuego", "campo_anticreacion"],
		{
			1: [
				_f("bendicion_oscura", "Bendición del Poder",
					"PG temporales = CHA+nivel cuando reduces criatura a 0 PG.",
					"none", "none", ""),
			],
			6: [
				_f("fortuna_oscura", "Fortuna del Poder",
					"Cuando tú o aliado visible falla tirada: puedes añadir 1d10 (puede convertir fallo en éxito). 1/descanso.",
					"reaction", "short", ""),
			],
			10: [
				_f("resiliencia_oscura", "Resiliencia del Poder",
					"Resistencia al daño de conjuros. Inmunidad a fuego y veneno.",
					"none", "none", ""),
			],
			14: [
				_f("presencia_abrumadora_bru", "Presencia Abrumadora",
					"Cuando lanzas conjuro: puedes causar que 1 objetivo falle el save automáticamente. 1/largo.",
					"none", "long", ""),
			],
		}
	)

	## PACTO DE LAS PROFUNDIDADES (= Patrón Primigenio)
	## El Antiguo de las Profundidades es lo más alien de los cinco.
	## Sus pactos son los más peligrosos porque sus motivos son incomprensibles.
	_s("pacto_ysara", "Pacto de Ysara", "brujo",
		"Las Profundidades llevan eternidades esperando sin impaciencia. " + "Cuando ofrecen un pacto, no es porque lo necesiten. Es porque algo cambió en su plan.",
		["crear_o_destruir_agua", "tormenta_de_nieve", "control_agua", "invocar_elementales"],
		{
			1: [
				_f("hechizo_tentaculo", "Forma del Abismo",
					"Estallido Mágico puede silenciar al objetivo (no hablar) o ralentizarle (velocidad a la mitad).",
					"none", "none", ""),
			],
			6: [
				_f("escudo_profundidades", "Escudo del Abismo",
					"Gastar 1 espacio de pacto: proteger aliado visible con PG temporales = nivelÓ5 1h.",
					"action", "long", "pact_slots"),
			],
			10: [
				_f("resistencias_profundidades", "Resistencias del Abismo",
					"Resistencia a frío, relámpago y ácido. Respirar bajo el agua. Velocidad de natación.",
					"none", "none", ""),
			],
			14: [
				_f("llamada_profundidades", "Llamada de las Profundidades",
					"Bonus action 1/largo: invocar entidad de las Profundidades (aliada, nv = tu BC) por 1 hora.",
					"bonus", "long", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# CLÉRIGO — DOMINIO
# Niveles de rasgo: 3, 6, 8, 17
# (conjuros siempre preparados a niveles 1,3,5,7,9)
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_clerigo_subclasses() -> void:

	## DOMINIO DE VELTHAR (= Dominio de la Guerra)
	## Los sacerdotes que bendicen los ejércitos de Velthar. Aldric los financia.
	## No todos saben que el rey al que sirven puede ser parte del problema.
	_s("dominio_velthar", "Dominio de Velthar", "clerigo",
		"Los sacerdotes de guerra de Velthar bendicen cada espada antes de las batallas. " + "La pregunta que no hacen: Â¿y si la espada apunta a los inocentes?",
		["escudo_de_la_fe", "castigo_furioso", "arma_espiritual", "cruzada_espiritual", "llama_santa"],
		{
			3: [
				_f("arma_de_guerra", "Arma de Velthar",
					"Competencia con armas marciales y armaduras pesadas. Bonus attack con arma como bonus action.",
					"bonus", "none", ""),
				_f("golpe_guiado", "Golpe Guiado",
					"Canalizar Divinidad: +10 a tirada de ataque (tras ver el dado, antes del resultado).",
					"none", "short", "channel_divinity"),
			],
			6: [
				_f("bendicion_de_guerra", "Bendición de Velthar",
					"Bonus action: otorgar ventaja en 1 tirada de ataque a aliado visible.",
					"bonus", "none", ""),
			],
			8: [
				_f("golpe_divino_velthar", "Golpe Divino de Velthar",
					"+1d8 daño de tu tipo sagrado en un ataque de arma por turno (2d8 a nivel 14).",
					"none", "none", ""),
			],
			17: [
				_f("avatar_batalla", "Avatar de Batalla",
					"Resistencia a B/P/C. No provocas AoO. Tus ataques hacen +1d8 fuerza extra.",
					"none", "none", ""),
			],
		}
	)

	## DOMINIO DE LA VIDA (= Dominio de la Vida) — conexión directa con El Antiguo de la Vida
	_s("dominio_vida_cle", "Dominio de la Vida", "clerigo",
		"El Antiguo de la Vida habla a través de sus sacerdotes. No todos son elegidos — " + "pero todos los que toman este dominio sienten algo que no se puede describir con palabras.",
		["bendicion", "curar_heridas", "auxilio", "restauracion_menor", "revivir"],
		{
			3: [
				_f("curación_poderosa", "Curación Poderosa",
					"Cuando curas PG: el objetivo recupera 2+nivel del conjuro PG adicionales.",
					"none", "none", ""),
			],
			6: [
				_f("curar_bendito", "Curar Bendito",
					"Cuando lanzas conjuro de curación a otro: tú también recuperas 2+nivel del conjuro PG.",
					"none", "none", ""),
			],
			8: [
				_f("golpe_divino_vida", "Golpe Divino de la Vida",
					"+1d8 radiante en 1 ataque de arma/turno (2d8 a nivel 14).",
					"none", "none", ""),
			],
			17: [
				_f("curación_suprema_vida", "Curación Suprema",
					"Al curar: en lugar de tirar dados, usa el valor máximo del dado.",
					"none", "none", ""),
			],
		}
	)

	## DOMINIO DEL FARO (= Dominio de la Luz) — Meredan, el faro, esperanza
	_s("dominio_faro_cle", "Dominio del Faro", "clerigo",
		"El Faro de Meredan no es solo un edificio. Es una idea: que la luz persiste. " + "Los clérigos del Faro encienden esa luz donde la oscuridad más aprieta.",
		["luz", "quemar_manos", "disipar_magia", "bola_de_fuego", "llama_santa"],
		{
			3: [
				_f("truco_luz_faro", "Truco de Luz",
					"Luz y Sagrado Fuego siempre preparados. Cuando lanzas conjuro de luz: criaturas en 9m deslumbradas.",
					"none", "none", ""),
				_f("destello_cegador", "Destello del Faro",
					"Canalizar Divinidad: luz cegadora 9m. Criaturas que fallen CON save quedan Cegadas 1 min.",
					"action", "short", "channel_divinity"),
			],
			6: [
				_f("mejorar_llama", "Mejorar Llama",
					"Trucos de fuego de daño hacen +SAB daño. Resistencia al fuego.",
					"none", "none", ""),
			],
			8: [
				_f("golpe_divino_faro", "Golpe del Faro",
					"+1d8 fuego en 1 ataque de arma/turno (2d8 a nivel 14).",
					"none", "none", ""),
			],
			17: [
				_f("corona_luz", "Corona de Luz",
					"Cuando usas Canalizar Divinidad: esfera de luz 18m radio, criaturas en ella con desventaja vs tus conjuros.",
					"action", "short", "channel_divinity"),
			],
		}
	)

	## DOMINIO DE LA SOMBRA (= Dominio del Engaño) — Kethara, Maerek, las Cadenas
	_s("dominio_sombra_cle", "Dominio de la Sombra", "clerigo",
		"Kethara tiene sus propios dioses — o algo que los imita. " + "Maerek Solden reza en la oscuridad. Sus sacerdotes hacen el trabajo sucio que él no puede hacer.",
		["encanto", "imagen_silenciosa", "pasar_sin_rastro", "mayor_invisibilidad", "dominar_persona"],
		{
			3: [
				_f("bendicion_embaucador", "Bendición de la Sombra",
					"Canalizar Divinidad: copiar apariencia de criatura humanoide vista en 7 días.",
					"action", "short", "channel_divinity"),
				_f("invocar_duplicado", "Invocar Duplicado",
					"Canalizar Divinidad: crea duplicado ilusorio tuyo en espacio adyacente (1 min).",
					"action", "short", "channel_divinity"),
			],
			6: [
				_f("canal_de_sombra", "Canal de Sombra",
					"Al lanzar conjuro de ilusión o encantamiento: una criatura que falle el save queda Hechizada 1 turno extra.",
					"none", "none", ""),
			],
			8: [
				_f("golpe_divino_sombra", "Golpe de la Sombra",
					"+1d8 psíquico en 1 ataque de arma/turno (2d8 a nivel 14).",
					"none", "none", ""),
			],
			17: [
				_f("maestría_impostura", "Maestría de la Sombra",
					"Puedes usar Bendición de la Sombra en cualquier criatura que hayas visto, no solo en 7 días.",
					"none", "none", ""),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# DRUIDA — CÃRCULO
# Niveles de rasgo: 2, 6, 10, 14
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_druida_subclasses() -> void:

	## CÃRCULO DE LA MAREA (= Círculo de la Luna)
	_s("circulo_marea", "Círculo de la Marea", "druida",
		"El mar entre Meredan e Ilvernis tiene memoria propia. " + "Los druidas de la Marea se transforman en criaturas del mar y tormentas.",
		[],
		{
			2: [
				_f("transformacion_combat", "Transformación de Combate",
					"Forma Salvaje como bonus action en combate. Bestias CR â‰¤ nivel/3 (mínimo 1).",
					"bonus", "none", "wild_shape_uses"),
			],
			6: [
				_f("criatura_acuatica", "Criatura de la Marea",
					"En Forma Salvaje: resistencia al daño de esa forma. Nadar siempre disponible.",
					"none", "none", ""),
			],
			10: [
				_f("forma_elemental_dru", "Forma Elemental",
					"Gastar 2 usos de Forma Salvaje: transformarte en Elemental de Agua o Aire.",
					"none", "none", "wild_shape_uses"),
			],
			14: [
				_f("bestia_ancient", "Bestia Antigua",
					"En Forma Salvaje: ataques son mágicos y tienes resistencia a B/P/C no mágicos.",
					"none", "none", ""),
			],
		}
	)

	## CÃRCULO DEL BOSQUE OSCURO (= Círculo de la Tierra)
	_s("circulo_bosque_oscuro", "Círculo del Bosque Oscuro", "druida",
		"Los Bosques sin Nombre entre Velthar y Kethara guardan secretos. " + "Estos druidas son los custodios de lo que no debería salir de esos bosques.",
		[],
		{
			2: [
				_f("recuperacion_natural", "Recuperación Natural",
					"Tras descanso corto: recuperar espacios de conjuro totalizando nivel/2 (máx nivel 5).",
					"none", "short", "spell_slot"),
			],
			6: [
				_f("conjuros_tierra", "Conjuros del Bosque",
					"+2 conjuros de la lista del bosque siempre preparados (según el tipo de bosque elegido).",
					"none", "none", ""),
			],
			10: [
				_f("mente_natural", "Mente Natural",
					"Inmunidad a Hechizado. Teletransportarse 9m entre plantas (como bonus action).",
					"bonus", "none", ""),
			],
			14: [
				_f("santuario_bosque", "Santuario",
					"Criaturas que entren en 9m de ti deben hacer WIS save o parar (no atacar) 1 turno.",
					"none", "none", ""),
			],
		}
	)

	## CÃRCULO DE LA BÃ"VEDA (= Círculo de las Estrellas) — Ilvernis, observatorio
	_s("circulo_sol", "Círculo de Sól", "druida",
		"Sól la Inmortal fundó este círculo en el Observatorio de Ilvernis hace siglos. " + "Sabe lo que hay bajo la Aguja de Marfil. No lo dice voluntariamente.",
		[],
		{
			2: [
				_f("forma_astral", "Forma Astral",
					"Forma Salvaje como forma astral (luminosa, habilidades de observación, +INT a ataques 10min).",
					"bonus", "none", "wild_shape_uses"),
				_f("mapa_estelar_dru", "Mapa Estelar",
					"Conoces Guía y Proyectil Mágico. 1Ódía: lanzar sin espacio usando Forma Astral.",
					"none", "none", ""),
			],
			6: [
				_f("constelacion", "Forma de Constelación",
					"En Forma Astral: elige modo: Arquero (1d8 radiante bonus), Cáliz (curar 1d8 al lanzar nv1+) o Serpiente (CON save o paralizar).",
					"none", "none", ""),
			],
			10: [
				_f("bóveda_celestial", "Bóveda Celestial",
					"Ventaja en saves vs Hechizado. Resistencia a radiante y necrótico. Tus ataques ignoran cobertura.",
					"none", "none", ""),
			],
			14: [
				_f("pleno_firmamento", "Pleno Firmamento",
					"Al iniciar combate: activar la constelación del Cáliz, Arquero Y Serpiente simultáneamente.",
					"none", "long", ""),
			],
		}
	)

	## CÃRCULO DEL ABISMO (= Círculo del Mar) — Las Profundidades
	_s("circulo_abismo", "Círculo del Abismo", "druida",
		"El fragmento de Las Profundidades bajo Ilvernis filtra influencia. " + "Algunos druidas la recogen sin entender de dónde viene.",
		["niebla", "invocar_bestia", "desplazarse_agua", "llamar_relampago", "invocar_elementales"],
		{
			2: [
				_f("magia_abismal", "Magia del Abismo",
					"En Forma Salvaje: velocidad de natación, respirar bajo el agua, resistencia al frío.",
					"none", "none", "wild_shape_uses"),
			],
			6: [
				_f("garras_abismo", "Garras del Abismo",
					"En Forma Salvaje: ataques de mordisco/garra hacen +1d6 de daño de relámpago.",
					"none", "none", ""),
			],
			10: [
				_f("voz_profundidades", "Voz de las Profundidades",
					"Hablar telepáticamente con criaturas bajo el agua. Resistencia a relámpago.",
					"none", "none", ""),
			],
			14: [
				_f("espiritu_profundo", "Espíritu de las Profundidades",
					"Cuando caes a 0 PG: puedes usar Forma Salvaje gratis para continuar en forma de bestia acuática.",
					"none", "none", "wild_shape_uses"),
			],
		}
	)

# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
# MAGO — TRADICIÃ"N ARCANA
# Niveles de rasgo: 2, 6, 10, 14
# â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
func _reg_mago_subclasses() -> void:

	## ESCUELA DEL SELLO (= Abjurador) — los que sellan a los Cinco Antiguos
	_s("escuela_sevryn", "Escuela de Sevryn el Sellador", "mago",
		"La magia que mantiene sellado el fragmento de Las Profundidades bajo Ilvernis " + "fue creada por esta escuela. Sus secretos no se enseñan. Se heredan.",
		[],
		{
			2: [
				_f("reserva_arcana", "Reserva del Sello",
					"Resistencia arcana: PG temporales = nivel + INT al lanzar conjuro de abjuración.",
					"none", "none", ""),
				_f("borrar_magia", "Borrar Magia",
					"Suprimir un efecto mágico hostil como acción (no requiere espacio si el nivel es â‰¤ nivel/2).",
					"action", "none", "arcane_recovery"),
			],
			6: [
				_f("proyeccion_escudo", "Proyección del Sello",
					"Tu Reserva del Sello también puede proteger a aliados adyacentes.",
					"none", "none", ""),
			],
			10: [
				_f("resistencia_magica", "Resistencia Mágica",
					"Ventaja en todas las tiradas de salvación vs conjuros.",
					"none", "none", ""),
			],
			14: [
				_f("maestria_sello", "Maestría del Sello",
					"Cuando usas Borrar Magia: regain espacio de nivel del conjuro borrado.",
					"none", "none", ""),
			],
		}
	)

	## ESCUELA DEL CRISTAL (= Adivino) — Ilvernis, investigación
	_s("escuela_miranbel", "Escuela del Cristal de Miranbel", "mago",
		"La Aguja de Marfil tiene una sala de cristales que algunos creen encantados. " + "Los adivinos de Ilvernis los usan para leer lo que nadie debería poder leer.",
		[],
		{
			2: [
				_f("presagio", "Presagio",
					"Tirar 2d20 al amanecer. Guardar los resultados. Usar en lugar de cualquier d20 propio/aliado/enemigo.",
					"none", "long", ""),
			],
			6: [
				_f("profecia_experto", "Pericia Profética",
					"Al usar un dado de Presagio: añade tu INT al resultado.",
					"none", "none", ""),
			],
			10: [
				_f("vision_gran_presagio", "Visión del Gran Presagio",
					"Tirar 3d20 en lugar de 2 para Presagio.",
					"none", "long", ""),
			],
			14: [
				_f("destino_controlado", "Destino Controlado",
					"Gastar 1 uso de Presagio: garantizar crítico o pifia de una criatura visible 1Ólargo.",
					"none", "long", ""),
			],
		}
	)

	## ESCUELA DEL FULGOR (= Evocador) — Kethara, magia de guerra
	_s("escuela_kest", "Escuela del Fulgor de Kest", "mago",
		"La magia de guerra de Kethara fue desarrollada aquí — o en su equivalente kethariano. " + "La Escuela del Fulgor de Ilvernis la estudia, teóricamente, para contrarrestarla.",
		[],
		{
			2: [
				_f("moldeador_hechizos", "Moldeador de Hechizos",
					"Al lanzar conjuro de área: elegir hasta INT criaturas que no son afectadas por él.",
					"none", "none", ""),
				_f("truco_potenciado", "Truco Potenciado",
					"Los trucos de daño hacen daño extra igual a tu mod de INT (una vez por truco).",
					"none", "none", ""),
			],
			6: [
				_f("evocacion_potenciada", "Evocación Potenciada",
					"Sumar tu mod de INT al daño de cualquier conjuro de evocación (1 criatura por lanzamiento).",
					"none", "none", ""),
			],
			10: [
				_f("concentración_mejorada", "Concentración Mejorada",
					"Ventaja en las tiradas de salvación de Constitución para mantener la concentración.",
					"none", "none", ""),
			],
			14: [
				_f("maestria_evocacion", "Maestría del Fulgor",
					"Lanzar un conjuro de evocación de nivel 1 o 2 sin espacio de conjuro 1Ócombate.",
					"none", "long", ""),
			],
		}
	)

	## ESCUELA DEL ESPEJO (= Ilusionista) — Vaela Mirage, las Cadenas
	_s("escuela_vaelindra", "Escuela de Vaelindra", "mago",
		"Vaela Mirage (Cadena 6) lleva tanto tiempo habitando ilusiones que no recuerda su forma real. " + "Los magos del Espejo aprenden que la diferencia entre lo real y lo irreal es más delgada de lo pensado.",
		[],
		{
			2: [
				_f("ilusión_mejorada", "Ilusión Mejorada",
					"Lanzar Ilusión Menor sin espacio. Los trucos de ilusión crean imágenes visibles Y audibles.",
					"none", "none", ""),
			],
			6: [
				_f("realidad_maleable", "Realidad Maleable",
					"Cuando un enemigo interactúa con tu ilusión: puedes hacerla real brevemente (1d4 daño psíquico, STR save).",
					"reaction", "none", ""),
			],
			10: [
				_f("disimulo_permanente", "Disimulo Permanente",
					"Al lanzar conjuro de ilusión que requiere concentración: dura su duración sin concentración.",
					"none", "none", ""),
			],
			14: [
				_f("maestría_ilusión", "Maestría del Espejo",
					"Cuando una criatura falla save vs tu ilusión: queda confundida 1 turno (no puede distinguir realidad).",
					"none", "none", ""),
			],
		}
	)

# ============================================================
# HELPER DE REGISTRO
# ============================================================

func _s(id: String, name: String, class_id: String, lore: String,
		always_prepared: Array, features: Dictionary) -> void:
	_subclasses[id] = {
		"id": id, "name": name, "class_id": class_id,
		"lore": lore, "always_prepared": always_prepared,
		"features": features,
	}

static func _f(feature_id: String, display_name: String, description: String,
		action_type: String, rest_type: String, resource_id: String) -> Dictionary:
	return {
		"id": feature_id, "name": display_name, "description": description,
		"action_type": action_type, "rest_type": rest_type, "resource_id": resource_id,
	}
