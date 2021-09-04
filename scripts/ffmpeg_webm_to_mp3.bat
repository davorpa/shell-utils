@echo off
::---
::
:: This DOS/BATCH script process any .mp4/.webm videos present
:: in current folder and extract their audio track as MP3 file.
::
:: It uses ffmpeg to do that work ;)
::
:: @author   davorpatech
:: @since    2019-02-03
:: @version  2019-02-03
::
:: @SOURCE:
::
::   https://davorpa.github.io/shell-utils/scripts/ffmpeg_webm_to_mp3.bat
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

:SOF

@IF NOT "%ECHO%" == ""  ECHO %ECHO%
@IF "%OS%"=="Windows_NT" (
    SETLOCAL EnableDelayedExpansion EnableExtensions
    IF ERRORLEVEL 1 (
        ECHO Unable to Enable Extensions
        GOTO end
    )
)


:begin
if "%OS%" == "Windows_NT" (
    set "DIRNAME=%~dp0%"
) else (
    set DIRNAME=.\
)
SET "FILES_REGEX=%DIRNAME%*.mp4"
::SET "FILES_REGEX=%DIRNAME%*.webm"

IF "x%FFMPEG_PATH%" == "x" SET "FFMPEG_PATH=%PROGRAMFILES%\ffmpeg\bin\ffmpeg.exe"
IF NOT EXIST "%FFMPEG_PATH%" GOTO noffmpeg

:echoenv
ECHO    ====
ECHO    ==== Execution Enviroment ======================================
ECHO    ====
ECHO    ====  DIRNAME = !DIRNAME!
ECHO    ====  FILES_REGEX = !FILES_REGEX!
ECHO    ====  FFMPEG_PATH = !FFMPEG_PATH!
ECHO    ====
ECHO    ================================================================
ECHO    ====

TITLE Processing %DIRNAME%

:count
CALL :countFiles FILES_COUNT %FILES_REGEX%
IF "%FILES_COUNT%"=="0" GOTO nofiles

:choice
CHOICE /C yn /M "Process %FILES_COUNT% files"
IF %ERRORLEVEL% EQU 1 GOTO process
IF %ERRORLEVEL% EQU 2 GOTO postprocess
IF %ERRORLEVEL% EQU 0 GOTO postprocess
IF %ERRORLEVEL% EQU 255 GOTO begin

:process
TITLE Processing %FILES_COUNT% files in %DIRNAME%
SET FILES_I=1
FOR %%I IN ("%FILES_REGEX%") DO CALL :convert %%~fI !FILES_I! !FILES_COUNT! && SET /a "FILES_I=!FILES_I!+1"
IF "%FILES_I%"=="1" GOTO nofiles
TITLE Processed %FILES_COUNT% files in %DIRNAME%

:postprocess
IF "x%NOPAUSE%" == "x" PAUSE
IF "x%SELFREM%" NEQ "x" DEL "%~dpnx0"
GOTO end

:noffmpeg
ECHO ERROR: Executable file not found "%FFMPEG_PATH%"
GOTO end

:nofiles
CHOICE /C yn /M "WARN: No files to process. Retry"
IF %ERRORLEVEL% EQU 1 GOTO count
IF %ERRORLEVEL% EQU 2 GOTO postprocess
IF %ERRORLEVEL% EQU 255 GOTO postprocess
IF %ERRORLEVEL% EQU 0 GOTO postprocess

:end
IF "%OS%"=="Windows_NT" ENDLOCAL
GOTO:EOF



:countFiles     -- function description here
::              -- %~1: count var
::              -- %~2: file regex
SETLOCAL ENABLEDELAYEDEXPANSION
REM.--function body here
SET "nn=0"
SET "rr=%~2"
FOR %%I IN ("%rr%") DO SET /a "nn=!nn!+1"
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~1" NEQ "" SET "%~1=%nn%"
)
GOTO:EOF



:convert        -- function description here
::              -- %~1: file path
::              -- %~2: file index
::              -- %~3: files count
SETLOCAL ENABLEDELAYEDEXPANSION
REM.--function body here
SET ff=%~1
SET fn=%~n1
SET fdpn=%~dpn1
SET fnx=%~nx1
SET ii=%~2
SET nn=%~3
TITLE Converting ^(%ii%/%nn%^): %fnx%
ECHO Converting ^(%ii%/%nn%^): %fnx%
SET OPTS=-y -i "%ff%" -acodec libmp3lame -b:a 160k -ac 2 -ar 48000 "%fdpn%.mp3"
"%FFMPEG_PATH%" %OPTS%
IF "x%NOWAIT%" == "x" TIMEOUT /T 10
ENDLOCAL
GOTO:EOF
