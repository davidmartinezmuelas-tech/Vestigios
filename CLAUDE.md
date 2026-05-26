# CLAUDE.md — Vestigios
## Última actualización: 2026-05-19 (pipeline pixel art + offsets isométricos calibrados)

---

## Stack
- **Motor:** Godot 4.6.2 con GDScript tipado estricto
- **Reglas:** D&D 2024 (documentación en `Documentación DND/`)
- **Arquitectura:** EventBus + StateMachine + Resource-driven data
- **Proyecto Godot:** en `game/` dentro del repositorio

---

## Arte y herramientas de diseño
- **Vista:** Isométrica
- **Estilo personajes:** Pixel art
- **Herramienta mapas:** Tiled (plugin godot-tiled-importer) — actualmente suplantado por `taberna_painter.gd` (@tool) para la taberna
- **Herramienta sprites:** Aseprite (assets manuales) + **PixelLab AI** (generación por MCP)
- **Retratos de diálogo:** Midjourney (provisional) → artista comisionado (final)
- **Tiles placeholder:** Kenney.nl (fallback) — tiles activos de taberna son custom PixelLab 64px

### MCP servers activos
Configurados en `~/.claude.json` (nivel usuario):
```json
"godot-ai": {
  "type": "http",
  "url": "http://127.0.0.1:8000/mcp"
}
"pixellab": {
  "type": "http",
  "url": "https://api.pixellab.ai/mcp",
  "headers": { "Authorization": "Bearer <token>" }
}
```
- **godot-ai**: control directo del editor Godot (WS:9500, HTTP:8000). Permite leer/escribir escenas, crear nodos, parchear scripts, hacer screenshots del editor.
- **pixellab**: generación de pixel art por IA. Herramientas: `create_character`, `animate_character`, `create_isometric_tile`, `create_map_object`, etc.

### Pipeline de assets visuales — cómo pedir assets a PixelLab

**Regla fundamental:** NO pedir "un mapa" o "una escena". Pedir **piezas modulares** por tipo:
- tiles de suelo (10-20 variantes)
- bloques de pared (3-4 variantes)
- props individuales (mesa, barril, barra, etc.)
- personajes (base + animaciones por separado)

### REGLA OBLIGATORIA — Kenney como referencia de dimensiones
**ANTES de generar cualquier asset con PixelLab, buscar el equivalente en Kenney:**
1. `ls game/assets/tilesets/kenney_dungeon/Isometric/ | grep -i <tipo>` para encontrar el tile
2. Leer la imagen con `Read` para ver la forma y proporciones
3. `python3 -c "from PIL import Image; img=Image.open('<path>'); print(img.size)"` para obtener dimensiones exactas
4. Generar en PixelLab con **esas mismas dimensiones** pero con nuestro estilo oscuro medieval
5. Aplicar `modulate = WALL_COLOR` si hay mismatch de color

Ejemplo correcto:
- Kenney `stoneWallAged_E.png` → 256×512px panel vertical → generar en PixelLab a 64×128px + scale=4.0
- Kenney `door_E.png` → medir → generar puerta PixelLab a mismas proporciones

**Template de prompt para PixelLab (usar siempre):**
```
Style: dark medieval pixel art, 2:1 isometric perspective, 64x64px,
no anti-aliasing, thick dark outlines, light source top-left,
limited muted palette (24 colors max), no smooth gradients,
inspired by Children of Morta, Darkest Dungeon, Final Fantasy Tactics.
Grimdark, worn stone / dark wood, torchlit atmosphere, cold shadows.
```
Luego añadir la descripción específica del objeto.

**Herramientas PixelLab para escenarios:**
- `create_isometric_tile` — tiles de suelo/pared con forma isométrica CORRECTA (thin tile para suelo, block para paredes)
- `create_map_object` — props de decoración (mesas, barriles, puertas)
- `create_character` + `animate_character` — personajes con 8 dirs + animaciones

**Herramientas NO útiles para Vestigios:**
- GPT Image / DALL-E → no genera pixel art coherente con paletas fijas
- Skills genéricas de "Pixel Art" de MCP Market → generan SVG/texto, no imágenes reales
- Interface/Frontend Design skills → son para UI web, no pixel art de juego

