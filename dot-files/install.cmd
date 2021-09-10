@echo off
@break off
@title Dotfiles scripting enviroment install...
::@color 0a
@cls

:SOF                    -- configure interpreter extensions
@IF NOT "%ECHO%" == ""  ECHO %ECHO%
@IF "%OS%"=="Windows_NT" (
    SETLOCAL EnableDelayedExpansion EnableExtensions
    IF ERRORLEVEL 1 (
        ECHO Unable to Enable Extensions
        GOTO end
    )
)


:begin                 -- program main begin


:: config enviroment
set PROJECTS_WORKSPACE=W:\
set SCRIPTS_FOLDER=%PROJECTS_WORKSPACE%\shell-utils\scripts
set DOTFILES_FOLDER=%PROJECTS_WORKSPACE%\shell-utils\dot-files
echo.


:echoenv
ECHO    ====
ECHO    ==== Execution Enviroment ======================================
ECHO    ====
ECHO    ====  PROJECTS_WORKSPACE = !PROJECTS_WORKSPACE!
ECHO    ====  SCRIPTS_FOLDER  = !SCRIPTS_FOLDER!
ECHO    ====  DOTFILES_FOLDER = !DOTFILES_FOLDER!
ECHO    ====
ECHO    ================================================================
ECHO    ====


:: Make some hard links
echo.
echo ** Mount user scripts...
echo      at: %USERPROFILE%\bin
mklink /J "%USERPROFILE%\bin" "%SCRIPTS_FOLDER%"
echo.


echo.
echo ** Mount Hunspell dictionaries %DOTFILES_FOLDER%\.config\dictionaries...
echo      at user level: %USERPROFILE%\.config\dictionaries
@IF "%FORCEMODE%" == "" RMDIR "%USERPROFILE%\.config\dictionaries"
mklink /J "%USERPROFILE%\.config\dictionaries" "%DOTFILES_FOLDER%\.config\dictionaries"
echo.
echo      as used by Visual Studio Code in: %USERPROFILE%\AppData\Roaming\Code\Dictionaries
@IF "%FORCEMODE%" == "" RMDIR "%USERPROFILE%\AppData\Roaming\Code\Dictionaries"
mklink /J "%USERPROFILE%\AppData\Roaming\Code\Dictionaries" "%DOTFILES_FOLDER%\.config\dictionaries"
echo.

echo.
echo ** Mount Code Spell Checker dictionaries %DOTFILES_FOLDER%\.cspell...
echo      at: %USERPROFILE%\.cspell
@IF "%FORCEMODE%" == "" RMDIR "%USERPROFILE%\.cspell"
mklink /J "%USERPROFILE%\.cspell" "%DOTFILES_FOLDER%\.cspell"
echo.



:end                   -- program main end
::                     -- restore interpreter state
IF "%OS%"=="Windows_NT" ENDLOCAL
GOTO:EOF



:: define your functions here
:: Invoke using CALL :awesomeFunction RETVAR "arg1" "arg2"...

:awesomeFunction     -- function description here
::                   -- %~1: output/return varname
::                   -- %~2: input parameter 1
SETLOCAL ENABLEDELAYEDEXPANSION
REM.--function body here
SET "outval="
:: your code here
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~1" NEQ "" SET "%~1=%outval%"
)
GOTO:EOF
