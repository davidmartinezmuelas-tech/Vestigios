# GAME DEV BIBLE — Proyecto Vestigios
> Lead Game Developer Guide · Indie + IA · Godot 4 · 2026

---

## ÍNDICE

1. [Estructura de Carpetas](#estructura-de-carpetas)
2. [Convenciones de Nombres](#convenciones-de-nombres)
3. [Arquitectura de Escenas y Nodos](#arquitectura-de-escenas-y-nodos)
4. [Organización de Scripts](#organización-de-scripts)
5. [Sistema de Datos](#sistema-de-datos)
6. [Separación Gameplay / UI / Lógica](#separación-gameplay--ui--lógica)
7. [Sistema de Estados (State Machine)](#sistema-de-estados)
8. [Sistema de Combate](#sistema-de-combate)
9. [Sistema de Eventos](#sistema-de-eventos)
10. [Sistema de Estadísticas y Efectos](#sistema-de-estadísticas-y-efectos)
11. [Pipeline Artístico](#pipeline-artístico)
12. [Pipeline de Sonido](#pipeline-de-sonido)
13. [Flujo de Trabajo con GitHub](#flujo-de-trabajo-con-github)
14. [VS Code — Configuración Ideal](#vs-code--configuración-ideal)
15. [Flujo con Claude Code](#flujo-con-claude-code)
16. [Deuda Técnica — Cómo Evitarla](#deuda-técnica--cómo-evitarla)
17. [Qué Programar Primero](#qué-programar-primero)
18. [Roadmap MVP — Early Access](#roadmap-mvp--early-access)
19. [Ecosistema de IA](#ecosistema-de-ia)
20. [Prompts Reutilizables](#prompts-reutilizables)
21. [Lista de Tareas Inicial](#lista-de-tareas-inicial)
22. [Estrategia de Desarrollo Solo + IA](#estrategia-de-desarrollo-solo--ia)
23. [Mejores Prácticas — No Romper el Proyecto](#mejores-prácticas--no-romper-el-proyecto)

---

## 1. ESTRUCTURA DE CARPETAS

```
project_root/
├── .github/
│   └── workflows/
│       ├── ci.yml                    # Export automático + tests
│       └── release.yml               # Build para itch.io / Steam
│
├── .vscode/
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
│
├── docs/
│   ├── GDD.md
│   ├── ARCHITECTURE.md
│   └── CHANGELOG.md
│
├── design/
│   ├── characters/
│   ├── ui/
│   └── concept_art/
│
├── game/                             # Raíz del proyecto Godot
│   ├── project.godot
│   ├── assets/
│   │   ├── fonts/
│   │   ├── icons/
│   │   └── shaders/
│   │
│   ├── audio/
│   │   ├── music/
│   │   │   ├── combat/
│   │   │   ├── exploration/
│   │   │   └── ui/
│   │   └── sfx/
│   │       ├── combat/
│   │       ├── ui/
│   │       └── environment/
│   │
│   ├── data/
│   │   ├── characters/
│   │   │   ├── heroes/
│   │   │   └── enemies/
│   │   ├── abilities/
│   │   ├── items/
│   │   ├── effects/
│   │   └── balance/
│   │
│   ├── scenes/
│   │   ├── autoloads/
│   │   ├── core/
│   │   ├── combat/
│   │   ├── characters/
│   │   ├── dungeon/
│   │   ├── ui/
│   │   └── world/
│   │
│   └── scripts/
│       ├── autoloads/
│       ├── core/
│       ├── combat/
│       ├── characters/
│       ├── dungeon/
│       ├── items/
│       ├── abilities/
│       ├── effects/
│       ├── ui/
│       ├── save/
│       └── utils/
│
├── tests/
│   ├── unit/
│   └── integration/
│
├── tools/
│   ├── export.sh
│   └── generate_data.py
│
├── .gitignore
├── .editorconfig
└── README.md
```

---

## 2. CONVENCIONES DE NOMBRES

### Archivos
| Tipo | Convención | Ejemplo |
|------|-----------|---------|
| Scripts GDScript | snake_case.gd | `combat_manager.gd` |
| Escenas | snake_case.tscn | `combat_scene.tscn` |
| Resources | snake_case.tres | `warrior_stats.tres` |
| Sprites | snake_case_state.png | `warrior_idle.png` |
| Audio | snake_case.ogg | `sword_hit_01.ogg` |
| Shaders | snake_case.gdshader | `dissolve_effect.gdshader` |

### GDScript
```gdscript
# Clases: PascalCase
class_name CombatManager

# Constantes: SCREAMING_SNAKE_CASE
const MAX_PARTY_SIZE: int = 4
const BASE_CRIT_CHANCE: float = 0.05

# Variables: snake_case con tipos explícitos
var current_turn: int = 0
var active_character: BaseCharacter = null
var is_combat_active: bool = false

# Señales: verbo en pasado, snake_case
signal turn_started(character: BaseCharacter)
signal damage_dealt(target: BaseCharacter, amount: int)
signal combat_ended(result: CombatResult)

# Funciones privadas: prefijo _
func _calculate_damage(base: int, modifier: float) -> int:
    pass

# Funciones públicas: sin prefijo
func start_combat(heroes: Array, enemies: Array) -> void:
    pass

@export_range(0, 100) var base_accuracy: int = 75
@export var character_data: CharacterData
```

### Nodos en escenas
- Nodos de lógica: PascalCase → `CombatManager`, `TurnIndicator`
- Nodos UI: sufijo funcional → `HealthBar`, `AbilityButton`, `DamageLabel`
- Markers/Positions: sufijo Point → `SpawnPoint`, `AttackPoint`
- Timers: sufijo Timer → `AnimationTimer`, `CooldownTimer`

---

## 3. ARQUITECTURA DE ESCENAS Y NODOS

### Principio clave: Scene como unidad de comportamiento

Cada escena debe tener UNA responsabilidad clara. No mezcles lógica de combate con UI.

### Jerarquía de Autoloads (Singletons)

```
GameManager          → Estado global del juego (qué pantalla, fase)
├── EventBus         → Bus de eventos (desacopla sistemas)
├── SaveManager      → Guardar / cargar partida
├── AudioManager     → Reproducción de audio
└── UIManager        → Gestión de capas de UI, overlays
```

### Escena de Combate (CombatScene)

```
CombatScene (Node2D)
├── CombatManager (Node)          → Lógica del sistema de combate
│   ├── TurnManager (Node)        → Gestión de turnos
│   └── TargetingSystem (Node)    → Sistema de objetivos
│
├── Characters (Node2D)
│   ├── HeroParty (Node2D)
│   │   ├── Hero1 (BaseCharacter)
│   │   └── Hero2 (BaseCharacter)
│   └── EnemyGroup (Node2D)
│       └── Enemy1 (BaseCharacter)
│
├── EffectLayer (Node2D)
└── CombatUI (CanvasLayer)
    ├── TurnOrderUI
    ├── AbilityPanel
    └── HUD
```

### Estructura BaseCharacter

```
BaseCharacter (Node2D)
├── Sprite2D
├── AnimationPlayer
├── CharacterStats (Node)
├── EffectManager (Node)
├── AbilityContainer (Node)
├── HitBox (Area2D)
└── UIAnchor (Marker2D)
```

---

## 4. ORGANIZACIÓN DE SCRIPTS

### Plantilla de script estándar

```gdscript
## combat_manager.gd
## Gestiona el flujo del combate: inicio, turnos y fin.

class_name CombatManager
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal combat_started
signal combat_ended(victory: bool)
signal round_started(round_number: int)

# ============================================================
# CONSTANTES
# ============================================================
const MAX_ROUNDS: int = 50

# ============================================================
# EXPORTS
# ============================================================
@export var turn_manager: TurnManager
@export var combat_resolver: CombatResolver

# ============================================================
# VARIABLES PRIVADAS
# ============================================================
var _heroes: Array[BaseCharacter] = []
var _enemies: Array[BaseCharacter] = []
var _current_round: int = 0
var _state: CombatState = CombatState.IDLE

# ============================================================
# ENUMS
# ============================================================
enum CombatState { IDLE, HERO_TURN, ENEMY_TURN, RESOLVING, ENDED }

# ============================================================
# LIFECYCLE
# ============================================================
func _ready() -> void:
    EventBus.ability_used.connect(_on_ability_used)

# ============================================================
# API PÚBLICA
# ============================================================
func start_combat(heroes: Array[BaseCharacter], enemies: Array[BaseCharacter]) -> void:
    _heroes = heroes
    _enemies = enemies
    _current_round = 0
    _begin_round()
    combat_started.emit()

func end_combat(victory: bool) -> void:
    _state = CombatState.ENDED
    combat_ended.emit(victory)

# ============================================================
# LÓGICA INTERNA
# ============================================================
func _begin_round() -> void:
    _current_round += 1
    round_started.emit(_current_round)
    turn_manager.build_turn_order(_heroes + _enemies)
    _process_next_turn()

func _process_next_turn() -> void:
    var character := turn_manager.get_next_character()
    if character == null:
        _begin_round()
        return
    _state = CombatState.HERO_TURN if character.is_hero else CombatState.ENEMY_TURN

# ============================================================
# SEÑALES INTERNAS
# ============================================================
func _on_ability_used(user: BaseCharacter, ability: BaseAbility, targets: Array) -> void:
    combat_resolver.resolve(user, ability, targets)
    _process_next_turn()
```

---

## 5. SISTEMA DE DATOS

### Usar Resources de Godot para datos de juego

```gdscript
## character_data.gd
class_name CharacterData
extends Resource

@export var character_id: String = ""
@export var display_name: String = ""
@export var max_health: int = 100
@export var max_stress: int = 200
@export var base_speed: int = 5
@export var base_accuracy: int = 75
@export var base_dodge: int = 15
@export var base_crit_chance: float = 0.05
@export var abilities: Array[AbilityData] = []
@export var sprite: Texture2D
```

```gdscript
## ability_data.gd
class_name AbilityData
extends Resource

enum TargetType { SINGLE_ENEMY, ALL_ENEMIES, SINGLE_ALLY, ALL_ALLIES, SELF }
enum AbilityType { ATTACK, HEAL, BUFF, DEBUFF, MOVE }

@export var ability_id: String = ""
@export var display_name: String = ""
@export var ability_type: AbilityType
@export var target_type: TargetType
@export var base_damage_min: int = 0
@export var base_damage_max: int = 0
@export var accuracy_modifier: int = 0
@export var crit_modifier: float = 0.0
@export var effects: Array[EffectData] = []
@export var valid_positions: Array[int] = [1, 2, 3, 4]
@export var target_positions: Array[int] = [1, 2, 3, 4]
```

---

## 6. SEPARACIÓN GAMEPLAY / UI / LÓGICA

### Regla de oro: La lógica NUNCA llama a la UI. La UI escucha eventos.

```
┌─────────────────────────────────────────────────────┐
│                    GAME LOGIC                       │
│  (CombatManager, TurnManager, EffectManager)        │
│  Emite señales / EventBus                           │
└──────────────────────┬──────────────────────────────┘
                       │ señales/eventos
┌──────────────────────▼──────────────────────────────┐
│                    EVENT BUS                        │
│  (event_bus.gd — autoload)                          │
└──────────────────────┬──────────────────────────────┘
                       │ escucha señales
┌──────────────────────▼──────────────────────────────┐
│                    UI LAYER                         │
│  (CombatUI, HUD, StatusPanel)                       │
│  Solo lee datos, nunca modifica estado              │
└─────────────────────────────────────────────────────┘
```

### EventBus — El núcleo del desacoplamiento

```gdscript
## event_bus.gd (Autoload)
class_name EventBus
extends Node

# COMBATE
signal combat_started(heroes: Array, enemies: Array)
signal turn_started(character: BaseCharacter)
signal turn_ended(character: BaseCharacter)
signal ability_used(user: BaseCharacter, ability: AbilityData, targets: Array)
signal damage_dealt(target: BaseCharacter, amount: int, is_crit: bool)
signal healing_applied(target: BaseCharacter, amount: int)
signal character_died(character: BaseCharacter)
signal stress_changed(character: BaseCharacter, old_val: int, new_val: int)
signal combat_ended(victory: bool)

# DUNGEON
signal room_entered(room: RoomData)
signal loot_found(items: Array)

# ESTADO DE JUEGO
signal game_saved
signal game_loaded
signal scene_changed(scene_name: String)
```

---

## 7. SISTEMA DE ESTADOS

### StateMachine genérica y reutilizable

```gdscript
## state_machine.gd
class_name StateMachine
extends Node

signal state_changed(old_state: State, new_state: State)

var current_state: State = null
var previous_state: State = null
var _states: Dictionary = {}

func _ready() -> void:
    for child in get_children():
        if child is State:
            _states[child.name] = child
            child.state_machine = self
    if _states.size() > 0:
        _transition_to(_states.values()[0])

func transition_to(state_name: String) -> void:
    if not _states.has(state_name):
        push_error("StateMachine: estado no encontrado: " + state_name)
        return
    _transition_to(_states[state_name])

func _transition_to(new_state: State) -> void:
    if current_state:
        current_state.exit()
    previous_state = current_state
    current_state = new_state
    current_state.enter()
    state_changed.emit(previous_state, current_state)

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)
```

---

## 8. SISTEMA DE COMBATE

### CombatResolver — Fórmulas claras y separadas

```gdscript
## combat_resolver.gd
class_name CombatResolver
extends Node

func resolve(user: BaseCharacter, ability: AbilityData, targets: Array[BaseCharacter]) -> void:
    match ability.ability_type:
        AbilityData.AbilityType.ATTACK:
            for target in targets:
                _resolve_attack(user, ability, target)
        AbilityData.AbilityType.HEAL:
            for target in targets:
                _resolve_heal(user, ability, target)

func _resolve_attack(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> void:
    if not _roll_hit(user, ability, target):
        EventBus.attack_missed.emit(user, target)
        return
    var is_crit := _roll_crit(user, ability)
    var damage := _calculate_damage(user, ability, is_crit)
    damage = _apply_resistances(damage, target)
    target.take_damage(damage)
    EventBus.damage_dealt.emit(target, damage, is_crit)
    var stress_amount := int(damage * Constants.STRESS_PER_DAMAGE)
    target.apply_stress(stress_amount)

func _roll_hit(user: BaseCharacter, ability: AbilityData, target: BaseCharacter) -> bool:
    var hit_chance := clampf(
        (user.stats.accuracy + ability.accuracy_modifier - target.stats.dodge) / 100.0,
        Constants.MIN_HIT_CHANCE,
        Constants.MAX_HIT_CHANCE
    )
    return RngManager.roll() < hit_chance

func _roll_crit(user: BaseCharacter, ability: AbilityData) -> bool:
    var crit_chance := clampf(
        user.stats.crit_chance + ability.crit_modifier,
        0.0,
        Constants.MAX_CRIT_CHANCE
    )
    return RngManager.roll() < crit_chance

func _calculate_damage(user: BaseCharacter, ability: AbilityData, is_crit: bool) -> int:
    var base := RngManager.randi_range(ability.base_damage_min, ability.base_damage_max)
    var modified := int(base * (1.0 + user.stats.damage_modifier))
    if is_crit:
        modified = int(modified * Constants.CRIT_MULTIPLIER)
    return modified

func _apply_resistances(damage: int, target: BaseCharacter) -> int:
    return int(damage * (1.0 - target.stats.damage_resistance))
```

### TurnManager — Orden de iniciativa

```gdscript
## turn_manager.gd
class_name TurnManager
extends Node

var _turn_queue: Array[BaseCharacter] = []
var _current_index: int = 0

func build_turn_order(all_characters: Array[BaseCharacter]) -> void:
    _turn_queue = all_characters.filter(func(c): return c.is_alive())
    _turn_queue.sort_custom(func(a, b): return a.stats.speed > b.stats.speed)
    _current_index = 0

func get_next_character() -> BaseCharacter:
    while _current_index < _turn_queue.size():
        var character := _turn_queue[_current_index]
        _current_index += 1
        if character.is_alive():
            return character
    return null  # Round terminado
```

---

## 9. SISTEMA DE EVENTOS

### EventBus completo — Referencia

```gdscript
## event_bus.gd
extends Node

# COMBATE ─────────────────────────────────────────────
signal combat_started(party: Array, enemies: Array)
signal combat_ended(victory: bool, rewards: Dictionary)
signal round_started(round_number: int)
signal turn_started(character: BaseCharacter)
signal turn_ended(character: BaseCharacter)
signal ability_used(user: BaseCharacter, ability: AbilityData, targets: Array)
signal attack_missed(attacker: BaseCharacter, target: BaseCharacter)
signal damage_dealt(target: BaseCharacter, amount: int, is_crit: bool)
signal healing_applied(target: BaseCharacter, amount: int)
signal effect_applied(target: BaseCharacter, effect: EffectData)
signal effect_expired(target: BaseCharacter, effect: EffectData)
signal character_died(character: BaseCharacter)
signal stress_changed(character: BaseCharacter, new_stress: int)
signal affliction_triggered(character: BaseCharacter, affliction_type: String)
signal virtue_triggered(character: BaseCharacter, virtue_type: String)

# DUNGEON ─────────────────────────────────────────────
signal dungeon_entered(dungeon_id: String)
signal dungeon_completed(dungeon_id: String)
signal room_entered(room: RoomData)
signal room_cleared(room: RoomData)
signal loot_found(items: Array[ItemData])

# ECONOMÍA / INVENTARIO ───────────────────────────────
signal gold_changed(amount: int, total: int)
signal item_added(item: ItemData)
signal item_used(item: ItemData, target: BaseCharacter)

# NARRACIÓN ───────────────────────────────────────────
signal narrator_bark(text: String, duration: float)
signal journal_entry_added(entry: String)

# META / UI ───────────────────────────────────────────
signal scene_transition_started(scene_name: String)
signal scene_transition_ended(scene_name: String)
signal game_paused(is_paused: bool)
signal game_saved(slot: int)
signal game_loaded(slot: int)
```

---

## 10. SISTEMA DE ESTADÍSTICAS Y EFECTOS

### CharacterStats

```gdscript
## character_stats.gd
class_name CharacterStats
extends Node

var max_health: int
var max_stress: int
var base_speed: int
var base_accuracy: int
var base_dodge: int
var base_crit_chance: float

var current_health: int:
    get: return _current_health
    set(v): _current_health = clamp(v, 0, max_health)

var current_stress: int:
    get: return _current_stress
    set(v): _current_stress = clamp(v, 0, max_stress)

var _modifiers: Dictionary = {
    "accuracy": 0, "dodge": 0, "speed": 0,
    "damage": 0.0, "damage_resistance": 0.0, "crit_chance": 0.0
}
var _current_health: int = 0
var _current_stress: int = 0

func initialize(data: CharacterData) -> void:
    max_health = data.max_health
    max_stress = data.max_stress
    base_speed = data.base_speed
    base_accuracy = data.base_accuracy
    base_dodge = data.base_dodge
    base_crit_chance = data.base_crit_chance
    _current_health = max_health
    _current_stress = 0

var accuracy: int:
    get: return clamp(base_accuracy + _modifiers["accuracy"], 0, 100)

var dodge: int:
    get: return clamp(base_dodge + _modifiers["dodge"], 0, 100)

var speed: int:
    get: return max(0, base_speed + _modifiers["speed"])

var crit_chance: float:
    get: return clampf(base_crit_chance + _modifiers["crit_chance"], 0.0, 0.95)

func add_modifier(stat: String, value: Variant) -> void:
    if _modifiers.has(stat):
        _modifiers[stat] += value

func remove_modifier(stat: String, value: Variant) -> void:
    if _modifiers.has(stat):
        _modifiers[stat] -= value
```

---

## 11. PIPELINE ARTÍSTICO

### Herramientas recomendadas

| Propósito | Herramienta | Notas |
|-----------|-------------|-------|
| Pixel art | Aseprite | Estándar indie. Tags por animación. |
| Concept art | Procreate / Krita | Krita es gratuito y potente |
| Generación inicial | Midjourney + Stable Diffusion | Para referencias y concept sheets |
| Atlas de sprites | TexturePacker | Crea atlases optimizados |
| Fondo / Environment | Inkscape + Aseprite | Vectorial → pixel |

### Resolución y escala

```
Resolución base del juego: 480x270 (16:9 escalable)
Personajes: 64x64 o 128x64 px
Fondos: 480x270 px (full scene)
UI: Diseñada a 1920x1080, escala hacia abajo
```

---

## 12. PIPELINE DE SONIDO

### Herramientas

| Propósito | Herramienta |
|-----------|-------------|
| DAW | REAPER (bajo coste) o Ableton |
| SFX rápido | sfxr / jsfxr (retro) |
| Música IA | Suno AI / Udio para prototipos |
| Formato final | OGG Vorbis (Godot nativo) |

### AudioManager

```gdscript
## audio_manager.gd
class_name AudioManager
extends Node

const SFX_POOL_SIZE := 16

@onready var music_player: AudioStreamPlayer = $MusicPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _current_music: String = ""

func _ready() -> void:
    for i in SFX_POOL_SIZE:
        var player := AudioStreamPlayer.new()
        player.bus = "SFX"
        add_child(player)
        _sfx_pool.append(player)

func play_music(track_path: String, fade_duration: float = 1.0) -> void:
    if _current_music == track_path:
        return
    _current_music = track_path
    var tween := create_tween()
    tween.tween_property(music_player, "volume_db", -40.0, fade_duration)
    tween.tween_callback(func():
        music_player.stream = load(track_path)
        music_player.play()
        create_tween().tween_property(music_player, "volume_db", 0.0, fade_duration)
    )

func play_sfx(sfx_path: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
    var player := _get_free_player()
    if player == null:
        return
    player.stream = load(sfx_path)
    player.volume_db = volume_db + randf_range(-1.0, 1.0)
    player.pitch_scale = pitch + randf_range(-0.05, 0.05)
    player.play()

func _get_free_player() -> AudioStreamPlayer:
    for p in _sfx_pool:
        if not p.playing:
            return p
    return _sfx_pool[0]
```

---

## 13. FLUJO DE TRABAJO CON GITHUB

### Estrategia de ramas

```
main           → Solo releases estables
└── develop    → Integración continua
    ├── feature/combat-system
    ├── feature/dungeon-generation
    ├── fix/turn-order-bug
    └── art/character-warrior
```

### Commits: Conventional Commits

```bash
feat(combat): add critical hit system with visual feedback
fix(turn-manager): fix skip turn when character dies mid-round
art(warrior): add attack and death animations
data(balance): rebalance skeleton enemy stats
docs(combat): document CombatResolver formulas
refactor(effects): extract EffectManager to separate node
test(combat): add unit tests for damage calculation
```

### .gitignore para Godot

```gitignore
# Godot
.godot/
*.import
export.cfg
export_presets.cfg

# Builds
builds/

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/settings.json

# Archivos grandes de diseño
design/**/*.psd
design/**/*.aseprite

# Datos sensibles
*.env
```

---

## 14. VS CODE — CONFIGURACIÓN IDEAL

### settings.json

```json
{
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.formatOnSave": true,
    "editor.rulers": [100],
    "files.associations": {
        "*.gd": "gdscript",
        "*.tscn": "text",
        "*.tres": "text"
    },
    "godotTools.editorPath.godot4": "C:\\dev\\godot\\Godot_v4.3.exe",
    "[gdscript]": {
        "editor.defaultFormatter": "geequlim.godot-tools"
    },
    "editor.fontFamily": "JetBrains Mono, Fira Code, Consolas",
    "editor.fontLigatures": true,
    "editor.fontSize": 14,
    "todo-tree.general.tags": ["TODO", "FIXME", "HACK", "NOTE", "BALANCE", "AI:"],
    "workbench.colorTheme": "One Dark Pro"
}
```

### extensions.json

```json
{
    "recommendations": [
        "geequlim.godot-tools",
        "gruntfuggly.todo-tree",
        "mhutchie.git-graph",
        "eamodio.gitlens",
        "streetsidesoftware.code-spell-checker",
        "yzhang.markdown-all-in-one",
        "usernamehw.errorlens",
        "mechatroner.rainbow-csv"
    ]
}
```

---

## 15. FLUJO CON CLAUDE CODE

### CLAUDE.md — Contexto del Proyecto

```markdown
# CLAUDE.md — Vestigios

## Stack
- Godot 4.3 con GDScript
- Arquitectura: EventBus + StateMachine + Resource-driven data

## Convenciones clave
- snake_case para variables y funciones
- PascalCase para clases y nodos
- Señales en pasado: damage_dealt, not deal_damage
- Lógica NUNCA llama a UI directamente. Usa EventBus.

## Lo que NO debes hacer
- No usar _ready() para lógica de negocio. Usar initialize()
- No hardcodear valores. Usar Constants.gd o Resources
- No crear dependencias circulares entre managers
```

---

## 16. DEUDA TÉCNICA — CÓMO EVITARLA

### Reglas de hierro

1. **Ninguna clase de más de 300 líneas** sin justificación documentada
2. **Ninguna dependencia directa entre sistemas** — siempre EventBus
3. **Todo magic number en Constants.gd**
4. **Tests para toda fórmula de combate**
5. **CLAUDE.md actualizado antes de dormir**
6. **Un solo responsable por función**
7. **Commits atómicos** — un feature, un commit
8. **Ningún TODO en main**

### Checklist de commit

```markdown
- [ ] Los nombres siguen las convenciones del proyecto
- [ ] No hay magic numbers hardcodeados
- [ ] Las señales del EventBus están documentadas
- [ ] No hay lógica en scripts de UI
- [ ] Los Resources tienen tipos explícitos en @export
- [ ] No hay prints de debug sin borrar
```

---

## 17. QUÉ PROGRAMAR PRIMERO

### Orden de implementación (prioridad)

```
SEMANA 1-2: CIMIENTOS
─────────────────────
1. Estructura de carpetas y convenciones
2. Autoloads: EventBus, GameManager básico
3. Constants.gd y RngManager
4. BaseCharacter con CharacterStats
5. CharacterData Resource + 1 héroe de prueba

SEMANA 3-4: COMBATE MÍNIMO
──────────────────────────
6. CombatManager + TurnManager
7. CombatResolver (hit/miss/damage básico)
8. AbilityData Resource + 2 habilidades
9. UI mínima de combate
10. EffectManager básico

SEMANA 5-6: DUNGEON
───────────────────
11. Room como escena + RoomData Resource
12. Node map simple (3-4 nodos)
13. Transición dungeon → combate → dungeon
14. Sistema de loot básico

SEMANA 7-8: META Y GUARDADO
────────────────────────────
15. SaveData Resource
16. SaveManager (guardar/cargar JSON)
17. Town screen básico
18. Roster de héroes
```

---

## 18. ROADMAP MVP — EARLY ACCESS

### MVP (2-3 meses) — "¿Es divertido pelear?"
- [ ] 3 héroes jugables con 2 habilidades cada uno
- [ ] 5 tipos de enemigos
- [ ] 1 mazmorra de 8 salas
- [ ] Sistema de combate completo (hit/miss/crit/DOT)
- [ ] Sistema de estrés básico
- [ ] UI funcional (no pulida)
- [ ] Guardado básico

### Alpha (3-5 meses) — "¿Tiene profundidad?"
- [ ] 6+ héroes, 15+ enemigos
- [ ] 3 mazmorras distintas
- [ ] Town con 3 edificios
- [ ] Generación procedural básica
- [ ] Narrador con barks

### Demo Pública (5-8 meses) — "¿Me engancha?"
- [ ] Arte final para personajes principales
- [ ] Música original (3-5 tracks)
- [ ] 2 actos de contenido
- [ ] Pulido de UI/UX
- [ ] Trailer

### Early Access (8-14 meses)
- [ ] Contenido completo del Acto 1
- [ ] Sistema de jefe final por dungeon
- [ ] Árbol de habilidades / progresión
- [ ] Logros
- [ ] Steam page + integración

---

## 19. ECOSISTEMA DE IA

### Agentes recomendados para game dev

| Herramienta | Uso principal |
|-------------|---------------|
| **Claude Code** | Arquitectura, refactoring, debugging complejo, documentación |
| **GitHub Copilot** | Autocompletado inline rápido |
| **ChatGPT-4o** | Brainstorming de diseño, lore, narrativa |
| **Midjourney / DALL-E** | Concept art, referencias visuales |
| **Suno AI** | Prototipos de música |
| **ElevenLabs** | Voz del narrador (prototipo) |

---

## 20. PROMPTS REUTILIZABLES

### Prompt: Implementar nuevo sistema

```
Contexto del proyecto: [Pegar CLAUDE.md]

Tarea: Implementar [NOMBRE_SISTEMA] en GDScript para Godot 4.

El sistema debe:
- Seguir la arquitectura EventBus descrita en el contexto
- No crear dependencias directas con otros managers
- Usar tipos estáticos en todas las variables
- Incluir señales en pasado para eventos importantes
- Seguir las convenciones de nombres del proyecto

Empezar con la API pública antes de la implementación interna.
```

### Prompt: Revisar y refactorizar código

```
Revisar el siguiente código GDScript y:
1. Identificar violaciones de las convenciones del proyecto
2. Detectar posibles deudas técnicas
3. Sugerir refactors priorizados por impacto
4. Verificar que no haya lógica de UI en scripts de lógica

Contexto: [CLAUDE.md]
Código: [CÓDIGO]
```

### Prompt: Debugging

```
Bug en Godot 4 (GDScript):
Descripción: [DESCRIBE EL BUG]
Comportamiento esperado: [QUÉ DEBERÍA PASAR]
Comportamiento actual: [QUÉ PASA]
Error en consola: [COPIAR ERROR]
Código relevante: [CÓDIGO]
```

### Prompt: Diseño de nueva habilidad

```
Diseña una nueva habilidad para Vestigios.
Héroe: [NOMBRE Y DESCRIPCIÓN]
Rol en combate: [Tank/DPS/Support/Control]
Habilidades existentes: [LISTA]

Genera:
1. Nombre e descripción de lore (2-3 líneas)
2. Stats de la habilidad
3. Código GDScript para AbilityData Resource
4. Consideraciones de balanceo
```

---

## 21. LISTA DE TAREAS INICIAL (PRIORIZADA)

### Sprint 1 — Núcleo del proyecto (Semana 1-2)
```
[P0] Crear estructura de carpetas completa
[P0] Configurar VS Code con todas las extensiones
[P0] Inicializar repo GitHub con .gitignore correcto
[P0] Crear CLAUDE.md con contexto del proyecto
[P0] Implementar EventBus con todas las señales core
[P0] Implementar Constants.gd
[P0] Implementar RngManager con seed
[P1] Implementar BaseCharacter + CharacterStats
[P1] Crear CharacterData Resource
[P1] Crear 1 héroe de prueba con Resource
```

### Sprint 2 — Combate (Semana 3-4)
```
[P0] Implementar CombatManager + TurnManager
[P0] Implementar CombatResolver (hit/miss/damage)
[P0] Implementar AbilityData Resource
[P1] 2 habilidades de prueba para el héroe
[P1] UI mínima de combate (sin arte final)
[P1] EffectManager básico
[P2] Sistema de posiciones (carriles 1-4)
[P2] Enemy AI básica
```

### Sprint 3 — Loop básico (Semana 5-6)
```
[P0] SaveManager (guardar/cargar)
[P0] GameManager (flujo de escenas)
[P1] Dungeon con 3 salas y 1 combate
[P1] Sistema de loot simplificado
[P2] Town screen básico
```

---

## 22. ESTRATEGIA DE DESARROLLO SOLO + IA

### Filosofía de trabajo

```
TRABAJO HUMANO:
- Decisiones de diseño y dirección artística
- Revisión de código generado por IA
- Testing y QA manual
- Integración de sistemas
- Tono narrativo y lore final

TRABAJO IA (Claude Code):
- Implementación de sistemas bien definidos
- Refactoring de código existente
- Generación de boilerplate
- Debugging asistido
- Documentación técnica
```

### Ciclo de trabajo diario recomendado

```
MAÑANA (1-2h) — Planificación
1. Revisar CLAUDE.md y actualizarlo si es necesario
2. Definir 1-3 tareas concretas para hoy
3. Preparar el contexto específico para Claude

TARDE (3-4h) — Implementación
1. Trabajar con Claude Code en la tarea definida
2. Revisar, testar y ajustar el código generado
3. Commit de trabajo completo

FINAL DEL DÍA (30min) — Cierre
1. Actualizar CLAUDE.md con decisiones del día
2. Actualizar el doc de tareas
3. Git push
```

---

## 23. MEJORES PRÁCTICAS — NO ROMPER EL PROYECTO

### Las 10 Reglas de Oro

**1. CLAUDE.md es sagrado**
Actualízalo cada vez que tomes una decisión de arquitectura.

**2. Pequeño y comprobable**
Cada feature debe caber en una sesión de trabajo. Si tarda más de un día, divídela.

**3. El EventBus es el único canal**
Jamás un sistema debe conocer la implementación de otro.

**4. Los datos son Resources, no hardcode**
Si un valor puede cambiar en balanceo, es un Resource o una constante.

**5. Tests para fórmulas**
Todo cálculo de daño, curación o probabilidad tiene un test.

**6. Un responsable por clase**
Si tienes que usar "y" para describir lo que hace una clase, divídela.

**7. La UI no piensa**
Los scripts de UI solo escuchan señales y actualizan visuales.

**8. El commit es la unidad de trabajo**
Un feature completo (aunque pequeño) = un commit.

**9. Documenta las decisiones, no el código**
El código se lee solo. Lo que no se lee solo es *por qué* elegiste esa aproximación.

**10. El juego debe ejecutarse en cualquier commit**
main nunca está roto.

### Anti-patrones específicos de Godot 4 a evitar

```gdscript
# ❌ MAL — Buscar nodos por string (frágil, lento)
var manager = get_node("/root/GameManager")

# ✓ BIEN — Autoloads directos
GameManager.start_combat(heroes, enemies)

# ❌ MAL — Lógica en _process sin condición
func _process(delta):
    update_health_bar()  # 60 veces por segundo innecesariamente

# ✓ BIEN — Actualizar solo cuando cambia
func _on_health_changed(new_health: int) -> void:
    health_bar.value = new_health

# ❌ MAL — Cargar recursos en _process
func _process(delta):
    var texture = load("res://assets/warrior.png")  # HORROR

# ✓ BIEN — Precargar
const WARRIOR_TEXTURE = preload("res://assets/warrior.png")
```

---

*Documento generado para desarrollo indie con IA · Godot 4 · 2026*
*Actualizar CLAUDE.md en cada sesión de trabajo*
