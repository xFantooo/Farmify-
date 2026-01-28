# How Wall Image Recognition & Auto-Click Works

## Overview
When the bot finds the "rempart" (wall) image in the builder menu, it automatically clicks on it. Here's exactly how:

---

## The Complete Mechanism

### 1. IMAGE RECOGNITION RETURNS COORDINATES

```python
# File: src/utils/image_matcher.py (Lines 87-174)

match = self.image_matcher.find_image_on_screen(
    template_folder='Wall',      ← Looks in assets/Wall/ folder
    threshold=0.65,              ← Confidence level (0.65 = 65% match)
    region=search_region         ← Only search builder menu area
)

Returns:
match = {
    'x': 245,                    ← CENTER X position of wall image
    'y': 380,                    ← CENTER Y position of wall image
    'confidence': 0.82,          ← How confident (82% match)
    'template': 'wall_01.png',   ← Which template file matched
    'top_left': (220, 355),      ← Top-left corner of match
    'bottom_right': (270, 405)   ← Bottom-right corner of match
}
```

### 2. EXTRACT EXACT CLICK POSITION

The image matcher calculates the **CENTER POINT** of the matched wall image:

```python
# From image_matcher.py Line 152-157

match_x = match_loc[0] + template.shape[1] // 2 + offset_x
           ↑                  ↑ Template width
           ↑                  ↑ Divided by 2 to get center
           ↑ Match left edge position

match_y = match_loc[1] + template.shape[0] // 2 + offset_y
           ↑                  ↑ Template height
           ↑                  ↑ Divided by 2 to get center
           ↑ Match top edge position

Result:
Center point = (245, 380)  ← This is what gets clicked
```

**Why the CENTER?**
- Wall icons are square/rectangular images
- Clicking center ensures we click the actual wall icon
- Clicking edges might miss or click adjacent menu items

---

### 3. AUTO-CLICK THE WALL

```python
# File: src/core/wall_upgrader.py (Lines 505-518)

if match:
    # Wall found! Log it
    self.logger.info(f"✅ Wall found at ({match['x']}, {match['y']}) with confidence {match['confidence']:.3f}")
    
    # CLICK THE WALL POSITION
    pyautogui.click(match['x'], match['y'])
    
    # Wait for wall upgrade menu to appear
    time.sleep(1.5)
    
    # Success!
    wall_found = True
    break
```

**What happens:**
1. `pyautogui.click(245, 380)` - Moves mouse and clicks at (245, 380)
2. Game detects click on wall icon
3. Game opens wall upgrade menu
4. Bot waits 1.5 seconds for animation
5. Continues to STEP 3 (resource check & upgrade)

---

## Visual Representation

```
Builder Menu on Screen:
┌────────────────────────────────┐
│  Available Walls:               │
│  ├─ [ Wall Icon 1 ] ← (190,350) │
│  ├─ [ Wall Icon 2 ] ← (190,380) │ ◄─── WE ARE HERE (245, 380)
│  ├─ [ Wall Icon 3 ] ← (190,410) │
│  ├─ [ Wall Icon 4 ] ← (190,440) │
│  └─ [ Wall Icon 5 ] ← (190,470) │
└────────────────────────────────┘

The wall image found by image recognition:
  
  Top-left corner (220, 355)
        ↓
        ┌─────────────────┐
        │ Wall Icon       │
        │   (image)       │
        │                 │
        │     CENTER      │ ◄─── (245, 380) CLICK HERE
        │   (245, 380)    │
        │                 │
        │                 │
        └─────────────────┘
        ↑
  Bottom-right corner (270, 405)
```

---

## How Image Recognition Works

### Step-by-Step Template Matching

```
1. LOAD WALL TEMPLATES
   ├─ Read all images from: assets/Wall/
   ├─ Load into memory as OpenCV matrices
   └─ Images: wall_01.png, wall_02.png, wall_03.png, etc.

2. CAPTURE BUILDER MENU SCREENSHOT
   ├─ Use PIL.ImageGrab to capture screen region
   ├─ Region: search_region = (x, y, width, height)
   │          This is left portion of builder menu
   └─ Convert to OpenCV format (BGR color space)

3. TEMPLATE MATCHING (OpenCV cv2.matchTemplate)
   ├─ For each wall template:
   │   ├─ Slide template across screenshot
   │   ├─ Calculate pixel-by-pixel similarity
   │   ├─ Return confidence scores for each position
   │   └─ Find position with highest confidence
   │
   └─ Best match = highest confidence position

4. THRESHOLD CHECK
   ├─ confidence = 0.82 (82%)
   ├─ threshold = 0.65 (65%)
   │
   └─ IF confidence >= threshold:
       └─ MATCH FOUND ✅
```

---

## Key Parameters

