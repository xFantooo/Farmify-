## 🔧 Tesseract OCR Installation Guide

### What is Tesseract?
Tesseract is an OCR (Optical Character Recognition) tool that reads the loot numbers from your game screen. This allows Farmify to automatically determine if a base has good loot before attacking.

### Why is it required?
Without Tesseract, the loot checking feature cannot read the Gold, Elixir, and Dark Elixir values displayed in Clash of Clans.

---

## ⬇️ Download & Installation (3 Easy Steps)

### Step 1: Download Tesseract v5.3.3
Click the link below or copy into your browser:
```
https://github.com/UB-Mannheim/tesseract/releases/download/v5.3.3/tesseract-ocr-w64-setup-v5.3.3.20231005.exe
```

Or visit: https://github.com/UB-Mannheim/tesseract/releases

Look for the file named: **tesseract-ocr-w64-setup-v5.3.3.20231005.exe**

### Step 2: Run the Installer
1. Once downloaded, run the .exe file
2. Click through the installation wizard
3. **Keep the default installation path:**
   ```
   C:\Program Files\Tesseract-OCR
   ```
4. Click "Finish" when done

### Step 3: Restart Farmify
1. Close Farmify completely
2. Reopen Farmify
3. Loot checking will now work!

---

## ✅ Verify Installation

After installation, you can verify Tesseract is working by:

1. Enabling "Loot Management" in Farmify
2. Starting an auto attack with loot checking enabled
3. Check the logs - you should see:
   ```
   ✅ Tesseract initialized: C:\Program Files\Tesseract-OCR\tesseract.exe
   ```

If you see an error instead, please reinstall following the steps above.

---

## ❓ Troubleshooting

**Problem:** "Tesseract not found" error
**Solution:** Make sure you installed to the default location: `C:\Program Files\Tesseract-OCR`

**Problem:** Installation seems to hang
**Solution:** Try downloading again - your internet connection may have been interrupted

**Problem:** Still not working after installation
**Solution:** 
1. Completely close Farmify (check Task Manager)
2. Restart your computer
3. Reopen Farmify

---

## 🎯 What's Next?

Once Tesseract is installed, you can:
1. Set your desired loot requirements (Gold, Elixir, Dark Elixir)
2. Enable "Loot Management" in the Auto Attack settings
3. Start attacking - Farmify will automatically skip bases with low loot!

Enjoy automated raiding! 🚀
