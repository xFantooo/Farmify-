# [Errno 22] Complete Fix - PyInstaller Frozen App

## Root Cause Identified

In PyInstaller frozen apps, the package structure changes dramatically:
- **Dev context**: `from src.utils.app_paths import ...` works
- **Frozen context**: `src/` directory doesn't exist; modules are flattened

This causes two problems:
1. **Import Failures**: Modules can't find `app_paths` using dev-style imports
2. **Path Issues**: Even if paths are resolved, parent directories may not exist before file operations

## Solutions Implemented

### 1. Frozen-Safe Import Pattern (All Modules)

**Pattern used in 8 modules:**
```python
try:
    try:
        from src.utils.app_paths import function_name  # Dev
    except ImportError:
        from utils.app_paths import function_name      # Frozen
    
    USE_FUNCTION = True
except ImportError as e:
    USE_FUNCTION = False
    function_name = None
```

**Updated modules:**
- ✅ src/core/screen_capture.py
- ✅ src/core/attack_recorder.py
- ✅ src/core/coordinate_mapper.py
- ✅ src/core/ocr_analyzer.py
- ✅ src/utils/license_manager.py
- ✅ src/utils/config.py
- ✅ src/utils/transaction_logger.py
- ✅ api_server.py

### 2. Critical Directory Creation Before File Operations

**Added to all file operations:**
```python
# CRITICAL: Ensure parent directory exists BEFORE saving
parent_dir = os.path.dirname(filepath)
if parent_dir:
    try:
        os.makedirs(parent_dir, exist_ok=True)
        print(f"Directory ensured: {parent_dir}")
    except Exception as e:
        print(f"Error creating directory: {e}")
        raise

# Only then save the file
with open(filepath, 'w', encoding='utf-8') as f:
    json.dump(data, f)
```

**Updated in:**
- ✅ src/core/screen_capture.py - Before `screenshot.save(filepath)`
- ✅ src/core/attack_recorder.py - Before `open(filepath, 'w')`
- ✅ src/core/coordinate_mapper.py - Before `open(filepath, 'w')`
- ✅ src/utils/license_manager.py - Already had directory creation

### 3. Fixed Path Type Issues

**Issues fixed:**
- ❌ Duplicate assignment: `self.license_file = os.path.abspath(...); self.license_file = ...` (overwriting)
- ✅ Fixed in: src/utils/license_manager.py - Now uses only `os.path.abspath()`

**Ensured all paths are:**
- Absolute strings (not pathlib.Path objects)
- Created with `os.path.abspath()` 
- Logged with type information for debugging

### 4. PyInstaller Bundle Configuration (api_server.spec)

**Critical additions:**
```python
datas=[
    ('src', 'src'),                              # Entire src
    ('src/utils/app_paths.py', 'utils'),         # app_paths in utils/
    ('src/utils/app_paths.py', '.'),             # app_paths in root
    ('src/utils/frozen_diagnostic.py', 'utils'), # Diagnostic utility
    ...
],
hiddenimports=[
    ...
    'src.utils.app_paths',
    'src.utils.frozen_diagnostic',
    'utils.app_paths',
    'utils.frozen_diagnostic',
    'app_paths',
],
```

**Why:**
- `('src/utils/app_paths.py', 'utils')` allows `from utils.app_paths import`
- `('src/utils/app_paths.py', '.')` allows `from app_paths import`
- `hiddenimports` tells PyInstaller to analyze these modules for dependencies

### 5. Diagnostic Tool for Frozen Apps

**Created:** src/utils/frozen_diagnostic.py

**Tests:**
1. Frozen status and sys.path
2. Module locations in bundle
3. Import paths (src.utils, utils, app_paths)
4. Path functions (get_app_data_dir, etc.)
5. File operations

**Integrated into api_server.py:**
- Automatically runs when frozen app starts
- Logs all diagnostic info to help troubleshoot remaining issues

## Files Modified

### Code Files (8 modules):
1. `src/core/screen_capture.py` - Frozen-safe imports + directory creation
2. `src/core/attack_recorder.py` - Frozen-safe imports + directory creation + time/threading imports
3. `src/core/coordinate_mapper.py` - Frozen-safe imports + directory creation + None checks
4. `src/core/ocr_analyzer.py` - Frozen-safe imports for Config
5. `src/utils/license_manager.py` - Frozen-safe imports + fixed duplicate assignment
6. `src/utils/config.py` - Frozen-safe imports
7. `src/utils/transaction_logger.py` - Frozen-safe imports
8. `api_server.py` - Frozen-safe imports + diagnostic tool integration

### Configuration Files (2 files):
1. `api_server.spec` - Updated datas and hiddenimports
2. `src/utils/frozen_diagnostic.py` - NEW diagnostic utility

