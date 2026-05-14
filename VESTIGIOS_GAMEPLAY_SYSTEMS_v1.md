# VESTIGIOS — SISTEMAS DE GAMEPLAY
## Diseño completo de mecánicas fuera del combate
> Antes de implementar en Godot 4

---

## ÍNDICE
1. [Visión general de pantallas](#1-visión-general-de-pantallas)
2. [Sistema de diálogo y tiradas de habilidad](#2-sistema-de-diálogo-y-tiradas-de-habilidad)
3. [Exploración isométrica](#3-exploración-isométrica)
4. [Toma de decisiones — entradas, bifurcaciones, opciones](#4-toma-de-decisiones)
5. [El Bastión — mesa de planificación](#5-el-bastión--mesa-de-planificación)
6. [El mapa del mundo](#6-el-mapa-del-mundo)
7. [Sistema de equipamiento](#7-sistema-de-equipamiento)
8. [Arte y escenarios isométricos — estrategia viable](#8-arte-y-escenarios-isométricos)
9. [Arquitectura técnica en Godot 4](#9-arquitectura-técnica-en-godot-4)

---

## 1. VISIÓN GENERAL DE PANTALLAS

El juego tiene **6 pantallas principales** entre las que el jugador navega:

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUJO DE PANTALLAS                       │
│                                                             │
│  [MENÚ PRINCIPAL]                                           │
│       │                                                     │
│  [EL BASTIÓN]  ────────────────────────────────────┐       │
│  (hub central)                                     │       │
│       │                                            │       │
│  [MAPA DEL MUNDO]                                  │       │
│  (elegir destino)                                  │       │
│       │                                            │       │
│  [MISIÓN — EXPLORACIÓN ISOMÉTRICA]                 │       │
│  (moverse, interactuar, decidir)                   │       │
│       │              │                             │       │
│  [COMBATE]    [DIÁLOGO / TIRADA]                   │       │
│  (táctico)    (conversación + dados)               │       │
│       └──────────────┘                             │       │
│               │                                    │       │
│       [FIN DE MISIÓN]  ─────────────────────────── ┘       │
│       (resumen, recompensas, XP)                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. SISTEMA DE DIÁLOGO Y TIRADAS DE HABILIDAD

### Filosofía
Los diálogos no son solo narrativa — son encuentros con mecánicas propias.
Cada conversación importante tiene **opciones con peso** donde el jugador
elige qué hacer y el resultado depende de sus stats, no de la opción "correcta".

No hay opción incorrecta. Hay opciones con diferentes probabilidades y
diferentes consecuencias. Un fracaso en una tirada no bloquea el progreso
— lo desvía hacia un camino diferente.

---

### Estructura de un diálogo

```
CAPA 1 — Texto narrativo
  Lo que dice el NPC. Siempre visible.
  El narrador puede añadir contexto ("Su mandíbula se tensa levemente").

CAPA 2 — Opciones del jugador
  Entre 2 y 4 opciones visibles. Cada una puede ser:
  
  A) Opción libre (sin tirada):
     → Consecuencia directa, sin azar.
     → Usada para decisiones narrativas puras.
     Ejemplo: "Dile que no te interesa el trato."

  B) Opción con tirada de habilidad:
     → Muestra la habilidad requerida y la CD.
     → Muestra el stat del personaje activo + bonificadores.
     → El jugador ve sus probabilidades ANTES de elegir.
     Ejemplo: [ENGAÑO CD 14] "Finges ser un mercader de paso."
              Tu Influencia: +3 | Competencia: +2 | Total: +5
              Probabilidad de éxito: 55%

  C) Opción bloqueada (requisito no cumplido):
     → Visible pero inaccesible con explicación.
     → No desaparece — el jugador sabe que existe pero no puede usarla.
     Ejemplo: [INTIMIDACIÓN CD 16 — Requiere competencia] 
              "Amenázalo con consecuencias." [BLOQUEADO]

  D) Opción de personaje específico:
     → Solo disponible si ese personaje está en el grupo activo.
     Ejemplo: [SOLO NAEREN] "Nae lee sus pensamientos superficiales."
```

---

### Las tiradas de habilidad — lista completa

```
INFLUENCIA:
  Persuasión    → convencer, negociar, ganarse la confianza
  Engaño        → mentir, disimular, crear una historia falsa
  Intimidación  → asustar, presionar, forzar cooperación

PERCEPCIÓN:
  Perspicacia   → detectar mentiras, leer emociones, sentir algo raro
  Percepción    → notar detalles físicos, escuchar conversaciones,
                  detectar presencias

INTELECTO:
  Investigación → analizar pistas, encontrar información oculta
  Historia      → reconocer referencias, conocer lore del mundo
  Arcana        → identificar magia, hechizos, objetos encantados

DESTREZA:
  Sigilo        → moverse sin ser visto/oído
  Prestidigitación → robar, manipular objetos con precisión

FUERZA:
  Atletismo     → escalar, nadar, forzar puertas, perseguir
```

---

### Interfaz de tirada — Diseño visual

```
┌────────────────────────────────────────────────────────┐
│                                                        │
│  El guardia te mira con desconfianza.                  │
│  "¿Documentos? Todo el mundo necesita documentos."     │
│                                                        │
│  ─────────────────────────────────────────────────     │
│                                                        │
│  ► "Somos proveedores del Comando Sur."                │
│    [ENGAÑO  CD 13]                                     │
│    Johannes: Influencia +4, Competencia +2  →  +6      │
│    ██████████████████  65% éxito                       │
│                                                        │
│  ► "Tenemos prisa. Apártate."                          │
│    [INTIMIDACIÓN  CD 15]                               │
│    Vael: Influencia +2, Competencia +2  →  +4          │
│    ██████████████  50% éxito                           │
│                                                        │
│  ► Esperar a que se distraiga y colarse.               │
│    [SIGILO  CD 12]                                     │
│    Lyth: Destreza +4, Competencia +3  →  +7            │
│    ██████████████████████  75% éxito                   │
│                                                        │
│  ► Retroceder y buscar otra entrada.                   │
│    [Sin tirada — cambiar ruta]                         │
│                                                        │
└────────────────────────────────────────────────────────┘
```

**Detalles importantes:**
- La barra de probabilidad es orientativa, no el número exacto.
  (El jugador ve "65%" — no ve "tiras 1d20 y necesitas 8 o más".)
- Al confirmar una opción con tirada, **la animación del dado** aparece.
  Es la única vez que el azar es visible como tal.
- Éxito y fracaso tienen texto diferente — no "has fallado", sino
  la consecuencia narrativa específica de ese fallo en ese contexto.

---

### Éxito, Fracaso y Éxito Crítico / Fracaso Total

```
ÉXITO CRÍTICO (natural 20):
  El resultado supera las expectativas.
  No solo funciona — funciona mejor de lo esperado.
  Puede revelar información extra, crear ventaja futura,
  o cambiar la disposición del NPC de manera duradera.

ÉXITO NORMAL:
  Lo que querías, como querías.

FRACASO NORMAL:
  No funciona, pero el camino sigue.
  El NPC reacciona de manera adversa pero no catastrófica.
  La situación se complica, no se bloquea.

FRACASO TOTAL (natural 1):
  La pifia tiene consecuencias más serias.
  Puede alertar al NPC, llamar atención no deseada,
  o cerrar esa opción de diálogo para el resto de la misión.
  Nunca bloquea el progreso — siempre deja un camino.
```

---

### NPCs leyendo al equipo — Perspicacia pasiva

No solo el jugador hace tiradas. Los NPCs también evalúan al equipo.

Cuando el equipo miente, blufea o actúa de manera sospechosa,
el sistema hace una tirada de Perspicacia del NPC contra la tirada
de Engaño/Actuación del jugador. Si el NPC gana:

```
NPC con Perspicacia baja (10-12):
  Siente que algo no cuadra pero no sabe qué.
  → Texto extra: "Sus ojos se entrecierran un momento."
  → La siguiente tirada de Engaño con este NPC es CD +2.

NPC con Perspicacia media (14-16):
  Sospecha activamente.
  → Puede hacer preguntas difíciles (nueva tirada requerida).
  → Nivel de alerta de la zona sube en 1 si falla la siguiente.

NPC con Perspicacia alta (18+):
  Sabe que algo pasa. Puede no decirlo directamente.
  → Diálogo cambia — el NPC juega su propio juego.
  → Situación más complicada pero más interesante.
```

---

### Diálogos con el narrador — La voz narrativa

Inspirado en el narrador de Darkest Dungeon pero con identidad propia.
En momentos clave, una voz narrativa (estilo DM de partida de rol)
añade comentario a lo que ocurre.

```
Situaciones donde aparece el narrador:
- Cuando el equipo toma una decisión de alto riesgo
- Al entrar en una zona nueva con peso narrativo
- Cuando un personaje hace algo coherente con su trasfondo
- En fracasos especialmente dramáticos
- En éxitos críticos de momentos importantes

Ejemplos de narración:
  "Johannes baraja las cartas mientras habla. Siempre lo hace
   cuando está nervioso. El guardia no lo sabe."

  "Vael reconoce la armadura. La misma que llevaba hace dos años.
   El mismo ejército. El otro lado de la línea."

  "La cicatriz de Vael se calienta. Hay algo corrupto aquí.
   Cerca. Muy cerca."
```

---

## 3. EXPLORACIÓN ISOMÉTRICA

### Vista y movimiento

**Vista isométrica 2D** con pixel art.
El equipo se mueve como un grupo — un sprite líder visible,
los demás implícitos (no se ven 4 personajes moviéndose juntos,
eso sería caótico). En combate, los 4 aparecen en sus posiciones.

**Movimiento:**
- Click para mover al punto de destino (pathfinding automático)
- Los personajes evitan obstáculos automáticamente
- Zonas interactuables iluminadas al acercarse (highlight sutil)

---

### Capas del escenario isométrico

```
CAPA 0 — Suelo (tiles isométricos):
  El terreno base. Piedra, tierra, madera, agua, etc.
  Determina si hay penalización de movimiento.

CAPA 1 — Objetos bajos (mismo nivel que el personaje):
  Mesas, cajas, arbustos, charcos.
  Algunos son interactuables. Algunos tienen loot detrás/debajo.

CAPA 2 — Objetos altos (por encima del personaje):
  Paredes, árboles, columnas.
  Se vuelven semitransparentes cuando el personaje pasa detrás.

CAPA 3 — Techo / Techo interior:
  Se elimina cuando el personaje está bajo él (vista de planta).

CAPA 4 — Efectos y luz:
  Iluminación dinámica. Sombras. VFX de magia o corrupción.
```

---

### Interacciones en escenario

```
OBJETOS INTERACTUABLES (icono al acercarse):
  Cofre/contenedor  → loot, items
  Puerta            → abrir / forzar (Atletismo) / desbloquear (herramientas)
  Palanca/mecanismo → puzzle ambiental
  Documento/nota    → lore, información de misión
  Cuerpo caído      → loot, información (Medicina para detalles)
  NPC               → diálogo

ZONAS ESPECIALES:
  Zona elevada      → ventaja en ataques a distancia si se combate aquí
  Zona oscura       → penalización Percepción, bonus Sigilo
  Zona corrupta     → riesgo de estado Expuesto si se permanece mucho
  Cobertura         → reducción de daño a distancia en combate

SECRETOS:
  Algunos objetos o zonas solo son visibles/interactuables si:
  - El personaje líder pasa cerca (radio de detección pasiva)
  - Se hace una tirada activa de Percepción o Investigación
  - Un personaje específico está en el grupo (Bicho detecta
    resonancias, Vael detecta Corrupción con su cicatriz)
```

---

### El sigilo en exploración

Antes de entrar en zona con enemigos, el jugador puede activar
**modo sigilo** (icono en HUD). En este modo:

```
MODO SIGILO ACTIVO:
  - Movimiento más lento (animación de agachado)
  - Cono de visión de los enemigos visible en el escenario
  - El equipo solo es detectado si entra en el cono + falla Sigilo
  - Tirada de Sigilo automática al cruzar zona de riesgo
    (CD según el tipo de guardia)
  - Si se detectan: Nivel de Alerta +1, opción de huir o combatir

CONO DE VISIÓN DE ENEMIGOS:
  - Ángulo visible (generalmente 90°-120°)
  - Distancia según tipo de enemigo y condiciones de luz
  - En zonas oscuras: distancia reducida
  - Con antorcha cerca del guardia: distancia aumentada

APERTURA POR SORPRESA:
  Si el equipo inicia el combate sin ser detectado:
  → Ronda gratis antes de que los enemigos actúen
  → Todos los ataques de esa ronda con ventaja
  → Ataque furtivo de Johannes aplica automáticamente
```

---

### Bifurcaciones en escenario — El ejemplo del fuerte

Las decisiones de "cómo entramos" no son un menú — son opciones
visibles en el escenario que el jugador descubre explorando.

```
EJEMPLO — Llegada al Fuerte de Piedra Gris:

El jugador llega a una zona de observación con vista al fuerte.
Un punto de interacción: "Estudiar el fuerte" [PERCEPCIÓN CD 10]
→ Éxito: Se marcan en el mapa los puntos de entrada disponibles.
→ Fracaso: El jugador ve el fuerte pero sin información adicional.
           Puede explorar a ciegas.

PUNTOS DE ENTRADA (visibles/descubribles en el escenario):

[PUERTA PRINCIPAL] — siempre visible
  → Al acercarse: opción de diálogo con guardias
  → Opciones: Engaño (documentos), Distracción, Observar patrón

[ZONA COSTERA] — visible si exploraron el flanco sur
  → Al acercarse: opción de entrar al agua
  → Requiere: decidir si nadar o usar bote (si tienen)

[MURALLA NORTE] — visible si rodearon el fuerte
  → Al acercarse: punto de escalada marcado
  → Requiere: equipo de escalada O Atletismo CD 14

Cada entrada lleva a una zona diferente del escenario interior.
No hay entrada "correcta" — hay entradas con diferentes
dificultades y diferentes ventajas de posición inicial.
```

---

## 4. TOMA DE DECISIONES

### Bifurcaciones de ruta — El ejemplo del bosque vs camino

```
PUNTO DE DECISIÓN EN ESCENARIO:
  El carro está en un cruce. Dos caminos visibles.
  Un punto de interacción: el cochero (o mapa que llevan).

  → "El camino principal es más rápido. Llegaréis de noche."
  → "El bosque es más largo. Llegaréis al amanecer."

  El jugador mueve al personaje hacia el camino que elige.
  No hay menú de selección — la decisión es física en el escenario.
  Moverse hacia el bosque ES elegir el bosque.
```

### Decisiones con consecuencias diferidas

Algunas decisiones no tienen consecuencias inmediatas.
El juego las recuerda y las usa más tarde.

```
SISTEMA DE FLAGS NARRATIVOS:
  Cada decisión importante activa un flag en el save:

  "rescataste_a_todos_los_civiles": true/false
  "interrogaste_al_soldado_taberna": true/false
  "ruta_elegida_tutorial": "camino"/"bosque"
  "naris_matados": true/false
  "nivel_alerta_fuerte": 0/1/2/3

Estos flags afectan:
  - Diálogos futuros con Lyris y otros NPCs
  - Disponibilidad de ciertos contactos
  - Reputación con facciones
  - Lore adicional disponible en el Bastión
```

---

## 5. EL BASTIÓN — MESA DE PLANIFICACIÓN

### La pantalla del Bastión

No es un menú abstracto — es una **escena isométrica** del interior
del Bastión donde el jugador puede moverse y interactuar con objetos.

```
ZONAS INTERACTUABLES DEL BASTIÓN:

[MESA DE MAPAS / TABLÓN] → abre el Mapa del Mundo
  Documentos, mapas, marcas de misiones disponibles.
  Lyris aparece aquí para dar briefings.

[COFRE DE EQUIPO / INVENTARIO] → gestión de equipamiento
  Equipo de todos los personajes, inventario compartido.

[MÓDULOS INSTALADOS] → cada módulo es una zona interactuable
  Al acercarte a la Forja: menú de crafteo y encargos.
  Al acercarte al Herbolario: gestión de plantas y pociones.
  Al acercarte a la Sala de Sanación: curar condiciones.

[PERSONAJES EN DESCANSO] → ficha de cada personaje
  Los personajes están visibles en el Bastión descansando.
  Al hablar con ellos: diálogo de desarrollo de personaje,
  posibles conversaciones de lore, subida de nivel si corresponde.

[MILD] → aparece cuando quiere
  Al interactuar: diálogo peculiar + opción de viaje rápido
  si Mild está de humor para ello.
```

### El briefing de misión

Cuando el jugador interactúa con la Mesa de Mapas,
Lyris aparece (o contacta mediante el dispositivo mágico)
y da el briefing de la misión siguiente.

```
ESTRUCTURA DEL BRIEFING:

1. NARRACIÓN: Lyris explica la situación.
   (Voz + texto + imagen de la zona objetivo)

2. OBJETIVOS: Lista clara de objetivos principales y secundarios.
   Objetivo principal: siempre visible.
   Objetivos secundarios: pueden estar ocultos hasta que se descubren.

3. INFORMACIÓN DISPONIBLE: según nivel de Sala de Inteligencia.
   Nivel 0: solo lo que Lyris sabe.
   Nivel 1: mapa aproximado de la zona.
   Nivel 2: mapa + número de enemigos + refuerzos.
   Nivel 3: todo lo anterior + perfil del objetivo principal.

4. PREPARACIÓN:
   → Elegir qué 4 personajes van (si hay más de 4 disponibles)
   → Revisar equipamiento antes de salir
   → Comprar/usar consumibles del Bastión

5. CONFIRMAR SALIDA → abre el Mapa del Mundo
```

---

## 6. EL MAPA DEL MUNDO

### Concepto visual

Un mapa ilustrado estilo "cartografía antigua" con pixel art.
No es un mapa satelital — tiene estética de mapa de campaña:
territorios dibujados a mano, iconos de ciudades, rutas marcadas,
zonas de guerra sombreadas.

```
ELEMENTOS DEL MAPA:

LOCALIZACIONES (iconos clicables):
  Ciudad aliada    → icono de castillo/ciudad, color Velthar
  Ciudad neutral   → icono diferente, sin color de bando
  Ciudad enemiga   → icono de Kethara, accesible en sigilo
  Zona de guerra   → territorio variable, cambia según el estado del conflicto
  Punto de misión  → icono especial cuando hay misión disponible
  Bastión          → siempre visible, es la posición actual del equipo

ESTADO DEL MUNDO:
  El mapa refleja el progreso de la guerra.
  Territorios pueden cambiar de color según las misiones completadas.
  Zonas de Corrupción se marcan con un efecto visual específico.

RUTAS:
  Al seleccionar un destino, se muestra la ruta posible.
  Si la ruta pasa por zona peligrosa: aviso de posibles encuentros.
  Tiempo de viaje estimado (no afecta gameplay, solo flavor).
```

### Selección de destino

```
El jugador clica en una localización disponible.
Aparece un panel lateral:

┌─────────────────────────────────────────┐
│  ARCANIS — Ciudad Academia              │
│  ─────────────────────────────────────  │
│  Estado: Neutral (aliada tras el arco)  │
│  Distancia: Larga                       │
│                                         │
│  MISIÓN DISPONIBLE:                     │
│  ► "Lo que hay bajo la Aguja"           │
│    Tipo: Infiltración + Investigación   │
│    Dificultad: ████████ Alta            │
│                                         │
│  ACTIVIDADES:                           │
│  ► Visitar a Bofri Ironmantle           │
│  ► Mercado de Arcanis                   │
│                                         │
│  [VIAJAR A ARCANIS]  [CANCELAR]        │
└─────────────────────────────────────────┘
```

---

## 7. SISTEMA DE EQUIPAMIENTO

### Pantalla de equipamiento

Accesible desde el Bastión (cofre de equipo) o desde la ficha
de personaje. Vista clara de los slots de cada personaje.

```
SLOTS DE EQUIPAMIENTO POR PERSONAJE:

┌─────────────────────────────────────────────────────┐
│  JOHANNES VARELL  — Nivel 5                         │
│  ─────────────────────────────────────────────────  │
│                                                     │
│  [CABEZA     ] Capucha de las Sombras (Poco Común)  │
│  [CUERPO     ] Chaleco de Cuero Reforzado (Mundano) │
│  [MANO PPAL  ] La Baraja de Varell (Única)          │
│  [MANO 2ª   ] Daga Corta (Mundano)                  │
│  [PIES      ] Botas Silenciosas (Poco Común)        │
│  [ACCESORIO 1] Anillo del Fullero (Raro)            │
│  [ACCESORIO 2] — vacío —                            │
│  [SINTONIZADOS: 1/3]                                │
│                                                     │
│  CA total: 14  |  Velocidad: 9m  |  Iniciativa: +4  │
└─────────────────────────────────────────────────────┘
```

### Gestión de inventario

```
INVENTARIO COMPARTIDO DEL BASTIÓN:
  Almacenamiento ilimitado en el Bastión (espacio dimensional).
  Peso limitado en misión: cada personaje lleva hasta X unidades.
  Los objetos del Bastión no se pueden acceder en misión
  (salvo que el módulo específico lo permita).

INVENTARIO EN MISIÓN (por personaje):
  Capacidad: 10 slots de objeto por personaje + equipo puesto.
  Consumibles: pociones, herramientas, munición especial.
  Objetos clave de misión: no ocupan slot (separados).

TRANSFERIR OBJETOS:
  En el Bastión: drag & drop entre personajes y almacén.
  En misión: solo entre personajes adyacentes, como acción de bonus.
```

### Identificación de objetos

Los objetos de rareza Raro o superior aparecen como
"[Objeto desconocido — Raro]" hasta que son identificados.

```
MÉTODOS DE IDENTIFICACIÓN:
  Descanso largo en el Bastión: identifica automáticamente hasta 3 objetos
  Sala de Inteligencia nivel 1+: identifica 1 objeto extra/descanso
  Habilidad Arcana (Intelecto CD 15): identifica en campo, sin descanso
  Bofri Ironmantle (en Arcanis): identifica cualquier objeto al instante
  Tienda especializada: identificación por precio
```

---

## 8. ARTE Y ESCENARIOS ISOMÉTRICOS — ESTRATEGIA VIABLE

### Resolución recomendada

```
Tile base isométrico: 64x32 px (estándar de pixel art iso)
Personajes: 32x48 px (más altos que el tile para visibilidad)
Resolución interna del juego: 640x360 (escalable a cualquier pantalla)
Escala visual: x2 o x3 al renderizar (pixel art limpio)
```

### Fuentes de arte gratuitas o de bajo coste

```
TILES ISOMÉTRICOS (terreno y objetos):
  itch.io — buscar "isometric pixel art tileset"
  Hay packs completos de 5-15€ con licencia comercial.

  Kenney.nl — assets gratuitos de dominio público
  Tiene pack isométrico básico: perfecto para prototipo.

PERSONAJES:
  Los personajes de Vestigios son pocos y definidos.
  Mejor hacerlos en Aseprite usando referencias de Midjourney.
  Animaciones mínimas por personaje:
    idle (4-6 frames), walk (6-8 frames), attack (6-8 frames),
    hurt (3-4 frames), death (6-8 frames)

FONDOS PARA PANTALLAS NARRATIVAS:
  (El Bastión, mapa del mundo, pantalla de diálogo)
  Generación con Midjourney → filtro de pixel art (Aseprite o plugin)
  Estas son pantallas estáticas — el proceso funciona muy bien aquí.
```

### Pipeline de producción de un escenario nuevo

```
1. CONCEPTO (30 min):
   Prompt en Midjourney para referencias visuales del área.

2. LAYOUT (1-2 horas):
   En Godot: colocar tiles del pack comprado/descargado.
   Definir zonas: entrada, obstáculos, zonas interactuables, salida.

3. TESTING (1 hora):
   Probar que el pathfinding funciona.
   Probar que las zonas interactuables responden.
   Probar los encuentros de combate en el espacio.

4. ARTE PERSONALIZADO (variable):
   Añadir elementos únicos del escenario en Aseprite.

5. ILUMINACIÓN Y ATMÓSFERA (1-2 horas):
   Añadir luces dinámicas en Godot.
   Zonas oscuras, antorchas, luz corrupta.

6. AUDIO (30 min):
   Música de ambiente asignada.
   Sonidos de ambiente (pasos, viento, agua).
```

---

## 9. ARQUITECTURA TÉCNICA EN GODOT 4

### Nuevas escenas necesarias

```
game/scenes/
├── world/
│   ├── world_map.tscn          — Mapa del mundo interactivo
│   └── location_panel.tscn     — Panel de localización al clicar
│
├── bastion/
│   ├── bastion_scene.tscn      — Escena isométrica del Bastión
│   ├── planning_table.tscn     — Mesa de planificación
│   ├── equipment_screen.tscn   — Pantalla de equipamiento
│   └── module_*.tscn           — Una escena por módulo
│
├── exploration/
│   ├── exploration_scene.tscn  — Escena base de exploración iso
│   ├── stealth_system.tscn     — Sistema de sigilo (nodo hijo)
│   ├── enemy_patrol.tscn       — Patrulla con cono de visión
│   └── interactable.tscn       — Objeto interactuable genérico
│
├── dialogue/
│   ├── dialogue_ui.tscn        — UI completa de diálogo
│   ├── skill_check_panel.tscn  — Panel de tirada de habilidad
│   ├── dice_animation.tscn     — Animación del dado
│   └── narrator_bark.tscn      — Texto del narrador
│
└── inventory/
    ├── inventory_screen.tscn   — Pantalla de inventario completa
    ├── item_slot.tscn          — Slot de equipo individual
    ├── item_tooltip.tscn       — Tooltip de objeto
    └── item_compare.tscn       — Comparador de equipo
```

### Nuevas señales en EventBus

```gdscript
# Añadir a event_bus.gd:

# EXPLORACIÓN
signal area_entered(area_id: String)
signal interactable_activated(interactable: Node)
signal secret_discovered(location: Vector2, secret_id: String)
signal stealth_detected(detector: Node, detected: Node)
signal alert_level_changed(old_level: int, new_level: int)

# DIÁLOGO
signal dialogue_started(dialogue_id: String, npc: Node)
signal dialogue_ended(dialogue_id: String, outcome: String)
signal skill_check_requested(skill: String, cd: int, character: CharacterSheet)
signal skill_check_resolved(skill: String, success: bool, roll: int, total: int)
signal narrator_bark_triggered(text: String, context: String)
signal npc_disposition_changed(npc_id: String, delta: int)

# MUNDO
signal world_flag_set(flag: String, value: Variant)
signal location_unlocked(location_id: String)
signal location_visited(location_id: String)

# INVENTARIO
signal item_equipped(character: CharacterSheet, item: ItemInstance, slot: String)
signal item_unequipped(character: CharacterSheet, slot: String)
signal item_identified(item: ItemInstance)
signal loot_generated(items: Array[ItemInstance], source: String)
```

### WorldState — Sistema de flags narrativos

```gdscript
## world_state.gd (Autoload)
class_name WorldState
extends Node

var _flags: Dictionary = {}
var _faction_relations: Dictionary = {
    "velthar_crown": 50,
    "kethara": -50,
    "meredan_neutral": 0,
    "arcanis": 0,
    "hunters_church": 0,
    "meredan_crime": 0,
}

func set_flag(key: String, value: Variant) -> void:
    _flags[key] = value
    EventBus.world_flag_set.emit(key, value)

func get_flag(key: String, default: Variant = null) -> Variant:
    return _flags.get(key, default)

func has_flag(key: String) -> bool:
    return _flags.has(key)

func modify_relation(faction: String, delta: int) -> void:
    if _faction_relations.has(faction):
        _faction_relations[faction] = clamp(
            _faction_relations[faction] + delta, -100, 100
        )

func get_relation(faction: String) -> int:
    return _faction_relations.get(faction, 0)

func serialize() -> Dictionary:
    return {
        "flags": _flags.duplicate(),
        "relations": _faction_relations.duplicate()
    }

func deserialize(data: Dictionary) -> void:
    _flags = data.get("flags", {})
    _faction_relations = data.get("relations", _faction_relations)
```

---

## RESUMEN — ORDEN DE IMPLEMENTACIÓN

```
FASE 1 — Fundamentos de exploración:
  1. Escena isométrica base con tiles
  2. Movimiento del personaje (click to move, pathfinding)
  3. Sistema de interactuables básico
  4. Capas de renderizado isométrico correctas

FASE 2 — Diálogo:
  5. DialogueData Resource y árbol de diálogo
  6. UI de diálogo básica (texto + opciones)
  7. Sistema de skill check en diálogo
  8. Animación del dado
  9. Sistema de flags (WorldState)

FASE 3 — Exploración completa:
  10. Sistema de sigilo y cono de visión
  11. IA de patrullas básica
  12. Zonas especiales (corrupta, elevada, oscura)
  13. Sistema de secretos y detección pasiva

FASE 4 — Bastión y mapa:
  14. Escena del Bastión (iso navegable)
  15. Mesa de planificación y briefing
  16. Mapa del mundo interactivo
  17. Panel de localización

FASE 5 — Equipamiento:
  18. Slots de equipo por personaje
  19. Inventario con gestión drag & drop
  20. Sistema de identificación de objetos
  21. Comparador de equipo

FASE 6 — Integración con combate:
  22. Transición exploración → combate
  23. Apertura por sorpresa desde sigilo
  24. Posicionamiento inicial según punto de entrada
```

---

*VESTIGIOS — Sistemas de Gameplay v1.0*
*Este documento define CÓMO se juega. El GDD Maestro define QUÉ se juega.*
*Implementar en el orden indicado — cada fase depende de la anterior.*
