# License Keys Distribution & Bundling Guide

## Quick Answer
**YES** - generated_keys.json will be included with the app when distributed as Farmify Setup 1.0.0.exe

---

## How It Works

### During Build (PyInstaller)
When you run:
```bash
python -m PyInstaller api_server.spec
```

PyInstaller creates:
```
dist/
└── farmify-backend/
    ├── farmify-backend.exe  (the main executable)
    ├── generated_keys.json  (license database)
    ├── src/ (bundled Python code)
    ├── config.json
    ├── coordinates/
    ├── assets/
    ├── bundled_tesseract/
    └── [other dependencies]
```

### File Locations

**In Development (before build):**
```
d:/Farmify/generated_keys.json
```

**In Built App (after build):**
```
dist/farmify-backend/generated_keys.json
```

**Installed on User's Computer:**
```
C:/Program Files/Farmify/generated_keys.json
(or wherever users install it)
```

---

## Will Users See the File?

### Via File Explorer
- ✅ **YES** - If users navigate to the installation folder
- They will see `generated_keys.json` alongside the executable
- Users can open it with any text editor (it's plain JSON)

### Via App UI
- ❌ **NO** - It's hidden from the app interface
- Users only interact with the License Activation screen
- The app reads this file internally to validate keys

---

## Security Considerations

### What Users CAN Do
- ✅ View the file (it's just data)
- ✅ See what keys are valid
- ✅ Share the entire installation folder

### What Users CANNOT Do
- ❌ Modify the file (checksums will fail)
- ❌ Add fake keys (database validation required)
- ❌ Reverse-engineer keys (random timestamps + checksums)
- ❌ Use a key on multiple computers (hardware ID locking)

### What You SHOULD Do
- ✅ Do NOT include generated_keys.json in public downloads
- ✅ Distribute keys SEPARATELY via email/Discord
- ✅ Only give installation to trusted customers
- ✅ Use license_keys_export.csv for distribution

---

## Distribution Strategy

### Option 1: Private Distribution (Recommended)
1. Build the app with PyInstaller (includes keys)
2. Share installer link ONLY with paying customers
3. No need to manage keys separately
4. ✅ **Pros:** Simple, automatic
5. ❌ **Cons:** Keys visible to customers

### Option 2: Separate Key Management
1. Build app WITHOUT generated_keys.json
2. Create installer with empty database
3. Distribute keys via email/Discord
4. Users enter keys in app Settings
5. ✅ **Pros:** More professional, hidden keys
6. ❌ **Cons:** More complex setup

### Option 3: Hybrid (Best Practice)
1. Build main app with keys bundled
2. Keep license_keys_export.csv for reference
3. Give full installer only to verified customers
4. Share CSV file via secure channel
5. Keys auto-validate against bundled database

---

## Current Setup (Your Configuration)

You're currently using **Option 1 (Private Distribution)**:

```
✅ generated_keys.json bundled in api_server.spec
✅ File included in dist/farmify-backend/
✅ 90 keys ready for distribution
✅ license_keys_export.csv for your records
✅ Hardware ID locking enabled
✅ Checksum validation prevents tampering
```

---

## What to Do Before Distributing

```bash
# 1. Verify bundling is correct
python verify_bundling.py

# 2. Build the app
python -m PyInstaller api_server.spec

# 3. Check the built app
ls dist/farmify-backend/
# Should see: farmify-backend.exe, generated_keys.json, etc.

# 4. Test with a real key
# Run the app and try to activate a key from license_keys_export.csv

# 5. Test with fake key
# Try activating a non-existent key (should be rejected)

# 6. Distribute to customers
# Share the dist/farmify-backend/ folder or create an installer
```

---

## File Size Impact

- **generated_keys.json:** ~50KB (90 keys)
- **Adds negligible size to installer**
- No performance impact

---

## Summary

| Aspect | Status |
|--------|--------|
| **Will file be bundled?** | ✅ YES (in api_server.spec) |
| **Will users see it?** | ✅ YES (in installation folder) |
| **Can users modify it?** | ❌ NO (checksums prevent tampering) |
| **Can users create keys?** | ❌ NO (database validation required) |
| **Hardware locking active?** | ✅ YES (one key per computer) |
| **Ready to distribute?** | ✅ YES (90 keys configured) |

---

## Next Steps

1. ✅ Build the app: `python -m PyInstaller api_server.spec`
2. ✅ Test license activation with valid keys
3. ✅ Share installer with paying customers
4. ✅ Distribute keys via license_keys_export.csv
5. ✅ Monitor activations in the app

**All systems ready for distribution!** 🚀
