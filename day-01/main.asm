format binary as 'gba'

include './lib/constants.inc'
include './lib/macros.inc'


header:
        include './lib/header.inc'

main:
include './init.asm'

; parse input
; store values as u32 array in MEM_IWRAM
; r0: pointer to array
; r1: pointer to input plaintext
; r2: loaded character
; r3: accumulated value
; r4: input end address
; r5: 10
mov r0, #MEM_IWRAM
set_word r1, MEM_ROM + input
set_word r4, MEM_ROM + input_end
mov r5, #10

input_read:
        ldrb r2, [r1], #1
        cmp r2, '0'             ; newline marks next element (any character below 0)
        strlt r3, [r0], #4
        movlt r3, #0            ; clear accumulated value

        blt read_line_feed

        sub r2, '0'
        mul r3, r5
        add r3, r2

        cmp r1, r4
        blt input_read

        ; store last value
        str r3, [r0], #4

; find length of array
sub r10, r0, #MEM_IWRAM

; PART 1
; r0: stride * i
; r1: stride * j
; r2: xi
; r3: xj
; r4: array start
;
; r10: array length (in bytes)
; r11: 2020
mov r0, #0
mov r4, #MEM_IWRAM

set_half r11, #2020

part_1:
        ; xi
        ldr r2, [r4, r0]
        add r0, #4
        mov r1, r0

        part_1_j_loop:
                ; xj
                ldr r3, [r4, r1]
                add r1, #4

                ; xi + xj == 2020
                add r5, r2, r3
                cmp r5, r11
                beq part_1_done

                ; keep going until array length has been reached
                cmp r1, r10
                blt part_1_j_loop

        b part_1

part_1_done:
        mul r2, r2, r3
        mov r0, #8
        mov r1, #8
        bl draw_hex_value

; PART 2
; r0: stride * i
; r1: stride * j
; r2: stride * k
; r3: xi
; r4: xj
; r5: xk
; r6: array start
;
; r10: array length (in bytes)
; r11: 2020
mov r0, #0
mov r6, #MEM_IWRAM

part_2:
        ; xi = [array_start + (i << 2)]
        ldr r3, [r6, r0]
        add r0, #4
        mov r1, r0
        part_2_j_loop:
                ; xj = [array_start + (j << 2)]
                ldr r4, [r6, r1]
                add r1, #4
                mov r2, r1

                ; xi + xj
                add r7, r3, r4

                part_2_k_loop:

                        ldr r5, [r6, r2]
                        add r2, #4

                        add r8, r7, r5 ; (xi + xj) + xk
                        cmp r8, r11    ; == 2020
                        beq part_2_done

                        cmp r2, r10
                        blt part_2_k_loop

                cmp r1, r10
                blt part_2_j_loop

        b part_2

part_2_done:
        mul r2, r3, r4
        mul r2, r5
        mov r0, #8
        mov r1, #16
        bl draw_hex_value

mainloop:
      b mainloop

read_line_feed:
; aren't windows line feeds fun
ldrb r2, [r1]
cmp r2, '0'
addlt r1, #1
blt read_line_feed

b input_read

include './lib/text.asm'

input:
        file './input.txt'
input_end:
