; Autor reseni: Martin Ševčík xsevcim00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "martinsevcik" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice
cipher_key: .asciiz "sev"

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text
                ; encrypted message: fvnanrlzrjno, 469 cycles, 270 instrucion, 1.737 CPI

main:
                ; pointers and constants init
                daddi   r5, r0, msg             ; r5 = ->msg
                daddi   r6, r0, cipher_key      ; r6 = ->cipher_key
                daddi   r7, r0, cipher          ; r7 = ->cipher
                
                daddi   r8, r0, 97      ; r8 = 'a'
                daddi   r9, r0, 122     ; r9 = 'z'
                daddi   r10, r0, 26     ; r10 = alph len
                daddi   r11, r0, 1      ; r11 = +1 shift forward
                daddi   r12, r0, -1     ; r12 = -1 shitft back
                daddi   r13, r0, 3      ; r13 = key len (3)

                daddi   r15, r0, 1      ; r15 = shift direction flag, starting with 1

encryption_loop:
                lb      r16, 0(r5)       ; r16 = msg[r5]
                beq     r16, r0, exit  ; if '\0' -> exit

                lb      r17, 0(r6)       ; r17 = key[r6]
                beq     r17, r0, reset_key_ptr  ; If end of key, reset key pointer

                dsub    r18, r17, r8     ; r18 = key - 'a'
                daddi   r18, r18, 1      ; r18 = shift value

                ; check shift direction
                beq     r15, r12, shift_back  ; if shift direction is -1 -> shift back
                add     r19, r16, r18     ; else shift forward
                j       forward_wrap ; wrap handling

shift_back:
                sub     r19, r16, r18    ; shift back
                j       backward_wrap 

forward_wrap:
                slt     r20, r9, r19      ; if r19 > 'z' -> wrap
                beq     r20, r0, encrypted_char_store   ; else skip wrapping
                dsub    r19, r19, r10     ; wrap around (by subtracting)
                j       encrypted_char_store 

backward_wrap:
                slt     r20, r19, r8      ; if r19 < 'a' -> wrap
                beq     r20, r0, encrypted_char_store    ; else skip wrapping
                dadd    r19, r19, r10     ; wrap around (by adding)
                j       encrypted_char_store

encrypted_char_store:
                sb      r19, 0(r7)  ; storing encrypted char
                daddi   r5, r5, 1   ; msg++
                daddi   r6, r6, 1   ; key++
                daddi   r7, r7, 1   ; cipher++

                lb      r20, 0(r6)        ; load next key 
                bne     r20, r0, toggle_direction   ; check if end of key

reset_key_ptr:
                daddi   r6, r0, cipher_key  ; reset key pointer

toggle_direction: ; +1 -> -1, -1 -> +1 ..
                
                dsub    r15, r0, r15  ; r15 = -r15
                j       encryption_loop ; continue with the next character
exit:
                sb      r0, 0(r7)   ; store '\0' at the end of the cipher
                ; encrypted message printing
                daddi   r4, r0, cipher   ; r4 = ->cipher
                jal     print_string ; print cipher

; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
