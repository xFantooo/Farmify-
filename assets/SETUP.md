# 🎨 Quick Icon Setup Guide

## Step 1: Create icon.png (512x512 or 1024x1024)

You have two options:

### Option A: Use the provided SVG template

The `icon.svg` file contains a basic Farmify icon design. You can:

1. Edit it in any vector graphics software (Inkscape, Figma, Adobe Illustrator)
2. Export as PNG at 1024x1024 resolution
3. Save as `icon.png` in this folder

### Option B: Use your own design

1. Create or find a square image (1024x1024 recommended)
2. Save it as `icon.png` in this folder

## Step 2: Generate Platform-Specific Icons

### 🚀 Automated Method (Recommended)

Run this command from the project root:

```bash
npm install --save-dev electron-icon-builder
npm run build-icons
```

This will automatically generate:

- ✅ `icon.ico` for Windows
- ✅ `icon.icns` for macOS
- ✅ Multiple PNG sizes for Linux

### 🌐 Online Converter Method (Easy)

1. **For Windows (.ico):**

   - Go to https://convertio.co/png-ico/
   - Upload your `icon.png`
   - Select 256x256 size
   - Download and save as `icon.ico`

2. **For macOS (.icns):**
   - Go to https://cloudconvert.com/png-to-icns
   - Upload your `icon.png`
   - Download and save as `icon.icns`

## Step 3: Test the Icon

Run the app in development mode:

```bash
npm run dev
```

The icon should appear in:

- Window titlebar
- Taskbar (Windows) / Dock (macOS)
- Alt+Tab switcher

## Step 4: Build the App with Icon

When you're ready to distribute:

```bash
npm run build
```

Your installer/executable will include the icon!

## 📁 Required Files

After setup, you should have:

```
assets/
├── icon.svg          (source file - optional)
├── icon.png          (512x512 or 1024x1024 - REQUIRED)
├── icon.ico          (Windows - REQUIRED for distribution)
├── icon.icns         (macOS - REQUIRED for Mac builds)
└── README.md         (this file)
```

## 🎨 Icon Design Tips

- **Size:** Use at least 512x512, preferably 1024x1024
- **Format:** PNG with transparency
- **Style:** Simple, recognizable at small sizes
- **Colors:** Bold, contrasting colors work best
- **Shape:** Works best as a square or circular design

## 🔧 Troubleshooting

**Icon not showing?**

- Make sure files are named exactly: `icon.png`, `icon.ico`, `icon.icns`
- Check that files are in the `assets/` folder
- Restart the app after adding icons
- Clear electron cache: Delete `node_modules/.cache`

**Build fails?**

- Ensure all icon files exist before building
- Check package.json has correct paths in the "build" section

## 📦 What's Configured

The project is already set up to use icons:

- ✅ electron/main.js points to `assets/icon.png`
- ✅ package.json build config references all icon files
- ✅ npm script `build-icons` ready to use

Just add your `icon.png` and generate the platform-specific versions!
