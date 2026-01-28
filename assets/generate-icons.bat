@echo off
echo ============================================
echo Farmify - Icon Generator for Windows
echo ============================================
echo.

REM Check if icon.png exists
if not exist "icon.png" (
    echo ERROR: icon.png not found!
    echo Please ensure icon.png exists in the assets folder.
    pause
    exit /b 1
)

echo Current directory: %cd%
echo.
echo Options to generate icon.ico:
echo.
echo 1. Install electron-icon-builder (Recommended)
echo    npm install --save-dev electron-icon-builder
echo    Then run: npm run build-icons
echo.
echo 2. Use online converter:
echo    - Go to: https://convertio.co/png-ico/
echo    - Upload icon.png
echo    - Download as icon.ico
echo.
echo 3. Use ImageMagick (if installed):
echo    magick convert icon.png -define icon:auto-resize=256,128,96,64,48,32,16 icon.ico
echo.

REM Check if npm is available
where npm >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo.
    choice /C YN /M "Do you want to install electron-icon-builder now"
    if errorlevel 2 goto :manual
    if errorlevel 1 goto :install
) else (
    echo npm not found. Please use manual method.
    goto :manual
)

:install
echo.
echo Installing electron-icon-builder...
cd ..
call npm install --save-dev electron-icon-builder
echo.
echo Adding build-icons script to package.json...
echo Please add this to your package.json scripts section:
echo   "build-icons": "electron-icon-builder --input=./assets/icon.png --output=./assets --flatten"
echo.
echo Then run: npm run build-icons
pause
exit /b 0

:manual
echo.
echo Please generate icon.ico manually using one of the methods above.
pause
exit /b 0
