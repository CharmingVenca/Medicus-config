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
set "updated=0"

rem Replace the server IP in the temporary file
(for /f "delims=" %%i in ('type "%file%"') do (
    set "line=%%i"
    if "!line!"=="%section%" (
        set "foundSection=1"
    )
    if "!foundSection!"=="1" (
        if "!line:~0,%_keyLen%!"=="%key%=" (
            echo %key%=%newServer%>>"%tempFile%"
            set "updated=1"
            set "foundSection=0"
            goto :skippingLine
        )
    )
    echo !line!>>"%tempFile%"
    :skippingLine
))
rem Append new key if not found in section
if "!updated!"=="0" (
    (for /f "delims=" %%i in ('type "%file%"') do (
        echo !line!>>"%tempFile%"
        if "%%i"=="%section%" (
            echo %key%=%newServer%>>"%tempFile%"
        )
    )) <"%file%"
)

rem Move the temporary file to the original file
move /y "%tempFile%" "%file%">nul

endlocal