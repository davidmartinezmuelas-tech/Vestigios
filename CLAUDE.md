# CLAUDE.md — Vestigios
## Última actualización: 2026-05-15

---

## Stack
- **Motor:** Godot 4.3 con GDScript tipado estricto
- **Reglas:** D&D 2024 (documentación en `Documentación DND/`)
- **Arquitectura:** EventBus + StateMachine + Resource-driven data
- **Proyecto Godot:** en `game/` dentro del repositorio

---

## Convenciones de código
- `snake_case` para variables, funciones y nombres de archivo
- `PascalCase` para clases y nodos en escena
- `SCREAMING_SNAKE_CASE` para constantes
- Tipos explícitos en todas las variables: `var hp: int = 0`
- Señales nombradas en pasado: `damage_dealt`, no `deal_damage`
- Funciones privadas con prefijo `_`: `func _calculate_damage()`

---

## Reglas de arquitectura
- La lógica NUNCA llama a UI directamente — siempre vía EventBus
- No usar `_ready()` para lógica de negocio; usar `initialize()`
- No hardcodear valores numéricos — usar `Constants.gd` o Resources
- No crear dependencias directas entre managers — todo vía EventBus
- No `get_node()` con strings; usar autoloads o referencias exportadas

---

## Autoloads registrados (project.godot)
```
EventBus           → scripts/autoloads/event_bus.gd
GameManager        → scripts/autoloads/game_manager.gd
WorldState         → scripts/autoloads/world_state.gd
AudioManager       → scripts/autoloads/audio_manager.gd
FormationManager   → scripts/autoloads/formation_manager.gd
DialogueManager    → scripts/autoloads/dialogue_manager.gd
BastionManager     → scripts/autoloads/bastion_manager.gd
SaveManager        → scripts/save/save_manager.gd
LevelManager       → scripts/core/level_manager.gd
RestManager        → scripts/core/rest_manager.gd
ItemDatabase       → scripts/items/item_database.gd
MagicItemDatabase  → scripts/items/magic_item_database.gd
SpellDatabase      → scripts/abilities/spell_database.gd
FeatDatabase       → scripts/core/feat_database.gd
ClassFeatureDatabase → scripts/core/class_feature_database.gd
SubclassDatabase   → scripts/core/subclass_database.gd
RngManager         → scripts/utils/rng_manager.gd
```

---

## Estructura de carpetas
```
game/
├── project.godot
├── scripts/
│   ├── autoloads/         → EventBus, GameManager, WorldState, FormationManager, DialogueManager, BastionManager
│   ├── core/              → Constants, StateMachine, State, LevelManager, RestManager, FeatDatabase, ClassFeatureDatabase, SubclassDatabase, ConditionDefs, EnemyKnowledge, MissionData
│   ├── characters/        → BaseCharacter, CharacterStats, CharacterData
│   ├── combat/            → CombatManager, TurnManager, CombatResolver, CombatGrid, ReactionManager
│   ├── abilities/         → AbilityData, SpellData, SpellDatabase
│   ├── effects/           → EffectData, EffectManager
│   ├── items/             → ItemData, WeaponData, ArmorData, ConsumableData, MagicItemData, ItemDatabase, MagicItemDatabase
│   ├── character_creation/→ RaceData, RacialTrait, BackgroundData, ClassDefinition, PortraitSet, SpriteCustomization, CustomCharacterConfig, CharacterBuilder
│   ├── dialogue/          → DialogueData, DialogueNode, DialogueChoice, SkillCheckData
│   ├── bastion/           → FacilityData, BastionFacilityInstance, BastionNPCData
│   ├── save/              → SaveManager
│   ├── ui/                → Main, Combat, Dialogue, Inventory, Bastion, CharacterCreation, PartySelection
│   ├── world/             → BastionPlayer, FortGuard, InteractableObject, mission_01/
│   └── utils/             → RngManager
├── scenes/                → .tscn
└── data/
    ├── characters/heroes/ → vael, lyth, bicho, johannes, naeren, mia
    ├── characters/enemies/→ soldado_taberna, guardia_fuerte, soldado_corrompido, teniente_fuerte, general_vorn, ogro_bosque
    ├── characters/npcs/   → mia, lyris, cochero_karreth
    ├── abilities/         → AbilityData .tres por habilidad
    ├── bastion/           → 28 facilidades del Bastión + npcs/
    ├── backgrounds/       → 18 trasfondos (2024, con ability_score_options + origin_feat_id)
    ├── races/             → 9 razas 2024
    ├── missions/          → mision_01_fuerte_piedra_gris
    ├── items/             → (ItemDatabase en código, no .tres individuales)
    ├── spells/            → (SpellDatabase en código)
    └── dialogues/         → tabernero, encuentro_taberna, interrogatorio, mia_despedida, ogro, camino, fuerte, fiesta, lyris, vorn
```

