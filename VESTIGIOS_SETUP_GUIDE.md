# VESTIGIOS — GUÍA DE INSTALACIÓN Y CONFIGURACIÓN
## Windows · Godot 4.3 · VS Code · Git
> Sigue los pasos en orden. No saltes ninguno.

---

## PASO 1 — INSTALAR GODOT 4.3

1. Ve a: https://godotengine.org/download/windows/
2. Descarga **"Godot Engine - .NET"** NO — descarga la versión estándar:
   **"Godot Engine"** (sin .NET, usamos GDScript)
   → Archivo: `Godot_v4.3-stable_win64.exe.zip`

3. Descomprime el ZIP donde quieras. Godot no necesita instalador.
   Recomendado: `C:\dev\godot\Godot_v4.3.exe`

4. Crea un acceso directo en el escritorio.

5. Abre Godot. Verás el Project Manager. Si se abre, está listo.

---

## PASO 2 — INSTALAR GIT

1. Ve a: https://git-scm.com/download/win
2. Descarga el instalador y ejecútalo.
3. Durante la instalación, deja todas las opciones por defecto EXCEPTO:
   - "Default editor": cambia a **"Use Visual Studio Code as Git's default editor"**
   - "Initial branch name": selecciona **"main"**
4. Termina la instalación.
5. Abre una terminal (PowerShell o CMD) y verifica:
   ```
   git --version
   ```
   Debe mostrar algo como: `git version 2.45.x`

6. Configura tu identidad (usa tu email de GitHub):
   ```
   git config --global user.name "Tu Nombre"
   git config --global user.email "tu@email.com"
   ```

---

## PASO 3 — CREAR CUENTA Y REPOSITORIO EN GITHUB

1. Si no tienes cuenta: https://github.com/signup
2. Una vez dentro, crea un repositorio nuevo:
   - Nombre: `vestigios`
   - Descripción: `RPG táctico isométrico - Vestigios`
   - Visibilidad: **Private** (tu proyecto, tu historia)
   - NO inicialices con README (lo haremos nosotros)
3. Guarda la URL del repositorio. Será algo como:
   `https://github.com/tunombre/vestigios.git`

---

## PASO 4 — INSTALAR VS CODE Y CONFIGURARLO

### 4.1 Instalar VS Code
1. Ve a: https://code.visualstudio.com/
2. Descarga e instala. Opciones por defecto están bien.
   Marca: "Agregar al PATH" y "Abrir con Code" en el menú contextual.

### 4.2 Instalar extensiones imprescindibles
Abre VS Code. Ve a la pestaña de Extensiones (Ctrl+Shift+X).
Busca e instala estas extensiones una por una:

```
IMPRESCINDIBLES:
  godot-tools              → autor: geequlim
                             (soporte GDScript, autocompletado, ir a definición)

  GitLens                  → autor: GitKraken
                             (historial de git avanzado en el editor)

  Git Graph                → autor: mhutchie
                             (visualización de ramas)

  Error Lens               → autor: usernamehw
                             (errores inline, muy útil con GDScript)

  Todo Tree                → autor: Gruntfuggly
                             (ver todos los TODO/FIXME del proyecto)

RECOMENDADAS:
  Markdown All in One      → autor: Yu Zhang
                             (para editar los GDDs dentro de VS Code)

  Rainbow CSV              → autor: mechatroner
                             (para tablas de balanceo en CSV)

  indent-rainbow           → autor: oderwat
                             (indentación coloreada, ayuda mucho con GDScript)
```

### 4.3 Configurar VS Code para Godot
1. En VS Code: Ctrl+Shift+P → "Open User Settings (JSON)"
2. Pega esta configuración (ajusta la ruta de Godot si es diferente):

```json
{
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.formatOnSave": true,
    "editor.rulers": [100],
    "editor.fontFamily": "Cascadia Code, Consolas, monospace",
    "editor.fontLigatures": true,
    "editor.fontSize": 14,
    "editor.wordWrap": "wordWrapColumn",
    "editor.wordWrapColumn": 100,
    "files.associations": {
        "*.gd": "gdscript",
        "*.tscn": "text",
        "*.tres": "text",
        "*.godot": "text"
    },
    "godotTools.editorPath.godot4": "C:\\dev\\godot\\Godot_v4.3.exe",
    "[gdscript]": {
        "editor.defaultFormatter": "geequlim.godot-tools",
        "editor.tabSize": 4
    },
    "todo-tree.general.tags": [
        "TODO", "FIXME", "HACK", "NOTE", "BALANCE", "LORE", "AI:"
    ],
    "workbench.colorTheme": "Default Dark Modern",
    "git.autofetch": true,
    "git.confirmSync": false
}
```

