# Tutorial 03: Multiple Creatures with Selection

## Goal
Spawn multiple creatures and implement a selection system - click a creature to select it, click floor to move the selected creature.

## What You'll Learn
- Input event propagation and handling
- Collision detection for clicking on 3D objects
- Managing multiple instances of the same scene
- Groups for organizing nodes
- Visual selection feedback

## Time Estimate
2-3 hours

## Prerequisites
- Tutorial 01 and 02 completed

---

## Tasks

### Part A: Make Creatures Clickable

- [ ] Open `scenes/entities/creature/creature.tscn`
- [ ] Add an `Area3D` child node for click detection
- [ ] Add a `CollisionShape3D` to the Area3D (use same size as creature)
- [ ] Set the Area3D's collision layer and mask appropriately
- [ ] Connect Area3D's `input_event` signal to the creature script

**Hint - input_event signal signature:**
```gdscript
func _on_area_3d_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
```

### Part B: Add Selection State to Creature

- [ ] Add a `is_selected: bool` variable to creature
- [ ] Add a `signal selected(creature)` to emit when clicked
- [ ] When creature's Area3D receives a click:
  - Emit the `selected` signal with `self` as argument
  - Mark the input as handled to prevent floor click

**Hint - Stopping event propagation:**
```gdscript
get_viewport().set_input_as_handled()
```

### Part C: Update Selection Indicator

- [ ] Rename or repurpose `SelectionIndicator` for permanent selection display
- [ ] Show it when `is_selected = true`
- [ ] Hide it when `is_selected = false`
- [ ] Add a method `set_selected(value: bool)` to handle this

### Part D: Create a Creature Manager

- [ ] Create a new script `scripts/levels/creature_manager.gd`
- [ ] It should:
  - Keep track of all creatures (array)
  - Track the currently selected creature
  - Handle spawning creatures
  - Handle selection changes
- [ ] Add a method to deselect all creatures
- [ ] Add a method to select a specific creature

### Part E: Update Dungeon Room

- [ ] Move creature spawning from `dungeon_room.gd` to creature manager
- [ ] Spawn 3 creatures at different positions
- [ ] Connect each creature's `selected` signal to the manager
- [ ] Update click handling:
  - If a creature is selected, move that creature
  - If no creature selected, do nothing (or select nearest?)

**Hint - Spawning at different positions:**
```gdscript
var spawn_positions := [
    Vector3(-2, 0.25, -2),
    Vector3(0, 0.25, 0),
    Vector3(2, 0.25, 2),
]
```

### Part F: Click Priority System

- [ ] Creature clicks should take priority over floor clicks
- [ ] When clicking empty floor with a creature selected, move that creature
- [ ] When clicking a different creature, select that one instead

**Hint**: Check if input was already handled before processing floor click:
```gdscript
func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if get_viewport().is_input_handled():
            return  # Creature was clicked, don't process floor
```

### Part G: Visual Polish

- [ ] Different indicator colors: selected vs hover
- [ ] Add a subtle outline or glow to selected creature
- [ ] Show cursor change when hovering over creatures

---

## Verification Checklist

- [ ] Three creatures spawn in the room
- [ ] Clicking a creature selects it (indicator appears)
- [ ] Clicking floor moves the selected creature
- [ ] Clicking a different creature selects that one instead
- [ ] Only one creature can be selected at a time
- [ ] Previously selected creature's indicator disappears

## Bonus Challenges

1. Implement Shift+Click to select multiple creatures
2. Draw a selection box when dragging to select multiple
3. Add a "Select All" keyboard shortcut (Ctrl+A)
4. Implement group movement (selected creatures move in formation)
5. Add creature health bars that appear when selected

---

## Architecture Hint

```
DungeonRoom
├── CreatureManager [scripts/levels/creature_manager.gd]
│   ├── Creature (selected)
│   ├── Creature
│   └── Creature
└── ... (floor, camera, etc.)
```

## Stuck?

Ask me with the specific task letter (e.g., "Help with Part D - creature manager structure").
