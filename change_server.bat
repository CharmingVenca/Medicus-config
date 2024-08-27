@echo off
setlocal EnableDelayedExpansion

set "file=C:\Medicus 3\Medicus.ini"
set "section=[Data]"
set "key=Server"

:input
set /p newServer=Enter the new server IP:

rem Validate IP
for /f "tokens=1-4 delims=." %%a in ("%newServer%") do (
    if "%%a" lss "0" set valid=0
    if "%%a" gtr "255" set valid=0
    if "%%b" lss "0" set valid=0
    if "%%b" gtr "255" set valid=0
    if "%%c" lss "0" set valid=0
    if "%%c" gtr "255" set valid=0
    if "%%d" lss "0" set valid=0
    if "%%d" gtr "255" set valid=0
)
if defined valid goto input

rem Create a temporary file
set "tempFile=%temp%\Medicus.tmp"
set "foundSection=0"

rem Replace the server IP in the temporary file
(for /f "usebackq tokens=*" %%i in ("%file%") do (
    set "line=%%i"
    if "!line!"=="%section%" (
        set "foundSection=1"
    ) else (
        if "!foundSection!"=="1" (
            if "!line:~0,%_keyLen%!"=="%key%=" (
                echo %key%=%newServer%>>"%tempFile%"
                set "foundSection=0"
                set "skipLine=1"
            )
        )
    )
    if not defined skipLine echo !line!>>"%tempFile%"
    set "skipLine="
))

rem Move the temporary file to the original file
move /y "%tempFile%" "%file%">nul

rem Create the install command
echo mkdir "%userprofile%\Desktop">>create_script.bat
echo copy "%~f0" "%userprofile%\Desktop\change_server.bat">>create_script.bat
echo del create_script.bat>>create_script.bat

endlocal