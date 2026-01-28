# AUTO ATTACK - COMPLETE BUTTON SEQUENCE

## Full Attack Cycle with Exact Button Presses

---

## PHASE 1: START ATTACK (Click Attack Button)

### Step 1: Click "Ataquer" (Main Attack Button)
```
Button: 'attack'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 2 seconds
Purpose: Opens attack selection screen

LOG:
  "Step 1 - Clicking Ataquer at (X, Y)"
```

---

## PHASE 2: FIND A GOOD LOOT TARGET (30-Second Window)

### Step 2: Click "Trouver partie" (Find Match Button)
```
Button: 'find_a_match'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 2 seconds
Purpose: Game searches for an opponent base

LOG:
  "Step 2 - Clicking Trouver partie at (X, Y)"
  "⏱️ 30-second game window started"
```

**GAME ACTIONS:**
- Game loads a random opponent base
- Shows base preview on screen
- Displays loot available at top-left

---

### Step 3: Click "Lancer l'attaque" (Launch Attack Button)
```
Button: 'launch_attack'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 3 seconds
Purpose: Shows the loot display clearly (before actual attack)

LOG:
  "Step 3 - Clicking Lancer l'attaque at (X, Y)"
  "Waiting for loot display..."
```

**GAME DISPLAY:**
- Shows loot values clearly at top-left:
  - 🟡 Gold coin icon + number
  - 🟢 Elixir drop icon + number
  - ⚫ Dark elixir drop icon + number

---

## PHASE 3: LOOT CHECK LOOP (30-Second Window - May Repeat)

**This phase runs in a LOOP until good loot is found OR 30 seconds elapsed**

### Step 4a: CAPTURE SCREENSHOT
```
Action: screen_capture.capture_loot_area()
  - Takes screenshot of top-left corner (loot display only)
  - Saves to: C:\Users\[user]\AppData\Local\Farmify\screenshots\loot_YYYYMMDD_HHMMSS.png
  - Returns: filepath (or None if failed)

Wait: Immediate (no pause)

LOG:
  "Step 4 - Loot check attempt X (elapsed_seconds / 30s elapsed)"
  "CALLING: capture_loot_area()..."
  "RESULT: capture_loot_area() returned: C:\Users\...\loot_*.png"
```

---

### Step 4b: RUN OCR ANALYSIS
```
Action: ocr_analyzer.extract_loot(
    screenshot_path,
    min_gold=500000,
    min_elixir=500000,
    min_dark_elixir=0
)

Process:
  1. Opens screenshot file
  2. Enhances image for OCR clarity
  3. Runs Tesseract on 3 different modes:
     - PSM 6: Uniform block of text
     - PSM 11: Sparse text
     - PSM 3: Fully automatic
  4. Extracts numbers from loot display
  5. Compares against requirements
  6. Returns: {gold, elixir, dark_elixir, meets_requirements}

Wait: 1-3 seconds (depends on OCR processing)

LOG:
  "[AUTO ATTACK - LOOT CHECK] Starting OCR loot analysis"
  "[AUTO ATTACK - LOOT CHECK] Screenshot file: C:\Users\...\loot_*.png"
  "[AUTO ATTACK - LOOT CHECK] File exists: True"
  "[AUTO ATTACK - LOOT CHECK] Calling ocr_analyzer.extract_loot()..."
  
  "[OCR] Screenshot path: C:\Users\...\loot_*.png"
  "[OCR RESULT] 🟡 Gold: 123,456  (req: 500,000)  ❌"
  "[OCR RESULT] 🟢 Elixir: 234,567  (req: 500,000)  ❌"
  "[OCR RESULT] ⚫ Dark: 3,456  (req: 0)  ✅"
  "[OCR RESULT] ❌ BASE SKIPPED - Does not meet loot requirements"
```

---

### Step 4c: DECISION - DOES LOOT MEET REQUIREMENTS?

#### OPTION A: LOOT MEETS REQUIREMENTS ✅ → GO TO PHASE 4 (ATTACK)
```
Decision: decision_to_attack = True
Action: Break loop, proceed to Step 6

LOG:
  "✅ Step 4 - GOOD LOOT FOUND! Proceeding to attack after X attempts"
  "[DECISION] decision_to_attack = True"
```

#### OPTION B: LOOT DOESN'T MEET REQUIREMENTS ❌ → CLICK "SUIVANT" (SKIP TO NEXT BASE)
```
Decision: decision_to_attack = False
Action: Click 'next_button' to get next base

LOG:
  "❌ Step 4 - BAD LOOT detected on attempt X"
  "Step 5 - Clicking Suivant (Next) to get next base..."
```

---

## PHASE 4: SKIP BAD LOOT (If Loot Doesn't Meet Requirements)

### Step 5: Click "Suivant" (Next Button)
```
Button: 'next_button'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 5 seconds (loading animation)
Wait: 3 seconds (loot display)
Wait: 0 seconds (before looping back)

Total Wait: 8 seconds

Purpose: Dismiss current base preview, load new base

LOG:
  "Step 5 - Clicking Suivant (Next) to get next base..."
  "Step 5 - Waiting 5 seconds (loading animation)..."
  "Step 5 - Waiting 3 seconds (loot display)..."
  "Step 4 - Loot check attempt X+1 (10.5s / 30s elapsed)"
```

**LOOP CONDITION:**
- If elapsed time < 30 seconds AND loot not good:
  - LOOP BACK to Step 4a (capture screenshot)
- If elapsed time > 30 seconds:
  - Click "Suivant" and start new 30-second cycle

---

## PHASE 5: EXECUTE ATTACK (When Good Loot is Found)

