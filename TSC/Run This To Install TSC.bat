@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM --- Elevate script if not running as admin ---
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
echo              TSC Install by spxxky
echo ======================================================
echo.
echo      1. Install TSC (performance mode)
echo      2. Uninstall (Restore Windows defaults)
echo      3. Exit
echo.
echo ======================================================
set /p choice=  Select an option (1-3): 

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto UNINSTALL
if "%choice%"=="3" exit
goto MENU

:INSTALL
cls
echo.
echo ======================================================
echo          [INFO] Applying TSC Performance Mode...
echo ======================================================
echo.

bcdedit /deletevalue useplatformclock
bcdedit /deletevalue useplatformtick

echo.
echo [SUCCESS] All commands executed successfully. You need to restart your PC. (Ignore the warnings)
echo.
pause
goto MENU

:UNINSTALL
cls
echo.
echo ======================================================
echo          [INFO] Restoring Windows Defaults...
echo ======================================================
echo.

bcdedit /deletevalue useplatformclock
if %errorlevel% neq 0 echo [INFO] useplatformclock was not set or already default.

bcdedit /deletevalue useplatformtick
if %errorlevel% neq 0 echo [INFO] useplatformtick was not set or already default.

echo.
echo [SUCCESS] All values restored to default. You need to restart your PC. (Warnings mean they were already set to default.)
echo.
pause
goto MENU
