# Vestigios

Dark fantasy RPG in development, built in Godot 4.

Two kingdoms have been at war for generations. Behind the conflict is something older: five cosmic entities using mortals as pawns in a struggle that predates the world itself. A king has found a way to steal power from all five at once — and five characters are about to discover they're the only ones who can stop him.

---

## World

| Region | Description |
|---|---|
| **Velthar** | Northern kingdom — militaristic, declining, desperate |
| **Kethara** | Southern theocracy — outwardly stable, internally fractured |
| **Meredan** | Contested border territory — lawless, ruined, full of scars |
| **Arcanis** | Corruption zones — interdimensional spaces where reality breaks down |

---

## The Five Ancients

Cosmic entities that predate the world. They cannot act directly without destroying reality, so they work through mortal champions. The player characters are those champions — whether they know it or not.

| Ancient | Domain |
|---|---|
| The Architect | Structure, law, order |
| The Abyss | Void, entropy, annihilation |
| The Verdant | Life, growth, corruption |
| The Sovereign | Power, will, dominance |
| The Deep | Knowledge, profundity, madness |

---

## Gameplay Systems

- **Champion mechanics** — each character is tied to an Ancient; abilities evolve through trauma and cosmic contact
- **Corruption zones** — optional areas offering stat gains and lore at a cost to the character
- **Skill-check dialogue** — branching conversations that reward your build
- **Tactical combat** — turn-based, position-aware, ability-driven
- **Narrative-driven progression** — characters change through what happens to them, not just XP

---

## Characters

5 playable characters, each tied to one of the Ancients, with full backstory, motivation, arc, and psychological profile defined in the GDD.

---

## Tech Stack

| Area | Technology |
|---|---|
| Engine | Godot 4 |
| Language | GDScript |
| Architecture | Autoload singletons: EventBus, WorldState, GameManager, AudioManager |
| Version control | Git |

---

## Status

Design phase complete. Implementation starting.

- [x] 4 regions with full worldbuilding
- [x] 5 playable characters + 8 NPCs designed
- [x] Narrative architecture and main story arc
- [x] All gameplay systems documented
- [x] Godot 4 technical architecture defined
- [ ] Base autoloads (EventBus, WorldState, GameManager, AudioManager)
- [ ] Isometric exploration prototype
- [ ] Dialogue system with skill checks
- [ ] Tactical combat prototype
- [ ] First playable vertical slice

---

## Documentation

| File | Contents |
|---|---|
| `VESTIGIOS_GDD_MAESTRO_v1_2.md` | Master game design document |
| `GAME_DEV_BIBLE.md` | Style, tone, and development reference |
| `VESTIGIOS_GAMEPLAY_SYSTEMS_v1.md` | All mechanics in detail |
| `LORE_NPCS_HISTORICOS.md` | World lore and NPC profiles |
| `RULES_REFERENCE.md` | Combat and skill check rules |
| `VESTIGIOS_SETUP_GUIDE.md` | Dev environment setup |
