# Tesseract Bundling - Quick Reference

## What This Does

Bundles Tesseract OCR directly into the Farmify app so users don't need to install it separately.

## How It Works

### 1. Setup Phase (Before Building)

Run once to prepare Tesseract:
```bash
python setup_tesseract.py
```

This script:
- ✅ Finds your system Tesseract installation
- ✅ Copies `tesseract.exe` to `bundled_tesseract/`
- ✅ Copies `tessdata/` folder (language files)
- ✅ Creates portable version (~50-100 MB)
- ✅ Tests that it works

**Location**: `bundled_tesseract/`
```
bundled_tesseract/
├── tesseract.exe
└── tessdata/
    ├── eng.traineddata
    └── ... (other language files)
```

### 2. Build Phase

When you run `build.bat` or `npm run build`:

1. **PyInstaller** packages backend + bundled_tesseract → `dist/farmify-backend/`
2. **Electron Builder** packages everything → `Farmify Setup.exe`

### 3. Runtime (User's Machine)

When user opens Farmify:

1. **Config auto-detection** (`config.py`):
   ```python
   paths_to_check = [
       'bundled_tesseract/tesseract.exe',  # Check bundled first
       r'C:\Program Files\Tesseract-OCR\tesseract.exe',  # Then system
   ]
   ```

2. **OCR Analyzer** uses auto-detected path:
   ```python
   tesseract_path = config.get_tesseract_path()
   # Returns: bundled_tesseract/tesseract.exe (in app folder)
   ```

3. **Tesseract runs** from app's bundled version - no system installation needed!

## Benefits

✅ **For Users**:
- No manual Tesseract installation
- Works out of the box
- One-click install experience

✅ **For Developer**:
- Consistent Tesseract version across all users
- No troubleshooting "Tesseract not found" issues
- Easier distribution

## File Size Impact

- Bundled Tesseract: ~50-100 MB
- Final installer: ~350-450 MB (increased from ~300-400 MB)

## Troubleshooting

### Setup fails: "Tesseract not found"

Install Tesseract first:
1. Download: https://github.com/UB-Mannheim/tesseract/wiki
2. Install to: `C:\Program Files\Tesseract-OCR`
3. Run `python setup_tesseract.py` again

### Build includes bundled_tesseract but OCR still fails

Check auto-detection:
```python
# In Python console:
from src.utils.config import Config
config = Config()
print(config.get_tesseract_path())
# Should print: bundled_tesseract/tesseract.exe
```

### Want to use system Tesseract instead

In `config.json`:
```json
{
  "tesseract": {
    "path": "C:\\Program Files\\Tesseract-OCR\\tesseract.exe"
  }
}
```

## Files Changed

1. **setup_tesseract.py** - New script to copy Tesseract
2. **src/utils/config.py** - Added auto-detection methods
3. **src/core/ocr_analyzer.py** - Uses config auto-detection
4. **api_server.spec** - Includes bundled_tesseract in PyInstaller
5. **package.json** - Includes bundled_tesseract in Electron build
6. **build.bat** - Runs setup_tesseract.py first
7. **BUILD.md** - Updated documentation
8. **USER_README.md** - Removed Tesseract installation requirement

## Build Process Summary

```
Old Process:
1. npm run build
2. Distribute
3. User installs Tesseract manually ❌

New Process:
1. python setup_tesseract.py (once)
2. npm run build
3. Distribute
4. User just runs installer ✅
```

## Testing

After building, test on clean machine:

```bash
# 1. Install Farmify Setup.exe
# 2. Open Farmify
# 3. Check console logs:
#    ✅ Found Tesseract at: bundled_tesseract/tesseract.exe
# 4. Test OCR:
#    - Go to Auto Attack
#    - Start searching
#    - Check if loot values are detected
```

If you see "Tesseract not found", check:
- `bundled_tesseract/` folder exists in app directory
- `tesseract.exe` is inside it
- `tessdata/eng.traineddata` exists

## Maintenance

When updating Tesseract version:

1. Install new Tesseract version to system
2. Delete `bundled_tesseract/` folder
3. Run `python setup_tesseract.py`
4. Rebuild app

## License

Tesseract is Apache 2.0 licensed - free to bundle and distribute.
