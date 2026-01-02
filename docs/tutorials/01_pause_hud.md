# Tutorial 01: Pause Menu HUD

## Goal
Add a simple HUD that shows "PAUSED" when pressing Escape, and allows resuming with Escape again.

## What You'll Learn
- Creating UI with Control nodes
- CanvasLayer for UI rendering
- Connecting signals between scripts
- Using the existing GameManager autoload

## Time Estimate
30-45 minutes

---

## Tasks

### Part A: Create the UI Scene

- [ ] Create a new scene `scenes/ui/pause_menu.tscn`
- [ ] Root node should be `CanvasLayer` (so UI renders on top of 3D)
- [ ] Add a `ColorRect` child that covers the full screen (dark overlay)
  - **Hint**: Use anchor presets "Full Rect" or set anchors to 0,0,1,1
  - **Hint**: Set color to something like `Color(0, 0, 0, 0.7)` for semi-transparent black
- [ ] Add a `Label` child centered on screen with text "PAUSED"
  - **Hint**: Use anchor preset "Center"
  - **Hint**: Increase font size in Theme Overrides → Font Sizes
- [ ] Add a smaller `Label` below with "Press ESC to resume"
- [ ] Save the scene

### Part B: Create the Pause Menu Script

- [ ] Create `scripts/ui/pause_menu.gd`
- [ ] Extend `CanvasLayer`
- [ ] In `_ready()`:
  - Hide the pause menu initially (`visible = false`)
  - Connect to `GameManager.game_paused` signal
  - Connect to `GameManager.game_resumed` signal
- [ ] Create handler functions that show/hide the menu when signals are received

**Hint - Connecting signals in code:**
```gdscript
GameManager.game_paused.connect(_on_game_paused)
```

### Part C: Handle Escape Key Input

- [ ] Open `scripts/levels/dungeon_room.gd`
- [ ] In the `_input()` function, add handling for Escape key
- [ ] When Escape is pressed, call `GameManager.toggle_pause()`

**Hint - Detecting Escape:**
```gdscript
if event.is_action_pressed("ui_cancel"):  # ui_cancel = Escape by default
```

### Part D: Add Pause Menu to Dungeon Room

- [ ] Open `scenes/levels/dungeon_room.tscn`
- [ ] Instance your `pause_menu.tscn` as a child of DungeonRoom
- [ ] Test: Run the game, press Escape - menu should appear
- [ ] Test: Press Escape again - menu should hide and game resume

### Part E: Polish (Optional)

- [ ] Prevent clicks from moving creature while paused
  - **Hint**: Check `GameManager.current_state` in `_handle_click()`
- [ ] Add a fade-in animation when pausing
  - **Hint**: Look up `Tween` in Godot docs

---

## Verification Checklist

- [ ] Pressing Escape shows the pause overlay
- [ ] "PAUSED" text is visible and centered
- [ ] Pressing Escape again hides the overlay
- [ ] Game actually pauses (creature stops moving if mid-path)
- [ ] Cannot click-to-move while paused

## Bonus Challenges

1. Add a "Quit to Menu" button that returns to `main.tscn`
2. Add keyboard shortcut hints on screen
3. Create a simple animation (fade in, scale bounce)

---

## Stuck?

If you're stuck on a specific step, ask me and specify which task (e.g., "Help with Part B - connecting signals").