---

## Personajes jugables y subclases

### Incorporación progresiva
| Momento | Personaje | Raza | Clase | Subclase | ID subclase |
|---|---|---|---|---|---|
| **Misión Fuerte** | **Lyth** | Harengon | Exploradora | Senda de Kolvek | `senda_kolvek` |
| **Misión Fuerte** | **Naeren** | Humana | Hechicera | Herencia del Arquitecto | `herencia_arquitecto` |
| **Misión Fuerte** | **Johannes** | Semielfo (medio drow, no lo sabe) | Bardo | Colegio de Mirsel | `colegio_mirsel` |
| **Misión Fuerte** | **Mía** | Humana | Monje | Discípulos de Sylvara Dusk | `discipulos_sylvara` |
| **Misión Ilvernis — llegada** | **Vael** | Humano | Paladín | Juramento de la Vida | `juramento_vida` |
| **Tras Ilvernis** | **Zyvara** | Drow | Bruja | Pacto con Ossyr | `pacto_ossyr` |
| **Misión Garreth** | **Bicho** | Humano | Guerrero | Portador del Arco Antiguo | `arco_antiguo_guerrero` |

**Protagonista:** elegido por el jugador al inicio (uno de los 4 de M1, o personaje custom).
El protagonista **siempre** va en misiones — no se puede dejar en el Bastión.
Party slots por misión: 4 (o 5 en misiones grandes).

### Notas de personaje relevantes
- **Lyth:** Harengon cazadora de la Iglesia de Cazadores de Meredan. Garreth Ashveil arrasó su poblado — es su objetivo personal. Viaja con Naeren y se encuentran a Johannes y Mía en la taberna de Karreth.
- **Naeren:** Viaja con Lyth. Llegan juntas a Karreth. Hechicera con conexión a El Arquitecto (uno de los Cinco Antiguos). Durante la Misión 2 en Ilvernis, la influencia de Ossyr/Las Profundidades la corrompe parcialmente al debilitarse el sello — su magia resuena con la entidad de forma involuntaria.
- **Johannes:** Semielfo sin saberlo (madre drow). Creció en caravana gitana itinerante, padre jefe del clan. La madre (Adreth) desapareció al pactar con Ossyr para proteger a su hijo. Johannes se fue al cumplir la mayoría de edad, acabó en Meredan. Había quedado con Mía en la taberna de Karreth para iniciar la misión.
- **Vael:** Enviado por el ejército de Velthar a Ilvernis como apoyo especializado. Tiene conocimiento relevante sobre el fragmento de Las Profundidades y su conexión con El Antiguo de la Vida lo hace especialmente útil para lo que ocurre bajo La Aguja.
- **Zyvara:** Drow de Sorveth, sassy y pragmática. Pacto con Ossyr. Se acerca al grupo después de la Misión 2, por cuenta propia. Conoce los textos de Ysara sobre pactos con Las Profundidades. A través de Ossyr siente el vínculo de Adreth sin saber qué es.
- **Bicho:** Secuestrado por Garreth Ashveil, que lo usa para investigar sobre la inmortalidad. El grupo lo encuentra durante la Misión 3. El Arco Antiguo no tiene relación con Garreth.
- **Mía:** Permanece en la party en todo momento de la historia.

---

## Sistema de mecánicas D&D 2024 implementado