**Pipeline completo por escena:**
1. Concept/moodboard con referencias visuales (Darkest Dungeon, Children of Morta)
2. Generar tiles base con `create_isometric_tile` (suelo thin tile + pared block)
3. Generar props con `create_map_object`
4. Descargar, organizar en `game/assets/tilesets/{nombre_escena}/`
5. Actualizar el painter `@tool` de la escena con las nuevas rutas
6. Ajustar offsets según tabla de calibración (ver sección taberna_painter)

### Sprites de personajes — convención de 8 direcciones
Los personajes tienen 8 direcciones de movimiento. Para reducir trabajo se dibujan **5 direcciones** y las otras 3 se obtienen por espejo horizontal en Godot:
- **Se dibujan:** S, SW, W, NW, N
- **Se obtienen por flip:** SE (espejo de SW), E (espejo de W), NE (espejo de NW)

**Estados de animación por personaje:** `idle`, `walk`, `attack`, `hit`, `death`, `cast`
**Nomenclatura de animaciones:** `{estado}_{direccion}` — ej: `idle_s`, `walk_nw`, `attack_sw`

### Assets de personajes generados (PixelLab)
- **Johannes** — primer personaje jugable generado con PixelLab:
  - ID en PixelLab: `1f2825e4-033d-41bc-b46a-c00ff9849af5`
  - Ruta local: `game/assets/characters/johannes/`
  - Poses estáticas (8 dir): `south.png`, `east.png`, `north.png`, `west.png`, `south-east.png`, `north-east.png`, `north-west.png`, `south-west.png`
  - Animación walk: `walk/{direction}/frame_000.png` ... `frame_007.png` (8 frames × 8 dir) ✅
  - Animación idle: `idle/{direction}/frame_000.png` ... `frame_007.png` (template `fight-stance-idle-8-frames`) ✅
  - Spritesheet completo: `johannes_spritesheet.png`
- Estilo visual: pixel art oscuro, 68×68px base, aspecto medieval fantástico

### Pendiente de implementar (character animation)
- `CharacterData.sprite` es actualmente una `Texture2D` estática — hay que migrar a `AnimatedSprite2D` con spritesheet direccional
- Necesita un componente que calcule la dirección del personaje respecto a la cámara isométrica y seleccione la animación correcta
- El flip horizontal para E, SE, NE se aplica en ese componente automáticamente

---

## Sistema de movimiento

### Controles
- **Click to move** en todo el juego (no WASD para personajes)
- **WASD / click derecho + arrastrar** → mover cámara isométrica
- **Click en casilla** → mover personaje activo
- **Click en enemigo** → atacar
- **Click derecho** → menú contextual (acciones, habilidades)

### Exploración (fuera de combate)
- Click en terreno → el **protagonista** se mueve
- El **grupo entero sigue en formación** automáticamente (`FormationManager`)
- **Separar grupo (split party):** toggle con Tab → permite seleccionar y mover personajes individualmente
- Al desactivar split party el grupo vuelve a seguir al protagonista en formación
- Implementación en `party_movement_controller.gd` + `exploration_character.gd` (ver plan)

### EventBus — señales de movimiento en exploración
```
move_to_requested(character_id: String, world_pos: Vector2)  # orden de movimiento
party_split_changed(is_split: bool)                          # Tab toggle
explorer_selected(character_id: String)                      # personaje seleccionado en split
party_regrouped                                              # todos vuelven a formación
```

### Combate
- Turno por turno según **orden de iniciativa** (gestionado por `TurnManager`)
- En tu turno: click en casilla para mover al personaje activo dentro de su velocidad
- Las casillas alcanzables se iluminan (`CombatGrid`)
- El protagonista no tiene turno especial — participa en el orden de iniciativa como los demás

---

## Escena activa — Taberna Karreth (primera escena jugable)

### Estado actual
- **Escena:** `game/scenes/taberna_karreth.tscn`
- **Main scene temporal:** `project.godot` apunta a `taberna_karreth.tscn` para testing (debe restaurarse a `main.tscn` al terminar)
- **Funciona:** click-to-move con protagonista, pathfinding, click marker visual, cámara suave
- **Pendiente:** animación de personajes, corrección de posiciones de obstáculos, menú principal

