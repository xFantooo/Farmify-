# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['api_server.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('src', 'src'),                              # Include entire src directory
        ('src/utils/app_paths.py', 'utils'),         # CRITICAL: app_paths in utils/ for frozen imports
        ('src/utils/app_paths.py', '.'),             # CRITICAL: app_paths in root for frozen imports
        ('src/utils/frozen_diagnostic.py', 'utils'), # Include diagnostic utility
        ('src/utils/multi_monitor.py', 'utils'),     # Multi-monitor click support
        ('config.json', '.'),
        ('coordinates', 'coordinates'),
        ('assets', 'assets'),
        ('assets/Wall', 'assets/Wall'),
        ('bundled_tesseract', 'bundled_tesseract'),  # Include portable Tesseract
        ('generated_keys.json', '.'),                # Include license keys database
    ],
    hiddenimports=[
        'flask',
        'flask_cors',
        'PIL',
        'cv2',
        'numpy',
        'pytesseract',
        'pynput',
        'pynput.mouse',
        'pynput.keyboard',
        'pynput.mouse._win32',
        'pynput.keyboard._win32',
        'keyboard',
        'pyautogui',
        'mss',                                       # Multi-monitor screen capture
        'ctypes',                                    # Windows API for multi-monitor clicks
        'win32api',
        'win32gui',
        'win32con',
        # CRITICAL: Add app_paths as hidden imports for all import paths
        'src.utils.app_paths',
        'src.utils.frozen_diagnostic',
        'src.utils.multi_monitor',                   # Multi-monitor utility module
        'utils.app_paths',
        'utils.frozen_diagnostic',
        'utils.multi_monitor',
        'app_paths',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='farmify-backend',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,  # Keep console for debugging
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
