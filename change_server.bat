@echo off
setlocal enabledelayedexpansion

REM Define the file path
set "filePath=C:\Medicus 3\Medicus.ini"
set "newFileContent="

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

REM Read and replace IP in file, storing result in memory
for /f "usebackq tokens=1* delims=" %%a in ("%filePath%") do (
    set "line=%%a"
    if "%%a"=="Server=%oldServerIP%" (
        echo Found the server IP line: %%a
        set "line=Server=%newIP%"
    )
    set "newFileContent=!newFileContent!!line!!newline!"
)

REM Write the updated content back to the original file
> "%filePath%" (
    echo !newFileContent!
)

echo Server IP has been updated to %newIP%.
endlocal
pause