### taberna_painter.gd — pipeline de renderizado de escena
Script `@tool` en `game/scripts/world/mission_01/taberna_painter.gd`. Genera todos los sprites de la escena en bucles (no coordenadas hardcodeadas). Usa `free()` síncrono para limpiar sprites viejos antes de crear nuevos.

**Función central:**
```gdscript
func _add_sprite(x, y, depth, tex_path, sc, off_y, clip_h=0) -> void
# x,y     → iso_pos(mx,my) convertido a int
# depth   → iso_z(mx, my, layer) donde layer: 0=suelo, 1=pared, 2=objeto
# sc      → scale (4.0 para tiles 64px)
# off_y   → offset Y en espacio LOCAL (se multiplica x scale en pantalla)
# clip_h  → clip región en píxeles FUENTE (opcional)
```

**Sistema de coordenadas isométrico:**
```gdscript
const TILE_W := 256  ## ancho del diamante en pantalla
const TILE_H := 128  ## alto del diamante en pantalla
func iso_pos(mx, my) → Vector2((mx-my)*128, (mx+my)*64)  ## centro del diamante
func iso_z(mx, my, layer) → (mx+my)*10 + layer*2
## layer: 0=suelo, 1=pared, 2=objeto, 3=personaje
```

### Calibración de offsets isométricos (scale=4.0, tiles 64px)
**CRÍTICO:** `Sprite2D.offset` está en espacio LOCAL → se multiplica ×scale en pantalla.
Con scale=4: offset_y=-16 → desplazamiento real en pantalla = -64px.

| Asset | offset_y | Motivo |
|---|---|---|
| `iso_wall_block.png` (block) | **-16** | Confirmado en producción — fondo del bloque en iso_pos+64 |
| `iso_floor_wood.png` (thin tile) | **-18** | Diamante en top 14px de fuente; centro en y=14px (no en 32px) |
| `iso_wall_thick.png` (thick tile) | **-16** | Mismo anchor que block |
| Objetos (mesas, barriles, barra) | **-36** | Base bottom anclada al plano del suelo isométrico |
| Personajes | **-36** | Ídem |

**Prueba diagnóstica de floor invisible:** si el suelo no aparece, cambiar `ISO_FLOOR` a `ISO_WALL` temporalmente. Si aparece → problema de offset; si no → problema de path/z-index.

**Assets activos** (`game/assets/tilesets/taberna_custom/`, 64px PixelLab AI):
- `iso_floor_wood.png` — suelo thin tile isométrico (diamante plano) ✅ nuevo
- `iso_wall_block.png` — muro block isométrico (cubo con caras visibles) ✅ nuevo
- `iso_wall_thick.png` — muro thick tile (más bajo, paredes frontales) ✅ nuevo
- `floor_wood.png`, `wall_stone_block.png`, `wall_stone_panel.png` — tiles legacy (fallback)
- `barrels.png`, `table_round.png`, `bench.png`, `bar_counter.png`, `fireplace.png`, `door.png`, `torch.png`

**Layout de la sala (taberna_painter.gd):**
- Grid 8×8 tiles (ROOM_MIN=1, ROOM_MAX=8)
- Paredes traseras (NW mx=0 + NE my=0): `iso_wall_block.png`
- Paredes frontales (SW my=9 + SE mx=9): `iso_wall_thick.png` (más bajas, no bloquean vista)
- 6 mesas en 2 filas + barra en esquina NE + barriles + bancos

### Nodos de juego en taberna_karreth.tscn
Creados con `batch_execute` del Godot AI MCP (no por @tool):
- `Protagonista` (Node2D + `protagonista_movement.gd`) — posición iso_pos(4,4)+(0,64)
- `ClickMarker` (Node2D + `click_marker.gd`) — z_index=1000
- `PartyMovementController` (Node + `party_movement_controller.gd`)
- `NavigationRegion2D` — creado en runtime por `protagonista_movement.gd._ensure_navigation()` si no existe

**Importante sobre @tool y MCP:** Los scripts `@tool` solo re-ejecutan al ABRIR la escena físicamente en Godot, NO al usar `scene_open` del MCP. Para forzar re-ejecución: cerrar y reabrir Godot.

