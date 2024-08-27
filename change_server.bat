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

set "foundSection=0"
set "updated=0"

for /f "delims=" %%i in ('type "%file%"') do (
    set "line=%%i"
    if "!line!"=="%section%" (
        set "foundSection=1"
    )
    if "!foundSection!"=="1" (
        if "!line:~0,%_keyLen%!"=="%key%=" (
            set "line=%key%=%newServer%"
            set "updated=1"
            set "foundSection=0"
        )
    )
    echo !line!
)

if "!updated!"=="0" (
    (for /f "delims=" %%i in ('type "%file%"') do (
        echo !line!
        if "%%i"=="%section%" (
            echo %key%=%newServer%
        )
    )) <"%file%"
)

endlocal