@echo off
setlocal enabledelayedexpansion

REM Define the file path
set "filePath=C:\Medicus 3\Medicus.ini"

REM Function to validate IP address format
:validateIP
set "ip=%1"
for /f "tokens=1-4 delims=." %%a in ("%ip%") do (
    if "%%d"=="" goto invalidIP
    for %%x in (%%a %%b %%c %%d) do (
        set /a "num=%%x"
        if !num! lss 0 goto invalidIP
        if !num! gtr 255 goto invalidIP
    )
)
goto :eof

:invalidIP
echo Invalid IP address. Please try again.
exit /b 1

REM Prompt user for new server IP
:promptIP
set /p "newIP=Enter the new server IP: "
call :validateIP %newIP%
if %errorlevel% neq 0 goto promptIP

REM Replace the IP address in the file
for /f "tokens=1* delims==" %%a in ('findstr /b /c:"Server=" "%filePath%"') do (
    set "oldServerIP=%%b"
)
if defined oldServerIP (
    echo Old Server IP: %oldServerIP%
    (for /f "usebackq tokens=*" %%a in ("%filePath%") do (
        set "line=%%a"
        set "line=!line:%oldServerIP%=%newIP%!"
        echo !line!
    )) > "%filePath%.tmp"
    move /y "%filePath%.tmp" "%filePath%"
    echo Server IP has been updated to %newIP%.
) else (
    echo Failed to find the current server IP in the file.
)
endlocal
pause