**Importante sobre NavigationPolygon:**
- Límite exterior: **horario** (CW) en coordenadas de pantalla
- Huecos de objetos: **antihorario** (CCW)
- Usar `add_outline()` + `make_polygons_from_outlines()` síncrono
- `NavigationObstacle2D` con `avoidance_enabled=false` (avoidance requiere CharacterBody2D)
- `parent.add_child.call_deferred(nav)` al crear desde `_ready()` (parent ocupado)

### protagonista_movement.gd
Script en `game/scripts/world/mission_01/protagonista_movement.gd`, adjunto al nodo `Protagonista`.
- Crea `NavigationAgent2D`, `AnimatedSprite2D`, `Camera2D`, `CharacterAnimator` en `_ready()` si no existen
- `Camera2D`: zoom 0.6, `position_smoothing_enabled=true`, speed 5.0, offset Vector2(0,-80)
- `NavigationAgent2D`: `avoidance_enabled=false` (Node2D no es physics body)
- `_move_frames` counter: ignora `is_navigation_finished()` los primeros 3 frames (timing del nav server)
- Recibe `EventBus.move_to_requested(character_id, world_pos)` para iniciar movimiento
- Z-index dinámico: `z_index = int(position.y / 64.0) * 10 + 1`
- assets_path: `res://assets/characters/johannes` (carga frames walk/idle en runtime)

### character_animator.gd
Script en `game/scripts/world/character_animator.gd`. Adjunto como hijo `CharacterAnimator` del personaje.
- Carga frames PNG individuales desde `assets_base_path/{walk|idle}/{direction}/frame_XXX.png`
- Crea `SpriteFrames` en runtime con animaciones `walk_south`, `idle_north-east`, etc.
- `update_direction(velocity)` — selecciona animación según vector de movimiento
- `play_idle()` — vuelve a idle manteniendo la última dirección
- Fallback: si no hay frames de idle, usa la pose estática `{direction}.png`

---

## Convenciones de código
- `snake_case` para variables, funciones y nombres de archivo
- `PascalCase` para clases y nodos en escena
- `SCREAMING_SNAKE_CASE` para constantes
- Tipos explícitos en todas las variables: `var hp: int = 0`
- Señales nombradas en pasado: `damage_dealt`, no `deal_damage`
- Funciones privadas con prefijo `_`: `func _calculate_damage()`

---

## Reglas GDScript — compatibilidad Godot 4.6 (aprendidas en depuración)

Estas reglas evitan los errores que costaron horas de debugging al portar a 4.6:

### Encoding de archivos
- Todos los `.gd` deben ser **UTF-8 sin BOM**. Un BOM (byte `EF BB BF` al inicio) causa "Parse error" inmediato.
- Usar solo **comillas ASCII** `"` (0x22) como delimitadores de string. Las comillas tipográficas `"` `"` (U+201C/U+201D) NO funcionan como delimitadores en GDScript.
- No usar `""` (doble comilla) como sustituto de em-dash dentro de strings — rompe el parser. Usar `—` (U+2014) directamente.

