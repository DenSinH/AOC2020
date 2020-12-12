'read file
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.OpenTextFile("input.txt")

Dim direction
Dim x1, y1 'position of ship, part 1
Dim x2, y2 'position of ship, part 2
Dim wx, wy 'relative x and y positions of way point
Dim temp
Dim command, arg, line

direction = "E"
x1 = 0
y1 = 0
x2 = 0
y2 = 0
wx = 10
wy = 1

Function turn(ByVal original, ByVal dir, ByVal deg) 
	If dir = "L" Then
		'turning left by x degrees is the same as turning right by 360 - x degrees
		deg = 360 - deg
	End If
	
	Do While deg > 0
		
		If original = "E" Then
			original = "S"
		ElseIf original = "S" Then
			original = "W"
		ElseIf original = "W" Then
			original = "N"
		ElseIf original = "N" Then
			original = "E"
		Else
			Wscript.Echo "Invalid direction in turn function:", original
		End If
		
		deg = deg - 90
	Loop
	turn = original
End Function

Do Until f.AtEndOfStream
	line    = f.ReadLine
	command = left(line, 1)
	arg     = Cint(right(line, Len(line) - 1))
	If command = "R" Or command = "L" Then
		direction = turn(direction, command, arg)
		
		' rotate waypoint
		deg = arg
		If command = "L" Then
			'turning left by x degrees is the same as turning right by 360 - x degrees
			deg = 360 - deg
		End If
		
		Do While deg > 0
			temp = wx
			wx = wy
			wy = -temp
			
			deg = deg - 90
		Loop
		
	ElseIf command = "F" Then
		' moving forward is the same as a command for moving in the direction we are facing
		If direction = "N" Then
			y1 = y1 + arg
		ElseIf direction = "S" Then
			y1 = y1 - arg
		ElseIf direction = "E" Then
			x1 = x1 + arg
		ElseIf direction = "W" Then
			x1 = x1 - arg
		End If
		
		'move towards waypoint for part 2
		x2 = x2 + arg * wx
		y2 = y2 + arg * wy
	ElseIf command = "N" Then
		y1 = y1 + arg
		wy = wy + arg
	ElseIf command = "S" Then
		y1 = y1 - arg
		wy = wy - arg
	ElseIf command = "E" Then
		x1 = x1 + arg
		wx = wx + arg
	ElseIf command = "W" Then
		x1 = x1 - arg
		wx = wx - arg
	End If
	
	Wscript.Echo command, arg
	Wscript.Echo wx, wy, x2, y2
Loop

Wscript.Echo "Part 1:", Abs(x1) + Abs(y1)
Wscript.Echo "Part 2:", Abs(x2) + Abs(y2)

f.Close