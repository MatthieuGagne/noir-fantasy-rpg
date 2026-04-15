# Splash Screen, Main Menu & Intro Monologue — The Hollow Men

*Authored: 2026-04-14*

---

## Overview

This document covers the design for the pre-game boot sequence: a studio splash screen, animated title card, main menu, and intro monologue. These are the first things a player sees — they establish tone before a single gameplay moment lands.

**Dialogue system:** YarnSpinner for Godot (addon)

---

## Scene Flow

```
Splash.tscn
  └─ auto-advance after ~2s → fade to black
     └─ TitleCard.tscn
          └─ player presses any key → fade to black
               └─ MainMenu.tscn
                    └─ "New Game" → fade to black
                         └─ Intro.tscn (YarnSpinner monologue)
                              └─ monologue ends → World.tscn
```

**Entry point:** `project.godot` sets `Splash.tscn` as the main scene.

**Transitions:** A thin `SceneManager` autoload handles all scene changes via a `fade_to(scene_path)` method. Black overlay animates in/out over ~0.4s.

---

## Scene 1: Splash Screen (`scenes/ui/Splash.tscn`)

- Black background
- Centered text: `"Made with Godot"` in **Monogram** font, white
- Hold ~2 seconds, then auto-fade to TitleCard
- No player interaction

---

## Scene 2: Title Card (`scenes/ui/TitleCard.tscn`)

**Background:**
- Near-black warm dark: `#0d0b0f`
- Cityscape silhouette sprite along the bottom third — placeholder PNG at 320×180px (`assets/sprites/ui/cityscape_placeholder.png`), dark silhouette shape. Intended to be replaced with final pixel art.

**Rain:**
- `GPUParticles2D` — thin pale-blue/white streaks, slight downward-right angle, sparse (~60 particles), falling in front of the cityscape

**Title:**
- `"THE HOLLOW MEN"` centered in **Monogram** font, upper half of screen, white or cold pale blue

**Prompt:**
- `"Press any key"` at bottom center in **m5x7** font, gentle pulse animation (alpha oscillation)

**Interaction:** Any key input → fade to MainMenu

---

## Scene 3: Main Menu (`scenes/ui/MainMenu.tscn`)

**Background:**
- Continuous dark background, no hard cut from TitleCard
- Title `"THE HOLLOW MEN"` remains visible at top, reduced size

**Options (Monogram font, vertically centered):**
| Option | Condition |
|--------|-----------|
| New Game | Always visible |
| Quit | Always visible |
| Continue | Hidden until a save file exists |

**Selection state:**
- Selected option: white
- Unselected option: dim gray

**Navigation:** Up/Down arrows or gamepad D-pad, Enter/Space/gamepad A to confirm

---

## Scene 4: Intro Monologue (`scenes/ui/Intro.tscn`)

**Trigger:** Selecting "New Game" from the main menu

**Visual treatment:**
- Black screen — no background image, no portrait
- Disembodied narration: pure text, cinematic and anonymous
- Reid's internal voice rendered in **m5x7** font, white, centered or left-aligned in a text box

**Dialogue system:**
- Driven by YarnSpinner for Godot
- Yarn file: `assets/dialogue/intro_monologue.yarn`
- Player presses Enter/Space to advance each line

**End state:** Monologue completion triggers fade to `World.tscn` (Beat 1 from STORY.md — rooftop)

---

## File Layout

```
scenes/
  ui/
    Splash.tscn
    TitleCard.tscn
    MainMenu.tscn
    Intro.tscn
scripts/
  ui/
    scene_manager.gd       # autoload
    splash.gd
    title_card.gd
    main_menu.gd
    intro.gd
assets/
  sprites/
    ui/
      cityscape_placeholder.png   # 320×180, dark silhouette, replace with final art
  dialogue/
    intro_monologue.yarn
addons/
  yarnspinner/             # YarnSpinner for Godot addon
```

---

## Open Questions

- Final cityscape pixel art: dimensions, district shown (The Heights? The Sprawl?), time of day
- Intro monologue text: to be written from STORY.md Beat 1 (rooftop, missing Summoner setup)
- Continue save detection: depends on save system design (not yet specced)