### 4.4 Conectar Godot con VS Code
1. Abre Godot 4.3
2. Ve a: Editor → Editor Settings
3. Busca "Text Editor / External"
4. Activa "Use External Editor"
5. En "Exec Path": pon la ruta a VS Code:
   `C:\Users\TuNombre\AppData\Local\Programs\Microsoft VS Code\Code.exe`
6. En "Exec Flags":
   `{project} --goto {file}:{line}`
7. Cierra y reabre Godot. Ahora al hacer doble clic en un .gd se abrirá VS Code.

---

## PASO 5 — CREAR LA ESTRUCTURA DEL PROYECTO

### 5.1 Crear el proyecto en Godot
1. Abre Godot → "New Project"
2. Nombre del proyecto: `vestigios`
3. Ruta: `C:\dev\vestigios\game\`
   (Importante: el proyecto Godot va dentro de una carpeta `game`,
    no en la raíz. La raíz tendrá git, docs, tools, etc.)
4. Renderer: **Forward+** (mejor para iluminación 2D dinámica)
5. Crea el proyecto.

### 5.2 Crear la estructura de carpetas
En la terminal (PowerShell), navega a `C:\dev\vestigios\` y ejecuta:

```powershell
# Carpetas raíz del repositorio
mkdir docs, design, tools, tests

# Dentro de game/ (ya existe por Godot)
cd game
mkdir assets, audio, data, scenes, scripts

# Assets
mkdir assets\fonts, assets\icons, assets\shaders, assets\tilesets

# Audio
mkdir audio\music\combat, audio\music\exploration, audio\music\bastion
mkdir audio\sfx\combat, audio\sfx\ui, audio\sfx\environment, audio\sfx\characters

# Data
mkdir data\characters\heroes, data\characters\enemies
mkdir data\abilities, data\items, data\effects, data\dialogues
mkdir data\locations, data\loot_tables, data\world_flags

# Scenes
mkdir scenes\autoloads, scenes\core
mkdir scenes\exploration, scenes\combat
mkdir scenes\dialogue, scenes\bastion, scenes\world_map
mkdir scenes\characters\heroes, scenes\characters\enemies
mkdir scenes\ui\hud, scenes\ui\menus, scenes\ui\inventory

# Scripts
mkdir scripts\autoloads, scripts\core
mkdir scripts\exploration, scripts\combat
mkdir scripts\dialogue, scripts\inventory
mkdir scripts\world, scripts\characters
mkdir scripts\abilities, scripts\effects, scripts\utils
```

### 5.3 Configurar project.godot
En Godot: Project → Project Settings

**Display / Window:**
- Width: `640`
- Height: `360`
- Mode: `canvas_items` (para pixel art limpio)
- Aspect: `keep`

**Rendering / 2D:**
- Snap 2D transforms: activado
- Snap 2D vertices: activado

**Layer Names / 2D Physics:**
- Layer 1: `world`
- Layer 2: `characters`
- Layer 3: `interactables`
- Layer 4: `triggers`
- Layer 5: `projectiles`

**Input Map** (añadir estas acciones):
```
ui_interact      → E, Enter
ui_inventory     → I, Tab
ui_map           → M
ui_bastion       → B
ui_pause         → Escape
move_up          → W, Up
move_down        → S, Down
move_left        → A, Left
move_right       → D, Right
stealth_toggle   → Ctrl izquierdo
```

---

## PASO 6 — INICIALIZAR GIT Y SUBIR A GITHUB

En la terminal, desde `C:\dev\vestigios\`:

```powershell
# Inicializar repositorio
git init
git branch -M main

