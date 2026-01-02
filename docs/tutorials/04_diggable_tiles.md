# Tutorial 04: Diggable Tile System

## Goal
Replace the solid room with a tile-based system where walls can be marked for digging, and creatures will dig them out automatically.

**This is THE core Dungeon Keeper mechanic!**

## What You'll Learn
- GridMap for 3D tile-based levels
- Task queue system for creature AI
- MeshLibrary creation
- Terrain modification at runtime
- Basic AI decision making

## Time Estimate
4-6 hours (this is a larger feature)

## Prerequisites
- Tutorials 01-03 completed (especially creature states)

---

## Tasks

### Part A: Create Tile Meshes

- [ ] Create 3 simple tile types as separate scenes or meshes:
  1. **Floor tile** - flat surface (already have this concept)
  2. **Wall tile** - solid block that can be dug
  3. **Marked tile** - wall with visual indicator (glowing edges?)

**Hint**: You can use CSGBox3D nodes to prototype, then convert to meshes later.

- [ ] Each tile should be 2x2x2 units (matching your current scale)
- [ ] Export them to a MeshLibrary resource

**To create MeshLibrary in Godot:**
1. Create a scene with MeshInstance3D nodes for each tile type
2. Select the root node
3. Scene → Export As → MeshLibrary

### Part B: Set Up GridMap

- [ ] Create a new scene `scenes/levels/tile_map.tscn`
- [ ] Add a `GridMap` node as root
- [ ] Assign your MeshLibrary
- [ ] Set cell size to match your tiles (2, 2, 2)
- [ ] Design a simple level:
  - Hollow center (floor tiles or empty)
  - Walls around edges
  - Some extra walls to dig through

**Hint - GridMap basics:**
```gdscript
# Get tile at position
var tile_id = grid_map.get_cell_item(Vector3i(x, y, z))

# Set tile at position
grid_map.set_cell_item(Vector3i(x, y, z), tile_id)

# Remove tile
grid_map.set_cell_item(Vector3i(x, y, z), -1)
```

### Part C: Mark Tiles for Digging

- [ ] Create `scripts/levels/tile_map.gd`
- [ ] Add click detection on the GridMap (similar to floor clicking)
- [ ] When right-clicking a wall tile:
  - Convert it to "marked" tile type
  - Add position to a "marked for digging" list
- [ ] When right-clicking a marked tile:
  - Convert back to normal wall (unmark)
  - Remove from list

**Hint - Converting world position to grid coordinates:**
```gdscript
var grid_pos: Vector3i = grid_map.local_to_map(local_position)
```

### Part D: Create a Task System

- [ ] Create `scripts/systems/task_manager.gd` (new autoload?)
- [ ] Define a Task class or dictionary:
  ```gdscript
  var task = {
      "type": "dig",
      "position": Vector3i(x, y, z),
      "assigned_to": null,
      "priority": 1
  }
  ```
- [ ] Add methods:
  - `add_task(task)`
  - `get_available_task() -> Task`
  - `complete_task(task)`
  - `cancel_task(task)`

### Part E: Creature Task Assignment

- [ ] Update creature to check for available tasks
- [ ] When idle and tasks available:
  - Request a task from TaskManager
  - Navigate to the task position
  - Perform the task (dig animation/timer)
  - Report task complete
- [ ] Add a new state: `WORKING`

**Hint - Task execution flow:**
```
IDLE → check for tasks
  ↓ (task found)
MOVING → navigate to task position
  ↓ (arrived)
WORKING → perform task (timer)
  ↓ (complete)
IDLE → task removed, tile updated
```

### Part F: Digging Action

- [ ] When creature arrives at marked tile:
  - Start a "dig timer" (2-3 seconds)
  - Play digging animation (or bob faster)
- [ ] When timer completes:
  - Remove the wall tile from GridMap
  - Update navigation mesh (important!)
  - Complete the task

**Hint - Updating navigation at runtime:**
```gdscript
navigation_region.bake_navigation_mesh()
```
Note: This can be expensive; consider batching updates.

### Part G: Update Navigation Mesh

- [ ] NavigationRegion3D needs to update when tiles change
- [ ] Either:
  - Rebake the entire navmesh (simple but slow)
  - Use NavigationServer3D for dynamic updates (complex but fast)
- [ ] Start with rebaking, optimize later if needed

### Part H: Visual Feedback

- [ ] Marked tiles should be clearly visible
  - Glowing outline
  - Different color
  - Floating icon above
- [ ] Show digging progress (optional progress bar)
- [ ] Particle effects when tile is destroyed

---

## Verification Checklist

- [ ] Level displays as a grid of tiles
- [ ] Right-clicking a wall marks it for digging
- [ ] Marked tiles look different (glowing/highlighted)
- [ ] Right-clicking again unmarks the tile
- [ ] Creature automatically moves toward marked tiles
- [ ] Creature "digs" for a few seconds
- [ ] Wall tile disappears after digging
- [ ] Creature can now walk through the dug area
- [ ] Creature continues to next marked tile if any

## Bonus Challenges

1. Add dirt particles when digging
2. Different wall types with different dig times
3. Gold seams that drop gold when dug
4. Gem seams that provide unlimited gold (slowly)
5. Impassable rock that cannot be dug
6. Multiple creatures working on different tasks simultaneously

---

## Architecture Overview

```
DungeonRoom
├── TileMap (GridMap) [tile_map.gd]
│   └── Handles marking/unmarking
├── NavigationRegion3D
│   └── Rebakes when tiles change
├── CreatureManager
│   └── Creatures query TaskManager
└── TaskManager (Autoload)
    └── Manages dig tasks queue
```

## File Structure Suggestion

```
scripts/
├── systems/
│   └── task_manager.gd    (NEW - autoload)
├── levels/
│   ├── tile_map.gd        (NEW)
│   └── dungeon_room.gd    (UPDATE)
└── entities/
    └── creature.gd        (UPDATE - add WORKING state)

scenes/
├── levels/
│   └── tile_map.tscn      (NEW)
└── tiles/                  (NEW folder)
    ├── floor_tile.tscn
    ├── wall_tile.tscn
    └── marked_tile.tscn
```

---

## Stuck?

This is a complex feature. Ask me about specific parts:
- "Help with Part B - setting up GridMap"
- "Help with Part D - task system design"
- "Help with Part G - navigation mesh updates"
