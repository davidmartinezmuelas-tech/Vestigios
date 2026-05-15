# RULES REFERENCE — Vestigios
## Basado en D&D 2024 (documentación oficial del proyecto)
## ⚠ Cambio confirmado el 2026-05-15: de SRD 5.1 (2014) a D&D 2024

### Diferencias clave respecto a 2014 que afectan a Vestigios
- **Cansancio**: -2×nivel a TODAS las pruebas d20 (antes: efectos escalonados por nivel)
- **Maestría con armas**: nueva en 2024, nivel 1 de clases marciales
- **Paladín**: Lanzamiento de conjuros desde nivel 1 (antes nivel 2)
- **Explorador**: clase completamente rediseñada y equilibrada
- **Trasfondos/Orígenes**: dan +2/+1 a características + dote (antes solo habilidades)
- **Propiedades de maestría de arma**: Debilitar, Derribar, Empujar, Hender, Mellar, Molestar, Ralentizar, Rozar

---

## 1. PUNTUACIONES DE CARACTERÍSTICA

Seis características: **STR, DEX, CON, INT, WIS, CHA** (rango normal 1–20).

### Modificador
```
modificador = floor((puntuación - 10) / 2)

Puntuación  Modificador
    1           -5
   2-3          -4
   4-5          -3
   6-7          -2
   8-9          -1
  10-11          0
  12-13         +1
  14-15         +2
  16-17         +3
  18-19         +4
  20-21         +5
```

### Generación de puntuaciones (opciones)
- **Array estándar:** 15, 14, 13, 12, 10, 8 (repartir entre las 6 características)
- **Compra de puntos:** 27 puntos, coste: 8→0, 9→1, 10→2, 11→3, 12→4, 13→5, 14→7, 15→9

---

## 2. BONIFICADOR DE COMPETENCIA

Sube con el nivel del personaje (total de niveles de clase):

| Niveles | Bonificador |
|---------|-------------|
| 1–4     | +2          |
| 5–8     | +3          |
| 9–12    | +4          |
| 13–16   | +5          |
| 17–20   | +6          |

---

## 3. CLASES — RESUMEN PARA VESTIGIOS

### Bárbaro
- **Dado de golpe:** d12
- **Salvaciones:** STR, CON
- **Armadura:** ligera, media, escudos (sin armadura: 10 + DEX + CON)
- **Características principales:** STR, CON

### Bardo *(Johannes)*
- **Dado de golpe:** d8
- **Salvaciones:** DEX, CHA
- **Armadura:** ligera
- **Características principales:** CHA
- **Habilidades (elige 3):** cualquiera

### Clérigo
- **Dado de golpe:** d8
- **Salvaciones:** WIS, CHA
- **Armadura:** ligera, media, escudos
- **Características principales:** WIS

### Druida
- **Dado de golpe:** d8
- **Salvaciones:** INT, WIS
- **Armadura:** ligera, media, escudos (no metálica)
- **Características principales:** WIS

### Guerrero / Fighter *(Bicho — niveles de fighter)*
- **Dado de golpe:** d10
- **Salvaciones:** STR, CON
- **Armadura:** todas, escudos
- **Características principales:** STR o DEX

### Monje
- **Dado de golpe:** d8
- **Salvaciones:** STR, DEX
- **Armadura:** ninguna (CA = 10 + DEX + WIS sin armadura)
- **Características principales:** DEX, WIS

### Paladín *(Vael)*
- **Dado de golpe:** d10
- **Salvaciones:** WIS, CHA
- **Armadura:** todas, escudos
- **Características principales:** STR, CHA

### Pícaro / Rogue *(Bicho — niveles de rogue, Johannes)*
- **Dado de golpe:** d8
- **Salvaciones:** DEX, INT
- **Armadura:** ligera
- **Características principales:** DEX

### Hechicero / Sorcerer *(Naeren)*
- **Dado de golpe:** d6
- **Salvaciones:** CON, CHA
- **Armadura:** ninguna
- **Características principales:** CHA

### Explorador / Ranger *(Lyth)*
- **Dado de golpe:** d10
- **Salvaciones:** STR, DEX
- **Armadura:** ligera, media, escudos
- **Características principales:** DEX, WIS

### Brujo / Warlock
- **Dado de golpe:** d8
- **Salvaciones:** WIS, CHA
- **Armadura:** ligera
- **Características principales:** CHA

### Mago / Wizard
- **Dado de golpe:** d6
- **Salvaciones:** INT, WIS
- **Armadura:** ninguna
- **Características principales:** INT

---

## 4. PUNTOS DE GOLPE (HP)

```
Nivel 1:  dado_golpe_máximo + mod_CON
Nivel 2+: ceil(dado_golpe / 2) + 1 + mod_CON  (por nivel)

Ejemplos con CON 14 (+2):
  d6  nivel 1: 6+2=8    | cada nivel siguiente: 4+2=6
  d8  nivel 1: 8+2=10   | cada nivel siguiente: 5+2=7
  d10 nivel 1: 10+2=12  | cada nivel siguiente: 6+2=8
  d12 nivel 1: 12+2=14  | cada nivel siguiente: 7+2=9
```

