@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: Elevate script if not admin
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo ======================================================
    echo   Requesting administrative privileges...
    echo ======================================================
    echo.
    powershell -NoProfile -Command ^
      "Start-Process cmd -Verb RunAs -ArgumentList '/k \"%~f0\"'"
    exit /b
)

:MENU
cls
echo.
echo ======================================================
echo        SetTimerResolution by spxxky
echo ======================================================
echo.
echo      1. Install
echo      2. Uninstall
echo      3. Exit
echo.
echo ======================================================
echo.
set /p choice=  Select an option (1-3): 

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto UNINSTALL
if "%choice%"=="3" exit
goto MENU

:INSTALL
cls
echo.
echo ======================================================
echo   SetTimerResolution Install - Choose Your Resolution
echo ======================================================
echo.
echo      1. Minimal latency (5000) - Recommended
echo      2. Custom value
echo.
set /p res_choice=  Select timer resolution option (1-2): 

set "RES_VALUE="

if "%res_choice%"=="1" (
    set "RES_VALUE=5000"
)

if "%res_choice%"=="2" goto GET_CUSTOM_RES

if not defined RES_VALUE (
    echo.
    echo [ERROR] Invalid option.
    pause
    goto MENU
)

goto AFTER_RES_CHOICE

:GET_CUSTOM_RES
set /p custom_val=  Enter custom resolution (minimum 5000): 
REM -- Numeric check
for /f "delims=0123456789" %%A in ("%custom_val%") do (
    echo.
    echo [ERROR] Invalid number entered.
    pause
    goto MENU
)
if "%custom_val%"=="" (
    echo.
    echo [ERROR] No value entered. Aborting install.
    pause
    goto MENU
)
set /a "CHKVAL=%custom_val%" 2>nul
if "%CHKVAL%"=="" (
    echo.
    echo [ERROR] Not a valid integer.
    pause
    goto MENU
)
if %CHKVAL% LSS 5000 (
    echo.
    echo [ERROR] Value must be 5000 or greater.
    pause
    goto MENU
)
set "RES_VALUE=%custom_val%"

:AFTER_RES_CHOICE

echo.
echo [INFO] Using --resolution %RES_VALUE%
echo.

echo ======================================================
echo   [INFO] Adding key to the registry...
echo ======================================================
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /t REG_DWORD /d 1 /f

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to write to registry. Make sure to run this as admin.
    echo.
    pause
    goto MENU
)

echo.
echo [SUCCESS] Registry key added!
echo.

REM --- Close any running SetTimerResolution.exe before install ---
echo [INFO] Checking for running SetTimerResolution.exe...
tasklist | find /i "SetTimerResolution.exe" >nul
if %errorlevel%==0 (
    echo [INFO] Closing running SetTimerResolution.exe...
    taskkill /IM SetTimerResolution.exe /F >nul 2>&1
    if %errorlevel%==0 (
        echo [SUCCESS] SetTimerResolution.exe was closed.
    ) else (
        echo [WARNING] Failed to close SetTimerResolution.exe or it was already closed.
    )
) else (
    echo [INFO] SetTimerResolution.exe is not running.
)

REM --- Create shortcut in Startup folder ---
set "STRTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "EXE=%~dp0installation\SetTimerResolution.exe"
set "LNK=%STRTUP%\SetTimerResolutionShortcut.lnk"

if not exist "%EXE%" (
    echo [ERROR] SetTimerResolution.exe not found in the installation folder: %~dp0installation
    echo Please copy it there and re-run this script.
    pause
    goto MENU
)

REM --- Use PowerShell to create the shortcut ---
echo [INFO] Creating shortcut in Startup folder...
powershell -NoProfile -Command ^
  "$s = (New-Object -COM WScript.Shell).CreateShortcut('%LNK%');" ^
  "$s.TargetPath = '%EXE%';" ^
  "$s.Arguments = '--resolution %RES_VALUE% --no-console';" ^
  "$s.WorkingDirectory = '%~dp0installation';" ^
  "$s.Save()"

if exist "%LNK%" (
    echo [SUCCESS] Shortcut created at:
    echo     %LNK%
) else (
    echo [ERROR] Failed to create shortcut!
    pause
    goto MENU
)

REM --- Run the shortcut (starts in background, no window) ---
echo [INFO] Launching SetTimerResolution from Startup shortcut...
start "" "%LNK%"

REM --- Wait and check process ---
timeout /t 2 >nul
tasklist | find /i "SetTimerResolution.exe" >nul
if %errorlevel%==0 (
    echo [SUCCESS] SetTimerResolution is running.
) else (
    echo [WARNING] SetTimerResolution process not detected.
    echo Try launching it manually to troubleshoot.
)

echo.
echo [INFO] Please restart your PC for the registry change to take effect.
echo.
pause
goto MENU

:UNINSTALL
cls
echo.
echo ======================================================
echo   [INFO] Removing key from the registry...
echo ======================================================
echo.

reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v GlobalTimerResolutionRequests /f

if %errorlevel% neq 0 (
    echo [WARNING] Registry value was not found or could not be deleted.
) else (
    echo [SUCCESS] Registry key deleted!
)

REM --- Close SetTimerResolution.exe process if running ---
echo.
echo [INFO] Closing SetTimerResolution.exe if running...
taskkill /IM SetTimerResolution.exe /F >nul 2>&1
if %errorlevel%==0 (
    echo [SUCCESS] SetTimerResolution.exe was closed.
) else (
    echo [INFO] SetTimerResolution.exe was not running or already closed.
)

REM --- Delete shortcut from Startup folder ---
set "STRTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "LNK=%STRTUP%\SetTimerResolutionShortcut.lnk"
if exist "%LNK%" (
    del "%LNK%"
    echo [SUCCESS] Shortcut deleted from Startup.
) else (
    echo [INFO] Shortcut was not found in Startup folder.
)

echo.
echo [INFO] Please restart your PC for all changes to take effect.
echo.
pause
goto MENU
