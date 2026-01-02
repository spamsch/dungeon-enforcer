# Tutorial 05: Gold and Treasury System

## Goal
Add a resource system where digging reveals gold, creatures pick it up, and store it in a treasury.

## What You'll Learn
- Resource/economy systems
- Area3D for item pickups
- Instantiating objects at runtime
- UI resource display
- Simple inventory concepts

## Time Estimate
2-3 hours

## Prerequisites
- Tutorial 04 completed (diggable tiles)

---

## Tasks

### Part A: Create Gold Nugget Scene

- [ ] Create `scenes/entities/props/gold_nugget.tscn`
- [ ] Structure:
  ```
  GoldNugget (Area3D)
  ├── CollisionShape3D (sphere)
  ├── MeshInstance3D (small gold-colored sphere or cube)
  └── OmniLight3D (subtle golden glow, optional)
  ```
- [ ] Create `scripts/entities/gold_nugget.gd`
- [ ] Add an `amount: int` variable (how much gold this nugget is worth)
- [ ] Emit a signal when collected

### Part B: Spawn Gold When Digging

- [ ] Update `tile_map.gd` (or dig completion logic)
- [ ] When a wall is dug out:
  - Random chance (50%?) to spawn gold
  - Instantiate gold nugget at tile position
  - Random amount (10-50 gold?)
  - Slight random offset so nuggets don't stack perfectly

**Hint - Spawning at runtime:**
```gdscript
var gold_scene = preload("res://scenes/entities/props/gold_nugget.tscn")
var nugget = gold_scene.instantiate()
nugget.position = dig_position + Vector3(randf_range(-0.3, 0.3), 0.1, randf_range(-0.3, 0.3))
nugget.amount = randi_range(10, 50)
add_child(nugget)
```

### Part C: Create Gold Manager

- [ ] Create `scripts/systems/gold_manager.gd` (autoload)
- [ ] Track total gold: `var total_gold: int = 0`
- [ ] Add methods:
  - `add_gold(amount: int)`
  - `remove_gold(amount: int) -> bool` (returns false if not enough)
  - `get_gold() -> int`
- [ ] Emit signal when gold changes: `signal gold_changed(new_amount)`

### Part D: Creature Picks Up Gold

- [ ] Add gold detection to creature
- [ ] Option 1: Creature automatically picks up nearby gold
  - Add Area3D to creature for detection
  - On `area_entered`, if it's gold → collect it
- [ ] Option 2: Gold pickup is a task (more complex)
  - Gold spawns a "collect" task
  - Creature navigates to gold, picks it up

- [ ] When collecting:
  - Call `GoldManager.add_gold(nugget.amount)`
  - Remove/free the nugget from scene
  - Play a sound/particle effect (optional)

**Hint - Detecting area overlap:**
```gdscript
func _on_pickup_area_entered(area: Area3D) -> void:
    if area is GoldNugget:
        GoldManager.add_gold(area.amount)
        area.queue_free()
```

### Part E: Gold Display HUD

- [ ] Create `scenes/ui/gold_display.tscn`
- [ ] Simple structure:
  ```
  GoldDisplay (Control)
  ├── HBoxContainer
  │   ├── TextureRect (gold icon)
  │   └── Label (amount)
  ```
- [ ] Create script that:
  - Connects to `GoldManager.gold_changed`
  - Updates label text when gold changes
- [ ] Position in top-left or top-right of screen
- [ ] Add to dungeon room scene

### Part F: Create Treasury Room (Optional)

- [ ] Define a special tile type: Treasury
- [ ] Creatures carry gold to treasury before it's "counted"
- [ ] Visual: Gold piles appear in treasury as gold accumulates
- [ ] Capacity: Each treasury tile holds X gold

This is closer to actual Dungeon Keeper behavior but more complex.

### Part G: Gold Nugget Polish

- [ ] Bobbing animation (sine wave up/down)
- [ ] Rotation animation (slow spin)
- [ ] Sparkle particles
- [ ] Collection sound effect
- [ ] Brief "pop" animation when collected

**Hint - Simple bobbing:**
```gdscript
func _process(delta: float) -> void:
    position.y = base_y + sin(Time.get_ticks_msec() * 0.003) * 0.1
```

---

## Verification Checklist

- [ ] Digging walls sometimes spawns gold nuggets
- [ ] Gold nuggets are visible and shiny
- [ ] Creature picks up gold automatically when nearby
- [ ] Gold count increases in HUD
- [ ] HUD displays current gold total
- [ ] Gold nuggets disappear after collection

## Bonus Challenges

1. Add gold seams (special wall tiles that always drop gold)
2. Add gem seams (infinite gold over time)
3. Treasury room visualization (gold piles)
4. Creature carries gold visually (gold on their back)
5. Pay creatures (they want gold or get angry!)
6. Shop system to spend gold

---

## Architecture Addition

```
Autoloads (project.godot):
├── GameManager
├── TaskManager (from Tutorial 04)
└── GoldManager (NEW)

DungeonRoom
├── GoldDisplay (UI)
├── TileMap
│   └── Spawns gold on dig
└── Creatures
    └── Detect and collect gold
```

---

## Stuck?

Ask about specific parts:
- "Help with Part A - gold nugget scene setup"
- "Help with Part D - creature pickup detection"
- "Help with Part E - connecting HUD to GoldManager"
