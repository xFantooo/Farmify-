# Data Portability Guide - Export/Import & Manual Transfer

## Overview
This guide explains how to transfer your Farmify data (coordinates, recordings, and settings) between computers or backup your data.

---

## Method 1: Export/Import (Recommended for Most Users)

### What Gets Transferred:
- ✅ **Coordinates** - All button locations you've mapped
- ✅ **Settings** - All game configuration preferences
- ✅ **Recordings** - Attack recordings (if backend API supports it)

### Step-by-Step Export

1. **Open Farmify** on your current computer
2. **Go to Settings** tab → **Data Management** section
3. **In Export Section**, you'll see:
   - Number of coordinates mapped
   - Number of recordings saved
4. **Click "Download Backup"**
   - A file named `farmify-backup-YYYY-MM-DD.json` will download
   - This file contains all your data
5. **Save this file somewhere safe** (cloud storage, USB drive, email to yourself)

### Step-by-Step Import

1. **Install Farmify** on your new computer
2. **Open Farmify** 
3. **Go to Settings** tab → **Data Management** section
4. **In Import Section**, click **"Select Backup File"**
5. **Choose the backup file** you downloaded (farmify-backup-*.json)
6. **Review the Import Preview**:
   - Shows backup date
   - Shows how many coordinates will be imported
   - Shows how many recordings will be imported
   - Shows if settings will be updated
7. **Review the Warning**:
   - "Importing will overwrite existing coordinates and settings with the same names"
   - This is safe - it just means if you already have a coordinate called "attack_button", the imported one will replace it
8. **Click "Confirm Import"**
9. **Wait for completion** - You'll see a success message showing:
   - How many coordinates were added
   - How many coordinates were overwritten
   - How many recordings were imported
   - Whether settings were updated

### That's It! 🎉
Your data is now transferred to the new computer.

---

## Method 2: Manual Recording File Transfer (Advanced)

If the automated import doesn't work or you want to manually transfer specific recordings:

### Find Recording Files Location

**On Windows:**
```
C:\Users\[YourUsername]\AppData\Local\Farmify\recordings\
```

**Or in development mode:**
```
[FarmifyFolder]\recordings\
```

### View Available Recordings

1. Open **File Explorer**
2. Navigate to the recordings folder
3. You'll see files like:
   - `attack_1.json`
   - `attack_2.json`
   - `my_custom_attack.json`
   - etc.

### Copy Recordings Manually

1. **On source computer**: 
   - Copy all `.json` files from recordings folder
   - Save them to USB drive or cloud storage

2. **On target computer**:
   - Open the recordings folder (same location as above)
   - Paste the `.json` files
   - Restart Farmify or refresh the page

3. **In Farmify**:
   - Go to **Attack Recording** tab
   - You should see your imported recordings in the list

---

## Method 3: Cloud Backup (For Continuous Sync)

### Setup

1. **Choose a cloud service**:
   - Google Drive
   - OneDrive
   - Dropbox
   - iCloud

2. **In Farmify Settings → Data Management**:
   - Export your backup regularly (daily/weekly)
   - Store in cloud folder
   - Access from any computer

### Benefits
- ✅ Automatic backup
- ✅ Version history
- ✅ Access from multiple computers
- ✅ No manual file transfers

### Steps
1. Setup cloud sync folder on your computer
2. Export backup to that folder regularly
3. On new computer, download and import

---

## Backup File Structure

Your backup file (`farmify-backup-*.json`) contains:

```json
{
  "exportDate": "2026-01-22T15:30:00.000Z",
  "appVersion": "1.0.0",
  "coordinates": {
    "attack_button": { "x": 100, "y": 200 },
    "shield_button": { "x": 250, "y": 150 },
    "upgrade_button": { "x": 400, "y": 300 }
  },
  "recordedAttacks": [
    {
      "name": "Attack 1",
      "date": "2026-01-22",
      "duration": 30,
      "steps": [...]
    },
    ...
  ],
  "settings": {
    "attack_interval": 15,
    "button_delay": 2,
    "enable_loot_check": true,
    "min_loot_gold": 500000,
    ...
  }
}
```

---

## Troubleshooting

### Issue: "Invalid backup file"
**Solution:** 
- Make sure you're using a backup file created by Farmify
- Don't manually edit the JSON file
- Download a fresh backup and try again

