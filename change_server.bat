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

rem Replace the server IP in the file
(for /f "usebackq tokens=*" %%i in ("%file%") do (
    set "line=%%i"
    if "!line!"=="%section%" (
        echo !line!>>"%tempFile%"
        set found=1
        set /p nextLine=<'%file%'
        if "!nextLine:~0,7!"=="%key%=" (
            echo !nextLine!|find /i "%key%=">nul
            if !errorlevel!==0 (
                echo %key%=%newServer%>>"%tempFile%"
            )
        ) else (
            echo !nextLine!>>"%tempFile%"
        )
    ) else (
        echo !line!>>"%tempFile%"
    )
))

rem Move the temporary file to the original file
move /y "%tempFile%" "%file%">nul

rem Create the install command
echo mkdir "%userprofile%\Desktop">>create_script.bat
echo copy "%~f0" "%userprofile%\Desktop\change server.bat">>create_script.bat
echo del create_script.bat>>create_script.bat

endlocal