@echo off &setlocal

:: Save the current OEM code page (in order to be able to reset it later on).
for /f "tokens=2 delims=:" %%i in ('chcp') do set /a oemcp=%%~ni

:: Change the console code page.
::              https://ss64.com/nt/chcp.html
:: For supporting all of the box-drawing characters choose one out of
:: 437 (English US), 850 Multilingual (Latin I), 708 (Arabic ASMO),
:: 720 (Arabic Microsoft), 737 (Greek), 860 (Portuguese), 861 (Icelandic),
:: 862 (Hebrew), 863 (French Canada), 865 (Nordic), 866 (Russian)
:: 869 (Modern Greek), 1252 (West European Latin), 28591 (ISO Latin-1)
>nul chcp 437

:: Create, convert, and save the box-drawing characters.
>"%temp%\boxdrw.~b64" echo(//4CJSQlYSViJVYlVSVjJVElVyVdJVwlWyUQJRQlNCUsJRwlACU8JV4lXyVaJVQlaSVmJWAlUCVsJWclaCVkJWUlWSVYJVIlUyVrJWolGCUMJQ==
>nul certutil.exe -f -decode "%temp%\boxdrw.~b64" "%temp%\boxdrw.~u16"
for /f %%i in ('type "%temp%\boxdrw.~u16"') do set "box=%%i"
del "%temp%\boxdrw.~b64" "%temp%\boxdrw.~u16"

:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ begin of examples ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo All box-drawing characters and their substring variables.
setlocal EnableDelayedExpansion
for /l %%i in (0 1 39) do echo  !box:~%%i,1! %%box:~%%i,1%%&echo(
endlocal
echo(

echo Draw boxes with single-frame characters.
echo  %box:~39,1%%box:~17,1%%box:~15,1%%box:~17,1%%box:~12,1%
echo  %box:~0,1%A%box:~0,1%B%box:~0,1%
echo  %box:~16,1%%box:~17,1%%box:~18,1%%box:~17,1%%box:~1,1%
echo  %box:~0,1%C%box:~0,1%D%box:~0,1%
echo  %box:~13,1%%box:~17,1%%box:~14,1%%box:~17,1%%box:~38,1%
echo(
echo Draw boxes with double-frame characters.
echo  %box:~22,1%%box:~26,1%%box:~24,1%%box:~26,1%%box:~8,1%
echo  %box:~7,1%A%box:~7,1%B%box:~7,1%
echo  %box:~25,1%%box:~26,1%%box:~27,1%%box:~26,1%%box:~6,1%
echo  %box:~7,1%C%box:~7,1%D%box:~7,1%
echo  %box:~21,1%%box:~26,1%%box:~23,1%%box:~26,1%%box:~9,1%
echo(
echo 1st combination (single vertical, double horizontal frames).
echo  %box:~34,1%%box:~26,1%%box:~30,1%%box:~26,1%%box:~5,1%
echo  %box:~0,1%A%box:~0,1%B%box:~0,1%
echo  %box:~19,1%%box:~26,1%%box:~37,1%%box:~26,1%%box:~2,1%
echo  %box:~0,1%C%box:~0,1%D%box:~0,1%
echo  %box:~33,1%%box:~26,1%%box:~28,1%%box:~26,1%%box:~11,1%
echo(
echo 2nd combination (double vertical, single horizontal frames).
echo  %box:~35,1%%box:~17,1%%box:~31,1%%box:~17,1%%box:~4,1%
echo  %box:~7,1%A%box:~7,1%B%box:~7,1%
echo  %box:~20,1%%box:~17,1%%box:~36,1%%box:~17,1%%box:~3,1%
echo  %box:~7,1%C%box:~7,1%D%box:~7,1%
echo  %box:~32,1%%box:~17,1%%box:~29,1%%box:~17,1%%box:~10,1%
echo(
:: ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ end of examples ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:: Reset the default OEM code page of your system.
>nul chcp %oemcp%

pause