---

## 5. CLASE DE ARMADURA (CA)

| Armadura           | CA base                    | Máx DEX |
|--------------------|----------------------------|---------|
| Sin armadura       | 10 + mod DEX               | —       |
| Armadura de cuero  | 11 + mod DEX               | —       |
| Cuero tachonado    | 12 + mod DEX               | —       |
| Cota de mallas     | 14 + mod DEX               | +2      |
| Camisote           | 13 + mod DEX               | +2      |
| Armadura de placas | 18                         | —       |
| Escudo             | +2 a cualquier CA          | —       |

**Sin armadura especial (Monje, Bárbaro):**
- Monje: 10 + DEX + WIS
- Bárbaro: 10 + DEX + CON

---

## 6. HABILIDADES Y CARACTERÍSTICAS ASOCIADAS

| Habilidad        | Característica |
|------------------|----------------|
| Atletismo        | STR            |
| Acrobacias       | DEX            |
| Sigilo           | DEX            |
| Juego de Manos   | DEX            |
| Arcanos          | INT            |
| Historia         | INT            |
| Investigación    | INT            |
| Naturaleza       | INT            |
| Religión         | INT            |
| Medicina         | WIS            |
| Perspicacia      | WIS            |
| Percepción       | WIS            |
| Supervivencia    | WIS            |
| Trato con Animales | WIS          |
| Engaño           | CHA            |
| Actuación        | CHA            |
| Intimidación     | CHA            |
| Persuasión       | CHA            |

**Tirada de habilidad:** 1d20 + mod_característica (+ bonificador de competencia si hay competencia)

---

## 7. TIRADAS DE SALVACIÓN

1d20 + mod_característica (+ bonificador de competencia si hay competencia en esa salvación)

Cada clase otorga competencia en 2 tiradas de salvación (ver sección 3).

---

## 8. COMBATE — REGLAS CORE

### Turno
Cada turno un personaje puede:
- **1 Movimiento** — hasta su velocidad (30 ft = 6 casillas)
- **1 Acción** — atacar, lanzar conjuro, ayudar, esquivar, correr, etc.
- **1 Acción adicional** — según la clase (Pícaro, Bardo, algunas habilidades)

El movimiento puede dividirse antes y después de la acción.

### Tirada de ataque
```
1d20 + mod_característica + bonificador_competencia  vs  CA del objetivo

- 20 natural → CRÍTICO (doblar dados de daño, el modificador solo se añade 1 vez)
- 1 natural  → PIFIA (fallo automático)
- Ventaja    → tirar 2d20, quedarse con el mayor
- Desventaja → tirar 2d20, quedarse con el menor
```

### Daño
```
daño = [dados de daño] + mod_característica

Crítico: [dados de daño × 2] + mod_característica
```

### Ataques de oportunidad
Cuando un enemigo **sale del alcance cuerpo a cuerpo** de un personaje sin usar Retirada, ese personaje puede usar su **reacción** para hacer un ataque cuerpo a cuerpo.

---

## 9. CONDICIONES PRINCIPALES

| Condición     | Efecto principal                                                    |
|---------------|---------------------------------------------------------------------|
| Asustado      | Desventaja en tiradas mientras vea la fuente del miedo             |
| Aturdido      | Incapacitado, falla salvaciones STR y DEX, ataques contra él con ventaja |
| Cegado        | Falla tiradas que requieran vista, desventaja en ataque, ventaja contra él |
| Derribado (prone) | Desventaja en ataques; ataques cuerpo a cuerpo contra él con ventaja |
| Envenenado    | Desventaja en tiradas de ataque y de característica                |
| Incapacitado  | No puede realizar acciones ni reacciones                           |
| Paralizado    | Incapacitado + falla STR y DEX, ataques con ventaja, crítico automático en 5ft |
| Restringido   | Desventaja en ataques, ataques contra él con ventaja, desventaja en salvaciones DEX |

---

## 10. DESCANSOS

| Tipo          | Duración | Recupera                                      |
|---------------|----------|-----------------------------------------------|
| Corto         | 1 hora   | Gastar dados de golpe para recuperar HP       |
| Largo         | 8 horas  | HP al máximo + todos los dados de golpe       |

---

## 11. PERSONAJES DE VESTIGIOS — RESUMEN

| Personaje | Clase         | Dado HP | Salvaciones    | CA  | Char. principal |
|-----------|---------------|---------|----------------|-----|-----------------|
| Johannes  | Bardo 1       | d8      | DEX, CHA       | 13  | CHA             |
| Naeren    | Hechicero 1   | d6      | CON, CHA       | 11  | CHA             |
| Lyth      | Explorador 1  | d10     | STR, DEX       | 14  | DEX             |
| Bicho     | Guerrero 1    | d10     | STR, CON       | 16  | STR             |
| Vael      | Paladín 1     | d10     | WIS, CHA       | 18  | STR, CHA        |