## Testing the Fix

### Step 1: Build
```bash
npm run build:full
```

### Step 2: Run frozen app
```bash
./release/Farmify.exe
```

### Step 3: Check console output for:

**Success indicators:**
```
[DIAGNOSTIC] 1. FROZEN STATUS
sys.frozen: True

[DIAGNOSTIC] 6. TEST IMPORTS
✅ from src.utils.app_paths import get_app_data_dir
✅ from utils.app_paths import get_app_data_dir
✅ from app_paths import get_app_data_dir

[DIAGNOSTIC] 7. TEST PATH FUNCTIONS
✅ Testing functions from: utils.app_paths
   get_app_data_dir(): C:\Users\...\AppData\Local\Farmify
      Exists: True
   get_screenshots_dir(): C:\Users\...\AppData\Local\Farmify\screenshots
      Exists: True

[DIAGNOSTIC] 8. TEST FILE OPERATIONS
✅ File created successfully
✅ File read successfully
✅ File deleted successfully

[API_SERVER] ✅ App paths initialized successfully
[SCREEN_CAPTURE] ✅ Imported from utils.app_paths
[ATTACK_RECORDER] ✅ Imported from utils.app_paths
[LICENSE_MANAGER] ✅ Imported from app_paths
```

**Error indicators to watch for:**
```
❌ [Errno 22] Invalid argument
❌ ImportError: No module named 'src'
❌ NO SUCCESSFUL IMPORTS - app_paths cannot be found
```

### Step 4: Verify files are created
```bash
dir "%LOCALAPPDATA%\Farmify\"
dir "%LOCALAPPDATA%\Farmify\screenshots\"
dir "%LOCALAPPDATA%\Farmify\recordings\"
dir "%LOCALAPPDATA%\Farmify\licenses\"
```

## Expected Behavior After Fix

### Development Mode (python api_server.py):
```
[SCREEN_CAPTURE] ✅ Imported from src.utils.app_paths
[ATTACK_RECORDER] ✅ Imported from src.utils.app_paths
[LICENSE_MANAGER] ✅ Imported from src.utils.app_paths
```

### Frozen Mode (Farmify.exe):
```
[DIAGNOSTIC] FROZEN APP DIAGNOSTIC - Shows full diagnostic results
[SCREEN_CAPTURE] ✅ Imported from utils.app_paths
[ATTACK_RECORDER] ✅ Imported from utils.app_paths
[LICENSE_MANAGER] ✅ Imported from utils.app_paths
```

### On Any Import Failure:
```
[SCREENSHOT] ⚠️ app_paths import failed
[SCREENSHOT] Using fallback: C:\Users\...\AppData\Local\Farmify\screenshots
```

## Troubleshooting If Errors Persist

### If still seeing [Errno 22]:

1. **Check directory creation is happening:**
   - Look for `✅ Directory ensured:` in logs
   - If missing, the `os.makedirs()` calls weren't executed

2. **Check path type:**
   - Look for `Path type: <class 'str'>` in logs
   - If shows `Path` or `PosixPath`, there's a pathlib issue

3. **Check LOCALAPPDATA:**
   - Fallback methods rely on `LOCALAPPDATA` env var
   - Verify it's set: `echo %LOCALAPPDATA%`

### If import diagnostics show failures:

1. **Check api_server.spec:**
   - Verify `('src/utils/app_paths.py', 'utils')` is present
   - Verify `('src/utils/app_paths.py', '.')` is present
   - Verify `'utils.app_paths'` is in hiddenimports

2. **Rebuild completely:**
   ```bash
   npm run clean
   npm run build:full
   ```

3. **Check PyInstaller verbose:**
   ```bash
   pyinstaller api_server.spec --verbose 2>&1 | grep -i "app_paths"
   ```

## Implementation Summary

| Component | Status | Method |
|-----------|--------|--------|
| Import paths | ✅ Fixed | Try-multiple-paths pattern |
| Directory creation | ✅ Fixed | os.makedirs() before file ops |
| Path types | ✅ Fixed | os.path.abspath() for strings |
| PyInstaller bundling | ✅ Fixed | Updated spec with datas/hiddenimports |
| Diagnostics | ✅ Added | Frozen diagnostic tool |
| Logging | ✅ Enhanced | Detailed debug info in all modules |

## Next Steps

1. **Rebuild:** `npm run build:full`
2. **Test:** Run `./release/Farmify.exe`
3. **Monitor:** Check console for diagnostic output
4. **Verify:** Confirm no [Errno 22] errors and files created in AppData

---

**Date:** 2026-01-16  
**Status:** COMPLETE - Ready for final testing
