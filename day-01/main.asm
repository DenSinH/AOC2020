format binary as 'gba'

include './lib/constants.inc'
include './lib/macros.inc'


header:
        include './lib/header.inc'

main:
include './init.asm'

; zero out array of 2048 bytes for byte array of bools
mov r0, #MEM_IWRAM
mov r1, #0
set_word r9, MEM_IWRAM + 0x2000

zero_out_loop:
        str r1, [r9], #4
        tst r9, #0x800
        bne zero_out_loop
sub r9, #0x800

; parse input
; store values as u32 array in MEM_IWRAM
; r0: pointer to array
; r1: pointer to input plaintext
; r2: loaded character
; r3: accumulated value
; r4: input end address
; r5: 10
; r6: 1
mov r0, #MEM_IWRAM
set_word r1, MEM_ROM + input
set_word r4, MEM_ROM + input_end
mov r5, #10
mov r6, #1

input_read:
        ldrb r2, [r1], #1
        cmp r2, '0'             ; newline marks next element (any character below 0)
        strlt r3, [r0], #4      ; store value accumulated
        strltb r6, [r9, r3]     ; set byte in byte[] @r9
        movlt r3, #0            ; clear accumulated value

        blt read_line_feed

        sub r2, '0'             ; correct for ascii values
        mul r3, r5              ; accum = (accum * 10) + new_val
        add r3, r2

        cmp r1, r4              ; EOF
        blt input_read

        ; store last value
        str r3, [r0], #4
        strltb r6, [r9, r3]

; find length of array in bytes
sub r10, r0, #MEM_IWRAM

; PART 1
; r0: stride * i
; r1: x
; r2: 2020 - x
; r3: byte from bool[] @r9
; r4: array start
;
; r10: array length (in bytes)
; r11: 2020
mov r0, #0
mov r4, #MEM_IWRAM

set_half r11, #2020

part_1:
        ; x
        ldr r1, [r4, r0]
        add r0, #4

        ; 2020 - x
        sub r2, r11, r1

        ; bool[2020 - x]
        ldrb r3, [r9, r2]
        cmp r3, #0
        bne part_1_done

        b part_1

part_1_done:
        mul r2, r1, r2
        mov r0, #128
        mov r1, #8
        bl draw_dec_value

; PART 2
; r0: stride * i
; r1: stride * j
; r2: byte from bool[] @r9
; r3: xi
; r4: xj
; r5: 2020 - xi - xj
; r6: array start
;
; r9: bool[]
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
                sub r5, r11, r7

                ldrb r2, [r9, r5]
                cmp r2, #0
                bne part_2_done


                cmp r1, r10
                blt part_2_j_loop

        b part_2

part_2_done:
        mul r2, r3, r4
        mul r2, r5
        mov r0, #128
        mov r1, #16
        bl draw_dec_value

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