# Conectar con GitHub (pon TU URL)
git remote add origin https://github.com/tunombre/vestigios.git
```

Crea el archivo `.gitignore` en la raíz del proyecto.
Contenido del `.gitignore`:

```gitignore
# Godot
game/.godot/
game/*.import
game/export_presets.cfg

# Builds
builds/

# Sistema operativo
.DS_Store
Thumbs.db
desktop.ini

# VS Code (configuración local, no compartir)
.vscode/settings.json

# Archivos grandes de diseño (usar Git LFS si los añades)
design/**/*.psd
design/**/*.aseprite

# Secretos
*.env
```

Primer commit:

```powershell
git add .
git commit -m "feat: estructura inicial del proyecto Vestigios"
git push -u origin main
```

---

## PASO 7 — CREAR EL CLAUDE.md

Crea el archivo `CLAUDE.md` en la raíz (`C:\dev\vestigios\CLAUDE.md`).
Este archivo es el contexto del proyecto para Claude Code.

```markdown
# CLAUDE.md — Vestigios

## Descripción
RPG táctico isométrico de espías en un mundo de fantasía medieval.
Inspirado en Darkest Dungeon y D&D 2025. Basado en una campaña de rol real.

## Stack
- Motor: Godot 4.3 (GDScript, sin .NET)
- Perspectiva: Isométrica 2D pixel art
- Resolución interna: 640x360 escalado
- Git + GitHub (rama main = estable, develop = trabajo activo)

## Arquitectura
- EventBus: comunicación entre sistemas (autoload)
- WorldState: flags narrativos globales (autoload)
- DataManager: carga Resources desde disco (autoload)
- StateMachine genérica y reutilizable
- La UI NUNCA contiene lógica de juego — solo escucha señales

## Convenciones
- Variables y funciones: snake_case con tipos explícitos
- Clases: PascalCase
- Señales: verbo en pasado (damage_dealt, not deal_damage)
- Constantes: SCREAMING_SNAKE_CASE
- Funciones privadas: prefijo _
- Máximo 300 líneas por script sin justificación

## El juego — contexto rápido
Velthar (aliado) vs Kethara (enemigo aparente).
La verdad: el rey de Velthar quiere ascender a nivel divino.
El rey de Kethara lo sabe y se opone, pareciendo el villano.
5 Antiguos en guerra usándose entre sí. Sin villano real.

## Personajes jugadores
- Johannes Varell: Bardo/Pícaro, baraja de naipes, busca a Sela
- Naeren "Nae": Hechicera psíquica tiefling, no habla, protegida de Lyris
- Lyth: Cazadora de Sangre harengon, busca a Garreth el Desollado
- Bicho: Ser antiguo amnésico, arco que daña Corrupción
- Vael: Paladín ex-Kethara, campeón del Antiguo de la Vida

## Superior del equipo
Lyris Nightveil — Pilar 5, drow, contacta por dispositivo mágico o en persona

## Lo que NO hacer
- No hardcodear valores — todo en Constants.gd o Resources
- No lógica de juego en scripts de UI
- No dependencias directas entre sistemas — siempre EventBus
- No get_node() entre managers — usar autoloads o @export
- No commits en main con el juego roto
```

---

## PASO 8 — VERIFICAR QUE TODO FUNCIONA

Checklist final:

```
[ ] Godot 4.3 se abre y muestra el proyecto Vestigios
[ ] Al hacer doble clic en un .gd en Godot, se abre VS Code
[ ] VS Code muestra autocompletado de GDScript (extensión godot-tools)
[ ] git status en la terminal muestra el repositorio limpio
[ ] github.com/tunombre/vestigios existe y tiene el commit inicial
[ ] El CLAUDE.md está en la raíz del proyecto
```

Si todo está marcado: **el entorno está listo.**

---

## SIGUIENTE PASO

Con el entorno listo, el orden de implementación es:

1. **Autoloads base** — EventBus, WorldState, GameManager, AudioManager
2. **Constants.gd y RngManager**
3. **Escena de exploración isométrica base** (mover personaje, tiles)
4. **Sistema de diálogo** (el más complejo, mejor hacerlo pronto)
5. **Sistema de combate táctico**

---

*Guía generada para Vestigios · Windows · Godot 4.3 · 2026*
*Si tienes problemas en algún paso, indica cuál y en qué punto falla.*
