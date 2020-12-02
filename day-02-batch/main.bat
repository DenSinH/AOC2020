@echo off

SETLOCAL enabledelayedexpansion

set valid_passwords_p1 = 0
set valid_passwords_p2 = 0

for /F "tokens=*" %%l in (input.txt) do (
    echo %%l
	for /f "tokens=1-4 delims=-: " %%a in ("%%l") do (
		set min=%%a
		set max=%%b
		set char=%%c
		set pwd=%%d
		
		rem ----------------- PART 1 --------------------
		echo PART 1: Finding !char! in !pwd! between !min! and !max! times
		
		set count=
		call :sub_count %%c %%d count
		
		rem PART 1
		if !count! LEQ !max! (
			if !count! GEQ !min! (
				set /a valid_passwords_p1 += 1
			)
		)
		
		rem ------------------ PART 2 --------------------
		set /a l = min - 1
		set /a h = max - 1
		
		set lopos=
		set hipos=
		
		call :sub_extract !pwd! !l! lopos
		call :sub_extract !pwd! !h! hipos
		
		echo PART 2: Characters: !lopos!, !hipos!
		
		if !lopos! == !char! (
			if !hipos! NEQ !char! (
				rem pos1 == char and pos2 != char: valid
				set /a valid_passwords_p2 += 1
			)
		) else (
			if !hipos! == !char! (
				rem pos1 != char and pos2 == char: valid
				set /a valid_passwords_p2 += 1
			)
		)
	)
)

echo Part 1: Found !valid_passwords_p1! valid passwords
echo Part 2: Found !valid_passwords_p2! valid passwords

pause
goto :EOF

::-------------------------------------
:sub_count
rem 3 variables: char, pwd, out: count
set _char=%1
set _pwd=%2
set _count=0
set _i=0

:next_char
		rem find next character:
		rem if character is end of line, exit, otherwise, increment counter
	set _c=!_pwd:~%_i%,1!
	if "!_c!" == "" goto end_line
	set /a _i = _i + 1
		
		rem check if character is the character we need
	if !_c! == !_char! set /a _count += 1
	goto next_char
:end_line

set /a %3=_count
exit /b

::--------------------------------------
:sub_extract
rem 3 variables: string, index, out
set _str=%1
set _char=%2

set %3=!_str:~%_char%,1!
exit /b

ENDLOCAL