### Continuación de strings multilínea
- **NO usar `\` al final de línea** para continuar strings en Godot 4.6 con archivos CRLF. El parser falla silenciosamente.
- Usar **`+` explícito** para concatenar strings en múltiples líneas:
  ```gdscript
  # MAL (falla con CRLF):
  var x = "parte uno " \
      "parte dos"
  # BIEN:
  var x = "parte uno " + \
      "parte dos"
  # O mejor aún, en una sola línea si es corto.
  ```

### No sobreescribir métodos nativos de Object
- **No nombrar funciones `get()`** en clases que extienden Node/Resource. En Godot 4.6 es error sobreescribir `Object.get()`. Usar `find()`, `get_by_id()` u otro nombre.
- **`Object.get(key, default)`** ya no acepta 2 argumentos. Reemplazar con:
  ```gdscript
  # MAL: var x := my_dict.get("key", 0)   ← Variant, warning-as-error
  # BIEN:
  var x: int = my_dict.get("key", 0)
  # O si es Object.get():
  var raw = my_obj.get("key")
  var x: int = raw if raw != null else 0
  ```

### Inferencia de tipos estricta
- Godot 4.6 trata como error el warning `The variable type is being inferred from a Variant value`. Siempre declarar tipo explícito cuando la expresión devuelve Variant:
  ```gdscript
  # MAL: var score := _get_score(ability)  ← puede inferir Variant
  # BIEN: var score: int = _get_score(ability)
  ```
- Especialmente peligroso con: `Dictionary.get()`, indexación de diccionarios `dict[key]`, y funciones que retornan `Variant`.

### class_name y autoloads
- **No usar el mismo nombre** para `class_name` y un autoload registrado en project.godot. Causa `Class hides an autoload singleton`. Si el script está registrado como autoload, no necesita `class_name`.

### Enums de clases internas
- Para usar enums de otra clase sin prefijo, declarar alias constante:
  ```gdscript
  # En spell_database.gd para usar School.X en lugar de SpellData.School.X:
  const School = SpellData.School
  const CastingTime = SpellData.CastingTime
  ```

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
│   ├── world/             → BastionPlayer, FortGuard, InteractableObject, party_movement_controller.gd, exploration_character.gd, mission_01/
│   │   └── mission_01/    → taberna_painter.gd (@tool), taberna_setup.gd (@tool), protagonista_movement.gd, click_marker.gd
│   └── utils/             → RngManager
├── assets/
│   ├── tilesets/
│   │   ├── taberna_custom/ → 10 tiles PixelLab (64px): floor_wood, wall_stone_block, wall_stone_panel, barrels, table_round, bench, bar_counter, fireplace, door, torch
│   │   └── kenney_dungeon/ → tiles placeholder Kenney (fallback)
│   └── characters/
│       └── johannes/       → 8 sprites dirección + spritesheet + animaciones walk/idle
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
| **Misión Fuerte** | **Naeren** | Tiefling | Hechicera | Herencia del Arquitecto | `herencia_arquitecto` |
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

## Estado de desarrollo actual (2026-05-19)

### Funcionando
- ✅ Click-to-move protagonista (NavigationAgent2D, party_movement_controller, click_marker)
- ✅ Cámara suave (zoom 0.6, smoothing, offset -80)
- ✅ Tiles isométricos nuevos: `iso_wall_block.png`, `iso_floor_wood.png`, `iso_wall_thick.png`
- ✅ Johannes: 8 poses estáticas + 64 frames walk + 64 frames idle — todos importados
- ✅ `character_animator.gd` — carga SpriteFrames en runtime, selecciona dirección por velocidad
- ✅ `protagonista_movement.gd` — usa AnimatedSprite2D + CharacterAnimator
- ✅ 0 errores de parseo Godot 4.6
- ✅ NavigationRegion2D creado en runtime si no existe en escena

### Pendiente inmediato
- ⏳ Suelo taberna visible (offset -18 para iso_floor_wood.png — pendiente verificar tras reopen Godot)
- ⏳ Movimiento Johannes (NavigationAgent2D + _move_frames fix — pendiente verificar)
- ⏳ Animación Johannes en movimiento (CharacterAnimator conectado, falta test visual)
- ⏳ Implementar ExplorationCharacter + split party completo (plan en `.claude/plans/`)
- ⏳ Restaurar `project.godot` main scene a `main.tscn`
- ⏳ Arreglar menú principal "Nueva Partida"

### Reglas de trabajo con PixelLab para nuevas escenas
1. Siempre pedir assets en piezas modulares (tile suelo, tile pared, prop individual)
2. Usar el template de prompt con las reglas de estilo (ver sección MCP servers)
3. Para tiles isométricos: `create_isometric_tile` con shape `thin tile` (suelo) o `block` (pared)
4. Descargar con `curl` a `game/assets/tilesets/{nombre_escena}/`
5. Los offsets para cada tipo de tile están en la tabla de calibración de taberna_painter

### Garreth Ashveil — inmortalidad por clones
Garreth tiene varios clones de sí mismo repartidos. Cuando muere, su consciencia pasa automáticamente al siguiente clon — esto le da una inmortalidad práctica hasta que se eliminen todos los cuerpos. Esta mecánica es el motivo por el que secuestró a Bicho (investigación).

---

## Lo que NO debes hacer
- No escribir lógica de juego en scripts de UI
- No usar magic numbers — todo en Constants.gd
- No dejar prints de debug sin borrar antes de commit
- No crear clases de más de 300 líneas sin justificación
- No commitear con TODOs activos en main
- No cambiar IDs de subclases/clases sin actualizar los .tres correspondientes
- No registrar conjuros con datos incorrectos — usar la documentación D&D 2024 como fuente
