@echo off
setlocal

REM Define paths
set virtualPythonEnv=portaPython\Scripts
set pythonExe=%virtualPythonEnv%\python.exe
set pythonWExe=%virtualPythonEnv%\pythonw.exe
set DeviceInfoFirmwareScript=DeviceInfoTool.py

REM Ensure the virtual environment is installed properly

if not exist "%pythonExe%" (
    echo The virtual environment needed to run the device info tool is missing.
    echo Please correct this and try again...
    pause
    exit /b 1
)

REM Ensure the python script DeviceInfoTool.py exists

if not exist "%DeviceInfoFirmwareScript%" (
    echo The script %DeviceInfoFirmwareScript% was not found.
    pause
    exit /b 1
)

REM Determine when DeviceInfoTool.py was last updated.
for %%F in ("%DeviceInfoFirmwareScript%") do set MOD_DATE=%%~tF

REM Extract date portion.
for /f "tokens=1 delims= " %%A in ("%MOD_DATE%") do set FILE_DATE=%%A

REM Determine what the current date is for comparison to the date DeviceInfoTool.py was last modified.
for /f "tokens=2 delims= " %%A in ('date /t') do set CUR_DATE=%%A

REM Simplified PowerShell Command to Debug
powershell -NoProfile -Command "Write-Host 'File Date: %FILE_DATE%, Current Date: %CUR_DATE%'

powershell -NoProfile -ExecutionPolicy Bypass -Command "& {try {$fileDate = [datetime]::ParseExact('%FILE_DATE%', 'MM/dd/yyyy', $null); $curDate = [datetime]::ParseExact('%CUR_DATE%', 'MM/dd/yyyy', $null); Write-Host ('File Date: ' + $fileDate + ', Current Date: ' + $curDate); $fileAge = (New-TimeSpan -Start $fileDate -End $curDate).Days; Write-Host ('File Age: ' + $fileAge)} catch {Write-Host 'Error in PowerShell date parsing.'; exit 1}}"

if errorlevel 1 (
    echo PowerShell failed to run failed. Exiting...
    pause
    exit /b 1
)

REM Calculate the difference between today's date and the last modified date of DeviceInfoTool.py
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "& {try {$fileDate = [datetime]::ParseExact('%FILE_DATE%', 'MM/dd/yyyy', $null); $curDate = [datetime]::ParseExact('%CUR_DATE%', 'MM/dd/yyyy', $null); (New-TimeSpan -Start $fileDate -End $curDate).Days} catch {Write-Host -1}}"' ) do set FILE_AGE=%%A

REM If DeviceInfoTool.py is at least 7 days old, update all required libraries in the virtual environment.
if %FILE_AGE% GEQ 7 (
    echo Updating required libraries now...

    "%pythonExe%" -m pip install --upgrade playwright beautifulsoup4 pandas openpyxl ping3 keyboard requests

    REM Update the last modified timestamp for DeviceInfoTool.py to the current date and time for future checks
    echo All required libraries will be updated again automatically in 7 days.
    powershell -NoProfile -Command "((Get-Item '%DeviceInfoFirmwareScript%').LastWriteTime = Get-Date)"
)

REM Run the actual DeviceInfoTool.py script now.
start "" "%pythonWExe%" %DeviceInfoFirmwareScript%

endlocal
exit /b 0