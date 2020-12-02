@echo off

SETLOCAL enabledelayedexpansion

set i = 0
for /F "tokens=*" %%l in (input.txt) do (
    echo %%l
	set /A i = %%l + 1
	echo !i!
)

echo I is !i!

ENDLOCAL
pause