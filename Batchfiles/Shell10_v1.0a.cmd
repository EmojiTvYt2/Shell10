@echo off
title Shell10 - OpenSSH Setup
cls

::################################################################# ADMIN REOPEN
net session >nul 2>&1
if %errorlevel% neq 0 (
  color 0c
  cls
  echo This script requires administrator privileges. Restarting script...
  powershell -ExecutionPolicy Bypass -NoProfile -WindowStyle Hidden -Command "& { Start-Process '%~f0' -Verb runAs }"
  exit
)
cls
goto menu

::################################################################# MENU
:menu
color 0f
cls
echo Select An Option
echo.
echo [ 1 ] Info
echo [ 2 ] Setup OpenSSH
echo.
set /p "cho=>> "
if %cho%==1 goto info
if %cho%==2 goto warning
goto menu

:info
cd /D C:\Users\%username%\
ipconfig | findstr "IPv4" >ipconfig_temp.log
(
set /p yourip=
)<ipconfig_temp.log
set yourip=%yourip:~39%
cls
echo Shell10 is a free Open-Soure and easy to use OpenSSH setup tool
echo for those who don't wanna f### around with the firewall,
echo services and settings by themselves.
echo Windows 10 and higher only.
echo.
echo Made by JustMili - EmojiTvYt2 on GitHub
echo.
echo Your SSH: ssh %username%@%yourip%
echo If used on a different device, it'll connect to
echo your device's Command Prompt.
echo.
echo.
echo [Any Key] Go back.
pause >nul
goto menu

::################################################################# SETUP
:warning
color 0c
cls
echo WARNING:
echo This script in order to setup OpenSSH will:
echo  - Reset Firewall Network Protection
echo  - Disable Firewall Public Networks Protection
echo.
echo                 Security risks ahead.
echo If you understand all risks and want to continue, type "Yes".
echo If you do/don't understand all risks and want to exit, type "No".
echo If you understand but wanna go back to the menu, type "Q".
echo.
set /p "ans=Do you understand all risks? > "
if %ans%==yes goto setup
if %ans%==YES goto setup
if %ans%==Yes goto setup
if %ans%==YEs goto setup
if %ans%==yES goto setup
if %ans%==yEs goto setup
if %ans%==yeS goto setup
if %ans%==YeS goto setup
if %ans%==No exit
if %ans%==no exit
if %ans%==NO exit
if %ans%==nO exit
if %ans%==Q goto menu
if %ans%==q goto menu
goto warning

:setup
color 0f
cls
echo Reseting Windows Defender Firewall...
timeout /nobreak /t 1 >nul
echo   # Name                       # State
netsh advfirewall set privateprofile state on >nul
echo  -- Private Networks           : On
timeout /nobreak /t 1 >nul
netsh advfirewall set publicprofile state on >nul
echo  -- Guest and Public Networks  : On

timeout /nobreak /t 3 >nul

echo.
echo Firewall: Disabling Public Networks Protection...
netsh advfirewall set publicprofile state off >nul
echo Powershell: Installing OpenSSH Client Feature...
powershell -c "Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0" >nul
echo Powershell: Installing OpenSSH Server Feature...
powershell -c "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0" >nul
echo Services: Starting OpenSSH Server Service...
sc start sshd >nul
echo Services: Setting OpenSSH Server Service to Automatic...
sc config sshd start= auto >nul
echo.
echo.
echo All done. Press any key to exit.
echo Recommended: Restart Device.
pause >nul
exit
