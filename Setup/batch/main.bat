@echo off

for /F "tokens=*" %%A in (input.txt) do (
    echo %%A
)

pause