### Issue: Recordings don't appear after import
**Solution:**
- Restart Farmify completely
- Check the Import Preview - if it says 0 recordings, they weren't in the backup
- Re-export if recordings were added recently
- Check the recordings folder manually (see Method 2)

### Issue: Coordinates imported but not working
**Solution:**
- Verify the game window is in the same resolution as when you mapped them
- If resolution is different, you may need to re-map coordinates
- Different monitor DPI settings can affect coordinates

### Issue: Settings not updating
**Solution:**
- Refresh/restart Farmify after import
- Check that the "Settings included: Yes" message appeared in preview
- Manually reapply critical settings if needed

### Issue: Import hangs or takes too long
**Solution:**
- Large backup files (many recordings) may take time
- Wait at least 30 seconds before canceling
- Try importing without recordings first, then add them separately

---

## Best Practices

### ✅ DO:
- Export before major Farmify updates
- Keep backup files organized with dates
- Store backups in multiple locations (cloud + local)
- Export monthly or after significant mapping work
- Test import on target computer before relying on it

### ❌ DON'T:
- Manually edit backup JSON files
- Share backup files (they contain game configuration)
- Delete original recordings folder when moving computers
- Import on top of existing data without reviewing the preview
- Trust a single backup location

---

## Backup Naming Convention

Backups are automatically named:
```
farmify-backup-YYYY-MM-DD.json
```

**Example:**
- `farmify-backup-2026-01-22.json` - Backup from January 22, 2026
- `farmify-backup-2026-01-15.json` - Backup from January 15, 2026

**Tip:** If you export multiple times per day, rename the file:
```
farmify-backup-2026-01-22-MORNING.json
farmify-backup-2026-01-22-EVENING.json
```

---

## What Happens During Import?

### Coordinates:
- New coordinates are added
- Existing coordinates are **overwritten**
- Coordinates not in backup are **kept**

### Recordings:
- All imported recordings are added
- Existing recordings are **kept** (no duplicates deleted)
- Imported recordings are stored in recordings folder

### Settings:
- All settings are **overwritten** with imported values
- No partial updates - all-or-nothing
- Can always reset to defaults if needed (Settings → Advanced → Reset to Defaults)

---

## For Technical Users

### API Endpoint (Direct Import)
If using the API directly:

```bash
POST http://localhost:5000/api/attacks/import
Content-Type: application/json

{
  "attacks": [
    {
      "name": "Attack 1",
      "steps": [...],
      ...
    }
  ]
}
```

### Recordings Storage Location (Developer)
```
Linux/Mac: ~/.farmify/recordings/
Windows: %APPDATA%\Local\Farmify\recordings\
```

### Database Format
Each recording is a JSON file containing:
- Attack name
- Timestamp
- Click sequence with coordinates and timing
- Duration
- Associated game state

---

## Version Compatibility

### Backwards Compatibility
- Newer versions can import from older backups ✅
- Older versions cannot import from newer backups ❌

### Version Info in Backup
Your backup includes `appVersion` field showing which Farmify version created it.

Example:
```json
"appVersion": "1.0.0"
```

---

## Security Considerations

### What's in Your Backup:
- Game coordinates (safe to share)
- Game settings (safe to share)
- Recording sequences (safe to share)
- No passwords, keys, or personal data

### Safe to Store In:
- Cloud storage (Google Drive, OneDrive, Dropbox)
- Email attachments
- USB drives
- External hard drives
- Version control (Git - but .gitignore it)

### Not Recommended:
- Public file sharing (not needed)
- Unencrypted email over public wifi
- Shared computers without password protection

---

## Summary

| Feature | Export/Import | Manual Transfer |
|---------|---|---|
| Coordinates | ✅ Yes | ✅ Yes (manual) |
| Recordings | ✅ Yes (auto) | ✅ Yes (manual files) |
| Settings | ✅ Yes | ❌ Manual only |
| Speed | Fast | Varies |
| Ease | Very easy | Moderate |
| Automation | Possible | No |

---

## Need Help?

If something isn't working:
1. Check the Troubleshooting section above
2. Verify you're using the latest Farmify version
3. Try exporting fresh data
4. Test with a small backup first
5. Check logs for error messages

Good luck with your data transfer! 🚀