### Step 6: Play Recorded Attack Sequence
```
Button: NONE (Automatic playback of recorded actions)
Action: attack_player.play_attack(session_name)

Recorded Actions (from AttackRecording.json):
  - Swipe troops from bottom to base
  - Place each troop at specific coordinates
  - Place spells at specific locations
  - Time: ~5-8 seconds of actions

Wait: Immediate start (3 seconds before playback begins)

LOG:
  "Step 6 - Starting recorded attack: [session_name]"
  "📂 Looking for recording file: [session_name].json"
  "Step 6 - Recorded attack playing (troops deploying)..."
```

**GAME ACTIONS:**
- Troops deploy automatically
- Spells cast automatically
- Battle begins

---

### Step 7: WAIT FOR BATTLE TO COMPLETE
```
Wait: 90 seconds (default)
Purpose: Let battle play out completely

LOG:
  "Step 7 - Waiting 90 seconds for battle completion..."
  "Step 7 - Battle in progress... 1m 30s remaining"
  "Step 7 - Battle in progress... 1m 20s remaining"
  ... (every 10 seconds)
```

**GAME ACTIONS:**
- Troops attack base
- Spells trigger
- Battle resolves
- Loot collected automatically

---

### Step 8: Click "Terminer l'attaque" (End Battle Button)
```
Button: 'end_battle'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 2 seconds
Purpose: Close battle results screen

LOG:
  "Step 8 - Clicking Terminer l'attaque at (X, Y)"
```

---

### Step 9: Click "Confirmer" (Confirm Button)
```
Button: 'confirm'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 2 seconds
Purpose: Confirm end of battle, proceed to rewards

LOG:
  "Step 9 - Clicking Confirmer at (X, Y)"
```

---

### Step 10: Return Home
```
Button: 'return_home'
Location: (X, Y) from coordinate_mapper
Action: pyautogui.click(X, Y)
Wait: 2-3 seconds
Purpose: Return to home screen after collecting loot

LOG:
  "Step 10 - Returning home..."
```

---

## ATTACK CYCLE COMPLETE ✅

**Summary of one full attack:**
1. Click "Ataquer"
2. Click "Trouver partie"
3. Click "Lancer l'attaque"
4. Capture loot screenshot (repeat up to 30 seconds)
5. Click "Suivant" if bad loot (repeat step 4)
6. Play recorded attack sequence
7. Wait for battle (90 seconds)
8. Click "Terminer l'attaque"
9. Click "Confirmer"
10. Click "Rentrer" (return home)

**Return to Step 1 for next attack cycle**

---

## TIMING BREAKDOWN

| Step | Button | Action | Wait Time |
|------|--------|--------|-----------|
| 1 | Ataquer | Click attack button | 2s |
| 2 | Trouver partie | Find match | 2s |
| 3 | Lancer l'attaque | Launch (show loot) | 3s |
| 4a | NONE | Capture screenshot | 0s |
| 4b | NONE | OCR analysis | 1-3s |
| 4c | NONE | Decision making | 0s |
| 5 | Suivant | Skip bad loot (repeat 4-5 up to 30s) | 8s per loop |
| 6 | NONE | Play recorded attack | 5-8s |
| 7 | NONE | Battle completion | 90s |
| 8 | Terminer l'attaque | End battle | 2s |
| 9 | Confirmer | Confirm | 2s |
| 10 | Rentrer | Return home | 2s |

**Total Time per Attack Cycle:**
- Minimum: ~115 seconds (1:55) if good loot found on first try
- Maximum: ~155 seconds (2:35) if searching through multiple bases

---

## BUTTON COORDINATES REFERENCE

All buttons must be mapped in the Coordinate Mapper before auto attack works:

```
Required Buttons:
  • attack → Ataquer (main attack button)
  • find_a_match → Trouver partie (find match)
  • launch_attack → Lancer l'attaque (launch)
  • next_button → Suivant (skip base)
  • end_battle → Terminer l'attaque (end battle)
  • confirm → Confirmer (confirm end)
  • return_home → Rentrer (return home)
```

Each button needs:
- X coordinate (horizontal position)
- Y coordinate (vertical position)

**Example mapping:**
```json
{
  "attack": { "x": 500, "y": 600 },
  "find_a_match": { "x": 750, "y": 400 },
  "launch_attack": { "x": 640, "y": 700 },
  "next_button": { "x": 100, "y": 100 },
  "end_battle": { "x": 400, "y": 550 },
  "confirm": { "x": 640, "y": 650 },
  "return_home": { "x": 50, "y": 50 }
}
```

---

## LOOT MANAGEMENT BUTTON SEQUENCE

When **Loot Management is ENABLED** (VIP Feature):

```
Step 1: Ataquer
Step 2: Trouver partie
Step 3: Lancer l'attaque
Step 4: [LOOP - UP TO 30 SECONDS]
  4a: Capture loot screenshot
  4b: Run OCR analysis
  4c: Compare loot vs requirements
      IF meets requirements → Skip to Step 6
      IF bad loot → Step 5
Step 5: Suivant (click repeatedly until good loot or 30s limit)
Step 6: Play attack
Step 7: Wait battle
Step 8: Terminer l'attaque
Step 9: Confirmer
Step 10: Rentrer
[REPEAT]
```

When **Loot Management is DISABLED** (Free Users):

```
Step 1: Ataquer
Step 2: Trouver partie
Step 3: Lancer l'attaque
Step 6: Play attack (NO LOOT CHECK - attack immediately!)
Step 7: Wait battle
Step 8: Terminer l'attaque
Step 9: Confirmer
Step 10: Rentrer
[REPEAT]
```

---

## EMERGENCY STOP

During auto attack, user can press:
- **Ctrl + Alt + S** → Emergency stop (any time)
- **F8** → Pause (during attack playback)
- **F9** → Stop (during attack playback)

These will interrupt the sequence and stop the bot.

