# Building Farmify for Distribution

This guide explains how to build Farmify into a standalone executable that users can download and run without installing Python, Node.js, or Tesseract OCR.

## Prerequisites

1. **Node.js and npm** installed
2. **Python 3.8+** installed
3. **PyInstaller** installed: `pip install pyinstaller`
4. **Tesseract OCR** installed: [Download](https://github.com/UB-Mannheim/tesseract/wiki)
   - Install to: `C:\Program Files\Tesseract-OCR`
   - This will be copied into the app bundle automatically

## Build Steps

### Automated Build (Recommended)

Just double-click `build.bat` or run:
```bash
build.bat
```

This will automatically:
1. 📦 Setup portable Tesseract (copies from system installation)
2. 📥 Install dependencies
3. ⚛️ Build React frontend
4. 🐍 Package Python backend
5. 📦 Create Windows installer

### Manual Build

```bash
# Step 1: Setup portable Tesseract
python setup_tesseract.py

# Step 2: Install dependencies
npm install
pip install -r requirements.txt

# Step 3: Build React frontend
npm run react-build

# Step 4: Package Python backend
npm run build-backend
# OR: pyinstaller api_server.spec --clean

# Step 5: Package Electron app
npm run dist
```

### Quick Build Command

```bash
npm run build
```

This runs all steps except Tesseract setup (run `python setup_tesseract.py` first).

## What Gets Packaged

The final build includes:
- ✅ Electron frontend (React app)
- ✅ **Portable Tesseract OCR** (no separate installation needed!)
- ✅ Python backend (Flask API)
- ✅ All dependencies (OpenCV, PyAutoGUI, etc.)
- ✅ Configuration files
- ✅ Assets and icons
- ✅ Coordinate mappings

## Find Your Build

After building, you'll find:

- **Windows Installer**: `dist/Farmify Setup 1.0.0.exe` (~300-400 MB)
- **Portable Version**: `dist/Farmify 1.0.0.exe` (~200-300 MB)

## Testing the Build

### Development Mode
```bash
# Start both servers manually
npm run dev
```

### Production Mode
```bash
# Run the built executable
cd dist
./Farmify.exe
```

The app will:
1. Auto-start the Python backend on port 5000
2. Initialize bundled Tesseract OCR automatically
3. Open the Electron window
4. Connect to the backend automatically

## Distribution

### For Users to Install

1. Share the **installer**: `Farmify Setup 1.0.0.exe`
   - Users double-click to install
   - Creates desktop shortcut
   - Adds to Start Menu
   - **No additional software needed!** (Python, Node.js, Tesseract all bundled)

2. Or share the **portable version**: `Farmify 1.0.0.exe`
   - No installation needed
   - Run directly from any folder
   - Good for USB drives

### Requirements for End Users

Users need:
- ✅ Windows 10/11 (64-bit)
- ✅ Clash of Clans installed (BlueStacks, LDPlayer, or official Windows version)

**That's it!** No Python, Node.js, or Tesseract installation required - everything is bundled!

## Troubleshooting Build Issues

### Tesseract Setup Fails

If `setup_tesseract.py` fails:
```bash
# Make sure Tesseract is installed
# Download: https://github.com/UB-Mannheim/tesseract/wiki
# Install to: C:\Program Files\Tesseract-OCR

# Then run setup again
python setup_tesseract.py
```

### Python Backend Not Packaging

If PyInstaller fails:
```bash
# Clean previous builds
rm -rf build/ dist/

# Rebuild with verbose output
pyinstaller api_server.spec --clean --log-level DEBUG
```

### Missing Python Modules

Add to `hiddenimports` in `api_server.spec`:
```python
hiddenimports=[
    'flask',
    'PIL',
    'cv2',
    # ... add any missing modules
],
```

### Electron Build Fails

```bash
# Clear Electron cache
rm -rf node_modules/.cache

# Rebuild node modules
npm install --force

# Try building again
npm run dist
```

### Backend Not Starting in Production

Check in Electron DevTools console:
```javascript
// Should see:
// "Starting Python backend: ..."
// "Backend: Server starting..."
```

If missing, check:
- Backend exe exists in `resources/backend/`
- No antivirus blocking the exe
- Ports 5000 not already in use

## File Size

Expected build sizes:
- **Installer**: ~300-400 MB (includes Electron + Python + dependencies)
- **Portable**: ~200-300 MB
- **Extracted**: ~500-600 MB

## Updating the Version

Edit `package.json`:
```json
{
  "version": "1.0.1",
  "productName": "Farmify",
  // ...
}
```

Then rebuild:
```bash
npm run build
```

The new version will be reflected in:
- Installer filename: `Farmify Setup 1.0.1.exe`
- App title bar
- About dialog

## Advanced: Creating Auto-Updater

To add auto-updates (future):
1. Configure `publish` in package.json
2. Upload builds to GitHub Releases
3. App will check for updates on startup

See: https://www.electron.build/auto-update

## Support

For build issues, check:
- `build/` folder has React files
- `dist/farmify-backend/` has Python exe
- `dist/` has final Electron build

Contact: [Your Support Email]
