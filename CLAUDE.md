# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Dungeon Enforcer** - A Dungeon Keeper 2-inspired game built with Godot 4.5 (Forward Plus renderer). Currently a prototype with one dungeon room and click-to-move creature navigation.

## Commands

```bash
# Open project in Godot editor
open /Applications/Godot.app --args --path $(pwd)

# Run project headless (for validation)
/Applications/Godot.app/Contents/MacOS/Godot --headless --path . --quit-after 3

# Check Godot version
/Applications/Godot.app/Contents/MacOS/Godot --version
```

## Architecture

### Scene Flow
```
main.tscn (Menu) → [any key] → dungeon_room.tscn (Gameplay)
```

### Key Scripts

| Script | Purpose |
|--------|---------|
| `scripts/autoload/game_manager.gd` | Global state (MENU/PLAYING/PAUSED/GAME_OVER), pause control |
| `scripts/levels/dungeon_room.gd` | Raycast click detection, creature spawning, click marker |
| `scripts/entities/creature.gd` | NavigationAgent3D pathfinding, smooth movement/rotation |
| `scripts/main.gd` | Menu scene, transitions to dungeon room |

### Click-to-Move System
1. `dungeon_room.gd` raycasts from Camera3D through mouse position
2. Floor detected via collision layer 2
3. `creature.move_to(position)` called with 3D world coordinates
4. NavigationAgent3D handles pathfinding
5. Creature rotates smoothly (lerp_angle) and moves at 4.0 units/sec

### Collision Layers
- Layer 2: Floor (raycast target for clicks)
- Layer 4: Creature

## Code Conventions

- **Type hints required** - `gdscript/warnings/untyped_declaration=1` enabled
- **Node references**: Use `@onready var name: Type = $Path`
- **Exports**: Use `@export var name: type = default`
- **Doc comments**: Use `##` for class/function documentation
- **Naming**: snake_case for files/variables, PascalCase for resources, UPPER_CASE for constants

## Materials

Materials use PBR workflow with triplanar mapping for walls:
- `assets/materials/wall_material.tres` - Rock texture with Color/Normal/Roughness/AO maps
- `assets/materials/floor_material.tres` - Dark stone
- `assets/materials/creature_material.tres` - Orange with emission glow
- `assets/textures/rock/` - 2K PBR texture set (Color, NormalGL, Roughness, AO)