### Combate
- Tiradas de ataque: 1d20 + mod + competencia vs CA
- Crítico: solo 20 natural. Pifia: solo 1 natural.
- Ventaja/Desventaja: 2d20, quedarse mayor/menor
- **Extra Attack**: automático en CombatManager según clase+nivel
- **Ataque Furtivo**: automático en CombatResolver (Pícaro)
- **Propiedades de Maestría** (2024): Debilitar, Derribar, Empujar, Hender, Mellar, Molestar, Ralentizar, Rozar
- Ataques de oportunidad: ReactionManager

### Conjuros
- **SpellData** extiende AbilityData → CombatResolver funciona igual
- **SpellDatabase**: 371 conjuros del libro + 25 con datos mecánicos precisos
- Espacios de conjuro: SpellSlots (full caster, half caster, pact magic 2024)
- Concentración: CharacterStats.make_concentration_check(damage)
- Trucos: nivel 0, sin gasto de espacio

### Condiciones
- 15 condiciones D&D 2024 + Borracho, Resaca, Exhausto (nado), Bosque Oscuro, Debilitado Maestría
- Por personaje, NO por grupo (ConditionDefs + CharacterStats._active_conditions)
- Condiciones persistentes entre escenas: CharacterData.persistent_conditions

### Descansos
- **Corto**: gastar dados de golpe para recuperar PG. Brujo: recupera slots de Magia de Pacto.
- **Largo**: PG al máximo, todos los slots, Cansancio -1, Estrés -10.
- RestManager autoload.

### Tiradas de muerte (Death saves)
- 0 PG → inconsciente, tiradas al inicio del turno
- 20 natural → recupera 1 PG. 1 natural → 2 fracasos.
- 3 éxitos → estable. 3 fracasos → muerto. Enemigos mueren directo.

### Rasgos de clase
- **ClassFeatureDatabase**: 224 rasgos para 12 clases, niveles 1-20
- **SubclassDatabase**: 48 subclases con nombres del lore de Vestigios
- Recursos de clase (ki, bardic inspiration, etc.) en CharacterStats._class_resources
- Métodos activos en BaseCharacter: use_second_wind(), use_action_surge(), lay_on_hands(), give_bardic_inspiration(), use_ki(), use_flurry_of_blows(), use_stunning_strike(), use_paladin_smite()

---

## Bases de datos globales

| Autoload | Contenido |
|---|---|
| `ItemDatabase` | 38 armas, 13 armaduras, 15 venenos, 16 consumibles |
| `MagicItemDatabase` | 124 objetos mágicos |
| `SpellDatabase` | 371 conjuros (nivel 0-9), 12 clases |
| `FeatDatabase` | 60+ dotes: Origen, General, Estilo Combate, Dones Épicos |
| `ClassFeatureDatabase` | 224 rasgos nivel 1-20, 12 clases |
| `SubclassDatabase` | 48 subclases con lore de Vestigios |

---

## Lore del mundo

### Reinos
- **Velthar** — estado militarista aliado del grupo. Rey: Aldric Voss (antagonista real)
- **Kethara** — reino corrupto, posee el fragmento de El Poder. Rey: Maerek Solden (combate a Aldric desde las sombras)
- **Meredan** — ciudad portuaria neutral. Crimen organizado: Calder Reth (tiefling rojo)
- **Ilvernis** — isla académica. La Aguja de Marfil. Fragmento de Las Profundidades bajo el suelo.

### Los Cinco Antiguos
| Antiguo | Estado | Conexión |
|---|---|---|
| El Poder | Fragmento activo en Kethara | Corrupción de los soldados |
| Las Profundidades | Fragmento bajo Ilvernis, sello debilitado | Orvyn el Sordo, Ysara la Encadenada |
| La Vida | Sin fragmento. Campeón: Vael | Tavar la Primera, los Vigías de la Vida |
| El Arquitecto | Sin fragmento. Conexión: Naeren y Seraphel | Herencia del Arquitecto (subclase) |
| El Vacío | Sin fragmento. Campeón: Gideon Wulf | Tarek el Inmóvil (conexión histórica) |

