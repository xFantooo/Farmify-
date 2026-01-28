# App Icon Setup

This folder contains the application icons for different platforms.

## Icon Files

- **icon.svg** - Source vector icon (editable)
- **icon.png** - 512x512 PNG icon (for Linux and as source for other formats)
- **icon.ico** - Windows icon (will be generated)
- **icon.icns** - macOS icon (will be generated)

## How to Generate Icon Files

### Option 1: Using Online Converters (Easiest)

1. **For Windows (.ico):**
   - Upload `icon.png` to https://convertio.co/png-ico/
   - Download as 256x256 .ico file
   - Save as `icon.ico` in this folder

2. **For macOS (.icns):**
   - Upload `icon.png` to https://cloudconvert.com/png-to-icns
   - Download the .icns file
   - Save as `icon.icns` in this folder

### Option 2: Using electron-icon-builder (Automated)

Install the package:
```bash
npm install --save-dev electron-icon-builder
```

Add to package.json scripts:
```json
"build-icons": "electron-icon-builder --input=./assets/icon.png --output=./assets --flatten"
```

Run:
```bash
npm run build-icons
```

### Option 3: Manual Creation

#### For Windows (.ico):
Using ImageMagick:
```bash
magick convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico
```

#### For macOS (.icns):
Using iconutil (macOS only):
```bash
mkdir icon.iconset
sips -z 16 16     icon.png --out icon.iconset/icon_16x16.png
sips -z 32 32     icon.png --out icon.iconset/icon_16x16@2x.png
sips -z 32 32     icon.png --out icon.iconset/icon_32x32.png
sips -z 64 64     icon.png --out icon.iconset/icon_32x32@2x.png
sips -z 128 128   icon.png --out icon.iconset/icon_128x128.png
sips -z 256 256   icon.png --out icon.iconset/icon_128x128@2x.png
sips -z 256 256   icon.png --out icon.iconset/icon_256x256.png
sips -z 512 512   icon.png --out icon.iconset/icon_256x256@2x.png
sips -z 512 512   icon.png --out icon.iconset/icon_512x512.png
sips -z 1024 1024 icon.png --out icon.iconset/icon_512x512@2x.png
iconutil -c icns icon.iconset
```

## Current Icon Design

The icon features:
- Blue gradient background representing the sky/game theme
- White shield symbolizing defense and protection
- Golden crossed swords representing attack
- Green bot indicator at the bottom showing automation

## Customizing the Icon

To create your own custom icon:

1. Edit `icon.svg` in any vector editor (Inkscape, Adobe Illustrator, Figma)
2. Export as PNG at 1024x1024 resolution (save as `icon.png`)
3. Generate .ico and .icns files using one of the methods above
4. Rebuild the app

## Note

The current `icon.svg` file is included as a starting point. Feel free to replace it with your own design that matches your brand!
