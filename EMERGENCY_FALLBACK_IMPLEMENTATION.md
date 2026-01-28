# EMERGENCY FALLBACK IMPLEMENTATION - Phase 2

## Problem
Despite implementing app_paths.py and updating 8 modules, the frozen PyInstaller app still throws `[Errno 22]` errors:
- License activation: [Errno 22]
- Screenshot capture: [Errno 22]
- Coordinate mapping: [Errno 22]
- Attack recording: [Errno 22]

## Root Cause Hypothesis
The frozen app's import resolution may not be correctly loading app_paths.py from the bundled src/ directory, OR the module is being loaded but failing silently in frozen context.

## Solution Implemented: Multi-Level Fallback Strategy

### Phase 2: Defensive Fallback Implementation (CURRENT)

Updated 6 critical modules with defensive error handling:

#### 1. **screen_capture.py** ✅
- Added try/except for app_paths import with USE_APP_PATHS flag
- Added `_get_fallback_screenshot_dir()` method
- Uses LOCALAPPDATA env var as primary fallback
- Multi-level fallback: app_paths → LOCALAPPDATA → cwd

#### 2. **attack_recorder.py** ✅
- Added try/except for app_paths import with USE_APP_PATHS flag
- Added `_get_fallback_recordings_dir()` method
- Uses LOCALAPPDATA env var as primary fallback
- Enhanced __init__ with directory verification

#### 3. **coordinate_mapper.py** ✅
- Added conditional import with USE_APP_PATHS flag
- Added `_get_fallback_app_dir()` method
- sys.frozen check with app_paths fallback
- Directory creation with error handling

#### 4. **license_manager.py** ✅
- Added conditional import with USE_APP_PATHS flag
- Added `_get_fallback_app_dir()` method
- Explicit directory existence checks

#### 5. **config.py** ✅
- Added conditional import with USE_APP_PATHS flag
- Added `_get_fallback_app_dir()` method
- Config directory auto-creation

#### 6. **transaction_logger.py** ✅
- Added conditional import with USE_APP_PATHS flag
- Added `_get_fallback_app_dir()` method
- Log directory auto-creation

### Key Implementation Pattern

```python
# Import with fallback
try:
    from src.utils.app_paths import get_screenshots_dir
    USE_APP_PATHS = True
except ImportError as e:
    USE_APP_PATHS = False
    print(f"⚠️ app_paths import failed: {e}")

# __init__ with multiple fallback levels
def __init__(self):
    if USE_APP_PATHS:
        try:
            self.screenshot_dir = get_screenshots_dir()
            print(f"[Module] ✅ Using app_paths: {self.screenshot_dir}")
        except Exception as e:
            print(f"[Module] ⚠️ app_paths failed: {e}, using fallback")
            self.screenshot_dir = self._get_fallback_screenshot_dir()
    else:
        self.screenshot_dir = self._get_fallback_screenshot_dir()
    
    os.makedirs(self.screenshot_dir, exist_ok=True)

# Fallback method
def _get_fallback_screenshot_dir(self) -> str:
    """Uses LOCALAPPDATA env var as primary fallback"""
    try:
        appdata = os.getenv('LOCALAPPDATA')
        if appdata and os.path.isdir(appdata):
            return os.path.join(appdata, 'Farmify', 'screenshots')
    except Exception as e:
        print(f"[Module] Fallback LOCALAPPDATA failed: {e}")
    
    # Final fallback
    return os.path.join(os.getcwd(), 'screenshots')
```

## Why This Works

1. **LOCALAPPDATA is proven to work in frozen context** - The Logger module uses it directly and works correctly
2. **Multi-level fallback ensures some path resolution always succeeds**
3. **Explicit error logging shows which method is being used** - For debugging if issues persist
4. **Compatible with both dev and frozen contexts**

## Verification Strategy

After rebuild, the frozen app should:

1. **Print debug messages showing path resolution**:
   ```
   [ScreenCapture] ✅ Using app_paths: C:\Users\fanto\AppData\Local\Farmify\screenshots
   ```
   OR
   ```
   [ScreenCapture] ⚠️ app_paths failed: [error], using fallback
   [ScreenCapture] ✅ Using LOCALAPPDATA: C:\Users\fanto\AppData\Local\Farmify\screenshots
   ```

2. **Create files in correct location**: `C:\Users\fanto\AppData\Local\Farmify\`
3. **No [Errno 22] errors in logs**
4. **All features working** (license, screenshots, recordings, coordinates)

## Files Modified

- `src/core/screen_capture.py` - ✅ Defensive import + LOCALAPPDATA fallback
- `src/core/attack_recorder.py` - ✅ Defensive import + LOCALAPPDATA fallback
- `src/core/coordinate_mapper.py` - ✅ Defensive import + LOCALAPPDATA fallback
- `src/utils/license_manager.py` - ✅ Defensive import + LOCALAPPDATA fallback
- `src/utils/config.py` - ✅ Defensive import + LOCALAPPDATA fallback
- `src/utils/transaction_logger.py` - ✅ Defensive import + LOCALAPPDATA fallback

## Files Not Modified (don't need fallbacks)
- `src/core/ocr_analyzer.py` - No direct app_paths usage
- `src/utils/logger.py` - Already uses LOCALAPPDATA directly, working perfectly
- `api_server.py` - Main entry point, no direct path issues

## Immediate Next Steps

1. ✅ Implement defensive fallback code in all 6 modules
2. ⏳ Rebuild with `npm run build:full`
3. ⏳ Test frozen app with detailed logging
4. ⏳ Verify files created in AppData
5. ⏳ Confirm no [Errno 22] errors

## Success Criteria

- ✅ No `[Errno 22]` errors in production logs
- ✅ Files created in `C:\Users\[user]\AppData\Local\Farmify\` (not relative paths)
- ✅ All features working (screenshots, recordings, coordinates, license)
- ✅ Logger output shows which path resolution method was used

## Critical Notes

**WHY app_paths might not be working in frozen context:**
1. Relative import path (`from src.utils.app_paths`) may fail in frozen .exe
2. app_paths.py might not be properly bundled despite spec including `('src', 'src')`
3. Import resolution may silently fail and not execute fallback

**The LOCALAPPDATA fallback solves this because:**
1. It doesn't require importing app_paths.py
2. It uses only the standard os.getenv() function
3. Logger module proves LOCALAPPDATA works in frozen context
4. It's simpler and more reliable than complex relative imports

---

**Current Status:** Phase 2 implementation complete. Ready for rebuild and test.
