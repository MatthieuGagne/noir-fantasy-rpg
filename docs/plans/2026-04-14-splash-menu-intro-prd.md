# PRD: Splash Screen, Main Menu & Intro Monologue

*Product: The Hollow Men*
*Authored: 2026-04-14*
*Status: Approved*

---

## Problem Statement

The game currently has no entry point beyond raw scene files. A player launching the build sees either nothing or drops directly into an unfinished world scene. We need a complete boot sequence that establishes tone, introduces the title, and leads the player into the opening story moment.

---

## Goals

- Deliver a complete, shippable boot sequence from launch to first gameplay moment
- Establish the noir-horror atmosphere before any mechanics are introduced
- Lay the YarnSpinner dialogue foundation that will serve the rest of the game
- Keep scope minimal — no features beyond what the opening sequence requires

## Non-Goals

- Save/load system (Continue option is hidden until that system exists)
- Options/settings menu
- Character select or difficulty screen
- Full dialogue system UI (portraits, speaker names) — intro monologue is narration only
- Final pixel art assets — cityscape ships as a placeholder PNG

---

## User Stories

**As a player launching the game for the first time:**
- I see a brief studio splash so I know what engine/studio made this
- I see an atmospheric title card that sets the mood before I do anything
- I press a key and land on a clean main menu
- I select New Game and experience a narrated prologue before the world loads

**As a returning player:**
- I see the same boot sequence (consistent re-entry)
- Continue is available once a save exists (future milestone)

---

## Functional Requirements

### FR-1: Scene Manager
- An autoload `SceneManager` singleton must handle all scene transitions
- Transitions use a full-screen black fade (~0.4s in, swap scene, ~0.4s out)
- API: `SceneManager.fade_to(scene_path: String)`

### FR-2: Splash Screen
- Displays `"Made with Godot"` in Monogram font on a black background
- Auto-advances to TitleCard after approximately 2 seconds
- No player input required or accepted

### FR-3: Title Card
- Background color: `#0d0b0f`
- Displays a cityscape silhouette sprite (`assets/sprites/ui/cityscape_placeholder.png`, 320×180px) in the bottom third of the screen
- Displays `GPUParticles2D` rain: pale-blue/white streaks, slight angle, ~60 particles, layered in front of cityscape
- Displays game title `"THE HOLLOW MEN"` in Monogram font, upper half, white or cold pale blue
- Displays `"Press any key"` prompt in m5x7 font, bottom center, with alpha pulse animation
- Any key input triggers fade transition to MainMenu

### FR-4: Main Menu
- Retains dark background consistent with TitleCard (no hard visual cut)
- Displays `"THE HOLLOW MEN"` title at top, smaller than on TitleCard
- Displays two options in Monogram font:
  - **New Game** — always visible and selectable
  - **Quit** — always visible and selectable
- **Continue** option is hidden until a save file is detected (implementation deferred)
- Selected option renders white; unselected renders dim gray
- Up/Down arrow keys and gamepad D-pad navigate between options
- Enter, Space, or gamepad A confirms selection

### FR-5: Intro Monologue
- Triggered by selecting New Game
- Full black screen — no background, no portrait
- Displays Reid's internal monologue narration in m5x7 font, white text
- Dialogue driven by YarnSpinner for Godot addon
- Yarn source file: `assets/dialogue/intro_monologue.yarn`
- Player advances each line with Enter or Space
- On completion, fades to `World.tscn`

---

## Technical Requirements

### TR-1: YarnSpinner Addon
- YarnSpinner for Godot must be installed at `addons/yarnspinner/`
- A `DialogueRunner` node must be configured in `Intro.tscn`
- A custom `NarrationPresenter` script handles text display (no speaker name, no portrait)

### TR-2: Typography
- **Monogram** — used for all UI chrome (title, menu options, splash text)
- **m5x7** — used for all narration and dialogue body text
- Both fonts must be imported as bitmap fonts at native resolution (no filtering)

### TR-3: Placeholder Asset
- `assets/sprites/ui/cityscape_placeholder.png` must exist at exactly 320×180px
- Must be a dark silhouette readable against `#0d0b0f` background
- Filename signals intent — this file is expected to be replaced with final pixel art

### TR-4: Resolution
- All scenes render at native 320×180px
- SceneManager fade overlay must cover the full viewport

### TR-5: Project Entry Point
- `project.godot` must set `Splash.tscn` as the main scene

---

## File Deliverables

| File | Type | Notes |
|------|------|-------|
| `scenes/ui/Splash.tscn` | Scene | Studio splash |
| `scenes/ui/TitleCard.tscn` | Scene | Animated title with rain + cityscape |
| `scenes/ui/MainMenu.tscn` | Scene | New Game / Quit |
| `scenes/ui/Intro.tscn` | Scene | YarnSpinner monologue |
| `scripts/ui/scene_manager.gd` | Autoload | Fade transition handler |
| `scripts/ui/splash.gd` | Script | Auto-advance logic |
| `scripts/ui/title_card.gd` | Script | Rain particles, pulse prompt, input |
| `scripts/ui/main_menu.gd` | Script | Navigation, selection, routing |
| `scripts/ui/intro.gd` | Script | YarnSpinner runner, advance input |
| `scripts/ui/narration_presenter.gd` | Script | Custom YarnSpinner dialogue view |
| `assets/sprites/ui/cityscape_placeholder.png` | Asset | 320×180 placeholder silhouette |
| `assets/dialogue/intro_monologue.yarn` | Dialogue | Opening narration text |

---

## Out of Scope

- Save/load system
- Options menu
- Sound / music (no audio in this milestone)
- Final cityscape pixel art
- Full dialogue UI (portraits, speaker names, choice boxes)
- Any gameplay beyond fading into World.tscn

---

## Success Criteria

- [ ] Launching the game plays the full boot sequence without errors
- [ ] All scene transitions use the SceneManager fade
- [ ] Title card rain animation runs at native 320×180
- [ ] Main menu navigates correctly with keyboard and gamepad
- [ ] Intro monologue advances on input and terminates cleanly into World.tscn
- [ ] YarnSpinner addon is functional and the `.yarn` file parses without errors
- [ ] No placeholder `TODO` calls or `print()` debug statements in shipped code
