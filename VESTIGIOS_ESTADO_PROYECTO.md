# VESTIGIOS — ESTADO DEL PROYECTO
## Documento de continuidad · v1.2

---

## DÓNDE LO DEJAMOS

**Último paso completado:** Todas las preguntas abiertas del GDD resueltas.
**Siguiente paso:** Instalar el entorno (VESTIGIOS_SETUP_GUIDE.md) y empezar en Godot 4.3.

**Orden de implementación acordado:**
1. Autoloads base (EventBus, WorldState, GameManager, AudioManager)
2. Constants.gd y RngManager
3. Escena de exploración isométrica base
4. Sistema de diálogo con tiradas de habilidad
5. Sistema de combate táctico

---

## QUÉ TENEMOS COMPLETAMENTE DEFINIDO

- ✓ Nombre del juego: **Vestigios**
- ✓ Mundo: Velthar, Kethara, Meredan, Arcanis
- ✓ La verdad de la guerra: Aldric Voss quiere robar poder de los 5 Antiguos. Maerek Solden lo sabe y se opone siendo el "villano".
- ✓ Los Cinco Antiguos: El Poder, Las Profundidades, La Vida, El Arquitecto, El Vacío
- ✓ Campeones: Vael (La Vida), Seraphel/Naeren (El Arquitecto), Gideon Wulf (El Vacío)
- ✓ Los Cinco Pilares de Velthar
- ✓ Las Diez Cadenas de Kethara
- ✓ Árbol familiar Voss: Aldric → Caelum → Seraphel
- ✓ Familia Morvane: Maerek → Eryndas + Morrivan + Valdris + Mía
- ✓ Todos los PJs: Johannes, Naeren, Lyth, Bicho, Vael
- ✓ NPCs: Lyris, Sela, Calder Reth, Garreth, Gideon, Alderich, Mild, Mía
- ✓ Iglesia de Cazadores de Meredan
- ✓ Misión tutorial: El Fuerte de Piedra Gris
- ✓ Todos los sistemas de gameplay diseñados
- ✓ Arquitectura técnica de Godot 4

---

## PREGUNTAS RESUELTAS EN LA ÚLTIMA SESIÓN

| Pregunta | Respuesta |
|----------|-----------|
| Gideon: ¿campeón del Vacío? | Sí, confirmado |
| El Vacío: ¿fragmento físico? | No tiene — actúa solo por campeones |
| Naeren: origen de poderes | Psionismo forzado → perdió la voz → roce del Arquitecto |
| Jefe del crimen: nombre | Calder Reth, tiefling rojo |
| Garreth: qué aprendió de Bicho | Mecanismo de transferencia de consciencia entre clones |
| Antiguo de la Vida: forma | Femenina, Vael percibe ecos de su voz |
| Ritual de Aldric | Roba porciones de poder de los 5 Antiguos |
| Gemelos Ashford: historia | Pueblo destruido por la guerra, sobrevivieron juntos |
| Vaela Mirage: razón de lore | Olvidó su forma real de tanto habitar ilusiones |

---

## PENDIENTE (baja prioridad)

- [ ] Sylvara Dusk: familia en Kethara
- [ ] Mía: cómo y cuándo reaparece (abierto intencionadamente)
- [ ] Fichas completas de clase de cada PJ por nivel
- [ ] Sistema de magia detallado (hechizos por clase)
- [ ] Tablas de loot completas

---

## DOCUMENTOS ACTIVOS (los únicos que necesitas)

| Archivo | Contenido |
|---------|-----------|
| `VESTIGIOS_GDD_MAESTRO_v1_2.md` | Lore, personajes, mundo — versión definitiva |
| `VESTIGIOS_GAMEPLAY_SYSTEMS_v1.md` | Sistemas de juego completos |
| `VESTIGIOS_SETUP_GUIDE.md` | Instalación Godot + VS Code + Git |
| `GAME_DEV_BIBLE.md` | Arquitectura Godot, convenciones de código |
| `VESTIGIOS_ESTADO_PROYECTO.md` | Este archivo |

---

## CÓMO RETOMAR EN CUALQUIER SESIÓN FUTURA

1. Abre Claude o Claude Code
2. Di: *"Continuamos Vestigios. Lee el estado del proyecto."*
3. Pega el contenido de este archivo
4. Continúa desde el "Siguiente paso" de arriba

*Última actualización: Mayo 2026*