### Facciones clave
- **Los Cinco Pilares** (Velthar): Aldric → Erevan, Seraphel, Bofri, Caelum, Lyris
- **Las Diez Cadenas** (Kethara): Maerek → Valdris, Morrivan, Gorrath, Eryndas, Sylvara Dusk, Vaela Mirage/Vaelindra, Daven, Kael, Crassus, Barga
- **Iglesia de Cazadores** (Meredan): Alderich (jefe), Gideon Wulf, Lyth, Erika, Konrad, Liesel, Theodor, Marta

### NPCs clave del grupo
- **Lyris Nightveil** (Pilar 5) — superior directa. Drow, Pícaro/Asesina. La conocemos en el Fuerte.
- **Sela** — ex-pareja de Johannes, informante en Meredan. Conexión con Calder Reth.
- **Mild** — cerdo mágico entre planos. Aparece en el Bastión. Viaje rápido.

### Personajes históricos (lore activo)
Ver `LORE_NPCS_HISTORICOS.md` para los 17 personajes históricos creados.
Los más narrativamente explosivos: Vaelindra (=Vaela Mirage?), La Tejedora (¿sigue viva?), Erdrath el Escarlata (no murió, se transformó).

### El Bosque Gris
Bosque entre Karreth y el Fuerte de Piedra Gris. Más oscuro de lo natural bajo luna llena. Absorbente de sonido. El narizón vive aquí. Base de la subclase Senda del Bosque Gris (Explorador Feérico).

---

## Flujo del juego (estado actual)

```
Menú Principal → Selección de Protagonista
  → Creación de personaje custom (7 pasos) O elegir personaje existente
  → Bastión (hub central)
    → Mesa de Mapas → Briefing → Selección de Party → Misión
    → Facilidades (Biblioteca, Forja, Herbolario, etc.) — 28 disponibles
    → Turno de Bastión → Tabla de Eventos
    → NPC recrutables (Alderich→Biblioteca, Gideon→Sala de Entrenamiento)

MISIÓN 1 — El Fuerte de Piedra Gris:
  Karreth (taberna) → Carro (elección) → Bosque Gris O Camino Principal → Fuerte

  Pool disponible M1: Lyth, Naeren, Johannes, Mía (+ protagonista si es custom)

  Taberna:
    - Lyth y Naeren llegan a la taberna, encuentran a Johannes y Mía (habían quedado ahí)
    - Los 4 están reunidos antes de que empiece nada
    - Combate 2 soldados sin armadura
    - Interrogatorio opcional → info de Harren y Meredan
    - Party selection (4 de los disponibles)
    - Elección de ruta (bosque/camino)

  Bosque Gris:
    - Debuff: desventaja Supervivencia/Naturaleza
    - El narizón → claro del ogro
    - Ogro: pelear O dialogar (CD muy alta)
    - Salida → "el fuerte está cerca"

  Camino Principal:
    - 2 encuentros con soldados (tiradas: Engaño/Persuasión/Sigilo o combate)
    - Encuentro 1: 3 soldados (CD 13-14)
    - Encuentro 2: 4 guardias (CD 16, alertados)

  Fuerte Exterior:
    - Entrada: carro (engaño) O mar (natación)
    - Si falla en puerta: alarma → guardias en alerta (radio detección 150px, 6 guardias)

  Fuerte Interior (pueblo pesquero):
    - Exploración libre con guardias patrullando
    - Casa de rehenes → info + distracción aceite
    - Barco de Vorn → diálogo → combate General Vorn

  Post-misión:
    - Saqueo (aposentos Vorn: carta "C.R." + 200 PO; armería: 75 PO)
    - Llegada de Lyris + ejército aliado
    - Fiesta en el puerto (bebida → resaca solo al protagonista; opciones de compañía)
    - Briefing de Lyris: "barco para Ilvernis al amanecer"
```

---

## Lo que NO debes hacer
- No escribir lógica de juego en scripts de UI
- No usar magic numbers — todo en Constants.gd
- No dejar prints de debug sin borrar antes de commit
- No crear clases de más de 300 líneas sin justificación
- No commitear con TODOs activos en main
- No cambiar IDs de subclases/clases sin actualizar los .tres correspondientes
- No registrar conjuros con datos incorrectos — usar la documentación D&D 2024 como fuente
