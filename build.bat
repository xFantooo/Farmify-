
@echo off
echo ================================================================================
echo   FARMIFY - Building Distributable Package
echo ================================================================================
echo.

REM Kill any Python/Electron/Tesseract processes that may lock DLLs or tessdata
echo [0/6] Cleaning up locked processes...
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM electron.exe >nul 2>&1
taskkill /F /IM Farmify.exe >nul 2>&1
taskkill /F /IM tesseract.exe >nul 2>&1
echo Done.
echo.

echo [1/6] Setting up portable Tesseract...
python setup_tesseract.py
if errorlevel 1 (
    echo ERROR: Tesseract setup failed. Please install Tesseract first.
    echo Download: https://github.com/UB-Mannheim/tesseract/wiki
    pause
    exit /b 1
)

echo.


echo [2/6] Ensuring compatible TypeScript and translation dependencies...
call npm install typescript@4.9.5 --save-dev
if errorlevel 1 (
    echo ERROR: TypeScript install failed
    pause
    exit /b 1
)
call npm install i18next@21.9.2 react-i18next@11.18.6 --save
if errorlevel 1 (
    echo ERROR: i18next or react-i18next install failed
    pause
    exit /b 1
)

echo [3/6] Installing dependencies...
call npm install
if errorlevel 1 (
    echo ERROR: npm install failed
    pause
    exit /b 1
)

echo.
echo [3/6] Building React frontend...
call npm run react-build
if errorlevel 1 (
    echo ERROR: React build failed
    pause
    exit /b 1
)

echo.
echo [4/6] Copying Electron entry file...
copy /Y electron\main.js build\electron.js
if errorlevel 1 (
    echo ERROR: Failed to copy electron file
    pause
    exit /b 1
)

echo.
echo [5/6] Packaging Python backend...
call python -m PyInstaller api_server.spec --clean
if errorlevel 1 (
    echo ERROR: PyInstaller failed
    pause
    exit /b 1
)


echo.
echo [6/6] Building Electron app with retry on file lock...
set RETRIES=5
set COUNT=0
:build_retry
call npm run dist
if errorlevel 1 (
    set /a COUNT+=1
    if %COUNT% lss %RETRIES% (
        echo WARNING: Electron build failed due to possible file lock. Retrying in 5 seconds... (Attempt %COUNT% of %RETRIES%)
        timeout /t 5 >nul
        goto build_retry
    ) else (
        echo ERROR: Electron build failed after %RETRIES% attempts.
        pause
        exit /b 1
    )
)

echo.
echo ================================================================================
echo   BUILD COMPLETE!
echo ================================================================================
echo.
echo Installer created: dist\Farmify Setup 1.0.0.exe
echo Portable version: dist\Farmify 1.0.0.exe
echo.
echo Users can now double-click these files to run Farmify!
echo.
pause