### Threshold (0.65)
```
0.0 ────────────────────────────────── 1.0
          ↑                            ↑
        0.65              very confident match
      good match
      
threshold=0.65 means:
  • Accept matches that are 65% or more similar to template
  • Higher = more strict (might miss matches)
  • Lower = more lenient (might false-positives)
```

### Search Region (Left side of screen)
```python
game_bounds = self.screen_capture.game_window_bounds
if game_bounds:
    x, y, w, h = game_bounds
    # Search in left portion of screen where menu is
    search_region = (x, y, w // 2, h)
    #              (left, top, width, height)
```

This limits searching to only the left half of screen where builder menu appears.

---

## The Click Execution Flow

```
Wall Image on Screen (file: assets/Wall/wall_01.png)
    ↓
Image Recognition Process
(OpenCV cv2.matchTemplate)
    ↓
Match Found at pixel (220, 355) - top-left corner
    ↓
Calculate Center Point
  center_x = 220 + 50 // 2 = 245
  center_y = 355 + 50 // 2 = 380
    ↓
Create Match Dictionary
  {
    'x': 245,
    'y': 380,
    'confidence': 0.82,
    'template': 'wall_01.png'
  }
    ↓
Check if Match Found
  if match:
    ↓
  Click Wall Position
    pyautogui.click(match['x'], match['y'])
         ↓
    pyautogui.click(245, 380)
    ↓
Game Receives Click Event at (245, 380)
    ↓
Game Recognizes Click on Wall Icon
    ↓
Game Opens Wall Upgrade Menu
    ↓
Bot Waits 1.5 Seconds for Animation
    ↓
Continue to STEP 3 (Upgrade with Resources)
```

---

## Why This Works

### 1. **Template Images in assets/Wall/**
- Multiple wall images (different sizes, rotations, angles)
- Covers different wall appearances in game
- Allows matching even with lighting variations

### 2. **Center-Point Clicking**
- Icon is square/rectangular
- Clicking center = guaranteed hit
- Avoids edge detection issues

### 3. **Confidence Threshold**
- 0.65 is sweet spot
- Reliable matches without false positives
- Tolerates minor UI differences

### 4. **PyAutoGUI Clicking**
- Cross-platform (Windows, Mac, Linux)
- Automatic mouse movement to position
- Click executed reliably

---

## What's in assets/Wall/?

```
assets/
└── Wall/
    ├── wall_lv1.png      ← Wall level 1 appearance
    ├── wall_lv2.png      ← Wall level 2 appearance
    ├── wall_lv3.png      ← Wall level 3 appearance
    ├── wall_menu.png     ← Wall in builder menu
    ├── wall_button.png   ← Wall button variant
    └── ...
```

Each image captures how walls look in different contexts/levels. Template matching finds the best match from all these templates.

---

## Logging Output

When clicking the wall, you'll see in logs:

```
[WALL UPGRADER] Scroll attempt 1/10: Searching for wall...
[IMAGE MATCHER] Template wall_lv1.png: confidence=0.51
[IMAGE MATCHER] Template wall_lv2.png: confidence=0.82  ◄─── BEST MATCH
[IMAGE MATCHER] Template wall_menu.png: confidence=0.45

✅ Wall found at (245, 380) with confidence 0.82
[WALL UPGRADER] Waiting for upgrade screen to load...
[WALL UPGRADER LOOT CHECK] Starting loot analysis...
```

---

## Troubleshooting

### Problem: Bot finds but doesn't click
**Solution:** Check that `pyautogui` can move mouse
```python
# Test in logs:
import pyautogui
pyautogui.FAILSAFE = False  # Don't use failsafe
pyautogui.click(245, 380)
```

### Problem: Clicks wrong position
**Solution:** Verify screen coordinates are correct
```python
# Add logging
self.logger.info(f"Screen bounds: {self.screen_capture.game_window_bounds}")
self.logger.info(f"Match position: ({match['x']}, {match['y']})")
self.logger.info(f"About to click at position...")
```

### Problem: Template matching too strict/loose
**Solution:** Adjust threshold
```python
# More lenient (captures more matches, might get false positives)
match = self.image_matcher.find_image_on_screen(
    template_folder='Wall',
    threshold=0.55,  ← Lower threshold
    region=search_region
)

# More strict (only high-confidence matches)
match = self.image_matcher.find_image_on_screen(
    template_folder='Wall',
    threshold=0.75,  ← Higher threshold
    region=search_region
)
```

---

## Summary

**The bot clicks the wall automatically through:**

1. **Image Recognition** - Finds wall template in builder menu
2. **Coordinate Extraction** - Gets center point of matched image
3. **Click Execution** - Uses PyAutoGUI to click that exact position
4. **Wait for Response** - Allows game UI to respond (1.5 seconds)
5. **Continue** - Moves to next step (resource check)

**All automatic - no user interaction needed!**

