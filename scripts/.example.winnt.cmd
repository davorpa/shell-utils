@echo off
::---
::
:: This DOS/BATCH script is a minimun template to have modularized your code
:: in a Microsoft Windows enviroment
::
:: @author   davorpatech
:: @since    2019-05-14
:: @version  2021-06-13
::
:: @SOURCE:
::
::   https://davorpa.github.io/shell-utils/scripts/.example.winnt.cmd
::
:: @LICENSE:
::
::   This program is free software. It comes without any warranty, to
::   the extent permitted by applicable law. You can redistribute it
::   and/or modify it under the terms of the Do What The Fuck You Want
::   To Public License, Version 2, as published by DavorpaTECH. See
::   https://davorpa.github.io/shell-utils/scripts/COPYING
::   for more details.
::
::---
@break off
@title Your program name seen at window bar...
::@color 0a
@cls

:SOF                    -- initialize interpreter extensions
@IF NOT "%ECHO%" == ""  ECHO %ECHO%
@IF "%OS%"=="Windows_NT" (
    SETLOCAL EnableDelayedExpansion EnableExtensions
    IF ERRORLEVEL 1 (
        ECHO Unable to Enable Extensions
        GOTO end
    )
)

:: =================== some global configs ==================== ::

:: Save the current OEM code page (in order to be able to reset it later on).
for /f "tokens=2 delims=:" %%i in ('chcp') do set /a oemcp=%%~ni
:: Change the console code page.
::              https://ss64.com/nt/chcp.html
:: For supporting all of the box-drawing characters choose one out of
:: 437 (English US), 850 Multilingual (Latin I), 708 (Arabic ASMO),
:: 720 (Arabic Microsoft), 737 (Greek), 860 (Portuguese), 861 (Icelandic),
:: 862 (Hebrew), 863 (French Canada), 865 (Nordic), 866 (Russian)
:: 869 (Modern Greek), 1252 (West European Latin), 28591 (ISO Latin-1)
>nul chcp 850

:: size of box or windows (specified length)
SET ttycols=70



:begin                 -- main begin

:: ================= your main code goes here ================= ::
ECHO.
ECHO.
ECHO.
CALL :printac "HELLO WORLD" y
CALL :printac " "           y
CALL :printac "%~1"         y
CALL :printac " "           y
CALL :printac " "           y
CALL :printac "@davorpatech              !DATE!!TIME:~0,8!" y
CALL :printac " "           "│"
ECHO.
ECHO.

:end                   -- main end
REM.                   -- cleanup/reset previous status
:: Reset the default OEM code page of your system.
>nul chcp %oemcp%
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




:printac    -- outputs a text centerd line by line with optional left-right borders
::          -- %~1: value to be aligned at center
::          -- %~2: non-empty to enable box border character
SETLOCAL ENABLEDELAYEDEXPANSION
REM.--function body here
:: fix and parse input arguments
SET "lines=%~1" & IF "!lines!" == "" SET "lines= "
SET "border=%~2" & IF "!border!" NEQ "" SET "border=|"
:: iterate lines to centering expand
FOR /L %%# IN (1,2,!ttycols!) DO IF "!lines:~%ttycols%,1!" == "" SET "lines= !lines! "
:: cut if needed and print
SET "lines=!lines:~1,%ttycols%!" & ECHO(!border!!lines!!border!
(ENDLOCAL & REM -- NO RETURN VALUES
)
GOTO:EOF
