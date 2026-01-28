# Image Recognition System

Farmify uses OpenCV template matching to detect game elements, similar to AutoHotkey's `ImageSearch` function.

## How It Works

The bot searches for visual elements on screen by comparing screenshots against template images stored in this folder.

### Template Matching Process:
1. **Load Templates**: Loads all images from a folder (e.g., `Wall/`, `Builder/`)
2. **Capture Screen**: Takes screenshot of game window
3. **Match**: Uses OpenCV's `matchTemplate()` to find matching regions
4. **Click**: Clicks the center of the matched region

### Tolerance/Threshold:
- **0.7-0.8** = High precision (exact match required)
- **0.6-0.7** = Medium (allows slight variations) - **RECOMMENDED**
- **0.5-0.6** = Low precision (accepts rough matches)

Similar to AutoHotkey's `*N` tolerance parameter.

## Folder Structure

```
assets/
├── Builder/          # Free builder icons
│   ├── builder.png
│   ├── builder1.png
│   └── builder2.png
├── Wall/             # Wall pieces in upgrade menu
│   ├── wall.jpg
│   └── wall2.jpg
├── gold.png          # Gold icon (for resource detection)
├── elixir.png        # Elixir icon
└── darkElixir.png    # Dark Elixir icon
```

## Wall Detection Logic

The bot uses the **same approach as the AHK bot**:

```python
# 1. Click builder
find_and_click_builder()  # Uses Builder/ templates

# 2. Move mouse down
pyautogui.move(0, 200)

# 3. Scroll + Search loop (up to 9 attempts)
for scroll_attempt in range(9):
    # Search for wall image
    match = find_image_on_screen('Wall/', threshold=0.65)
    
    if match:
        # Found! Click it
        click(match['x'], match['y'])
        break
    
    # Not found, scroll down
    for _ in range(3):
        pyautogui.scroll(-3)  # 3 wheel clicks
    
    time.sleep(0.7)  # Wait for menu to settle
```

This dynamically finds walls **regardless of their position** in the menu, solving the "rempart not always at same position" problem.

## Adding New Templates

### 1. Take Screenshots
- Open Clash of Clans
- Navigate to the element you want to detect
- Take screenshot (use Windows Snipping Tool or similar)
- Crop to **just the element** (not the whole screen)

### 2. Save Templates
- Save as PNG or JPG
- Use descriptive names: `wall1.png`, `builder_free.png`
- Place in appropriate folder

### 3. Multiple Variations
- Take screenshots at different zoom levels
- Different lighting conditions
- Before/after animations
- **The bot will try all templates and use the best match**

## Troubleshooting

### "No match found"
- **Lower threshold**: Use 0.5-0.6 instead of 0.7
- **Add more templates**: Capture element in different states
- **Check image quality**: Templates should be clear, not blurry
- **Check resolution**: Templates should match game resolution

### "Wrong element clicked"
- **Raise threshold**: Use 0.75-0.8 for stricter matching
- **Remove similar templates**: Delete ambiguous images
- **Add unique features**: Crop templates to include distinguishing details

### "Performance issues"
- **Reduce template count**: Only keep 2-3 best templates per folder
- **Smaller templates**: Crop to minimum necessary area
- **Limit search region**: Use `region` parameter to search only relevant screen area

## Advanced Usage

### Search Specific Region
```python
# Only search left half of screen (where menu is)
match = image_matcher.find_image_on_screen(
    'Wall',
    threshold=0.65,
    region=(0, 0, 960, 1080)  # x, y, width, height
)
```

### Wait for Element
```python
# Wait up to 30 seconds for builder to appear
match = image_matcher.wait_for_image(
    'Builder',
    timeout=30.0,
    interval=0.5,
    threshold=0.6
)
```

### Multiple Elements
```python
# Find all visible elements
matches = image_matcher.find_multiple_images(
    ['Builder', 'Wall', 'Gold'],
    threshold=0.7
)
```

## Performance Tips

1. **Cache templates**: Templates are loaded once and cached
2. **Limit region**: Search only relevant screen areas
3. **Optimize resolution**: Don't use 4K templates if game runs at 1080p
4. **Update interval**: Don't search every frame, use 0.3-0.5s intervals

## Comparison: Farmify vs AHK Bot

| Feature | AHK Bot | Farmify |
|---------|---------|---------|
| Image Search | `ImageSearch` | `cv2.matchTemplate()` |
| Tolerance | `*130` | `threshold=0.65` |
| Scroll Method | `Send {WheelDown}` | `pyautogui.scroll(-3)` |
| Multiple Templates | Loop through folder | Auto-load all images |
| Best Match | First found | Highest confidence |
| Cache | No | Yes (faster) |

## Credits

This system is inspired by **LeosArchiv/COC-Wall-Upgrade-Bot-AHK**:
- https://github.com/LeosArchiv/COC-Wall-Upgrade-Bot-AHK
- MIT License

We've adapted their scrolling + image search logic from AutoHotkey to Python + OpenCV.
