# Tutorial 02: Creature Idle Behavior

## Goal
Make the creature wander randomly when it has no destination, simulating "idle" behavior like in Dungeon Keeper.

## What You'll Learn
- Timer nodes for delayed/repeated actions
- Random number generation
- Simple state machine pattern
- NavigationServer queries for random points

## Time Estimate
1-1.5 hours

## Prerequisites
- Tutorial 01 completed (or at least understand GameManager)

---

## Tasks

### Part A: Add States to Creature

- [ ] Open `scripts/entities/creature.gd`
- [ ] Add an enum at the top for creature states:
  ```gdscript
  enum State { IDLE, MOVING, WANDERING }
  ```
- [ ] Add a `current_state: State` variable
- [ ] Update existing code to use states:
  - When `move_to()` is called → `MOVING`
  - When movement finishes → `IDLE`

### Part B: Add an Idle Timer

- [ ] Open `scenes/entities/creature/creature.tscn` in the editor
- [ ] Add a `Timer` node as a child of Creature
- [ ] Name it `IdleTimer`
- [ ] Set Wait Time to something like 2-4 seconds
- [ ] Set One Shot to `true` (we'll restart it manually)
- [ ] Connect its `timeout` signal to the creature script

### Part C: Implement Wander Logic

- [ ] In the timeout handler, if state is `IDLE`:
  - Pick a random point within the room
  - Call `move_to()` with that point
  - Set state to `WANDERING`
- [ ] When navigation finishes:
  - If state was `WANDERING` → go back to `IDLE`, restart timer
  - If state was `MOVING` (player clicked) → go to `IDLE`, restart timer

**Hint - Random point in a range:**
```gdscript
var random_x := randf_range(-4.0, 4.0)
var random_z := randf_range(-4.0, 4.0)
var random_point := Vector3(random_x, 0.25, random_z)
```

### Part D: Start the Timer

- [ ] In `_ready()`, start the idle timer after a short delay
- [ ] Make sure the timer restarts after each wander completes

**Hint - Starting a timer:**
```gdscript
$IdleTimer.start()
# or with custom time:
$IdleTimer.start(randf_range(2.0, 5.0))
```

### Part E: Player Commands Override Wandering

- [ ] When player clicks (calls `move_to()` externally):
  - Stop the idle timer
  - Set state to `MOVING` (not `WANDERING`)
- [ ] Differentiate between player-commanded moves and wander moves

**Hint**: Add a parameter to `move_to()`:
```gdscript
func move_to(target: Vector3, is_player_command: bool = true) -> void:
```

### Part F: Visual Feedback (Optional)

- [ ] Only show selection indicator for player commands, not wandering
- [ ] Add a small delay before wandering starts (creature "thinks")

---

## Verification Checklist

- [ ] Creature stands still initially
- [ ] After 2-4 seconds, creature starts wandering to random points
- [ ] Creature picks new random destinations continuously
- [ ] Clicking the floor interrupts wandering immediately
- [ ] After player command completes, wandering resumes
- [ ] Selection indicator only shows for player commands

## Bonus Challenges

1. Vary the wander speed (slower than commanded movement)
2. Add a chance to just stand idle instead of always wandering
3. Make the creature occasionally "look around" (rotate without moving)
4. Add a small hop animation when starting to move

---

## Stuck?

Ask me with the specific task letter (e.g., "Help with Part C - random point navigation").
