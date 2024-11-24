; Autor reseni: Jaroslav Mervart xmervaj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jaroslavmervart" ; sem doplnte vase "jmenoprijmeni" 
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

; zde si muzete nadefinovat vlastni promenne ci konstanty,
key:            .word 13, 5, 18   ; m , e, r -> 109, 101, 114 -> key[i] - 'a' + 1


params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:
    DADDI  r1, r0, 0   ; init loop counter
    DADDI  r2, r0, 1   ; initialize loop check
    DADDI  r3, r0, 3   ; key length
    DADDI  r6, r0, -1  ; switcher

    my_loop:
        LB     r5, msg(r1)    ; Load byte from 'msg' at position *R1

        DSUB   r6, r0, r6     ; inverting switcher

        XORI   r2, r1, 0x1E   ; check  - comparing r1 with 30, r2=0 if true
        BEQ    r2, r0, end    ; finish - max loop iterations

        BEQZ   r5, end        ; finish - '\0' encountered on input 

        modulo:
            DADDIU  r4, r1, 0 ; copy loop_cnt to r4 
            DDIVU   r4, r3    ; R4 / 3 -> HI
            MFHI    r4        ; HI -> R4 - cases: 0->key_1(jump), 1->key_2(jump), 2->key_3 (fall through)

            BNEZ    r4, key_2       ; jump to key_2 if R4 != 0
            
        key_1:
            J write_continue ; logic...
        key_2:
            J write_continue ; logic...
        key_3:
            ; switcher * shift ( shifter can be negative)

            ; r5 * switcher * shift
            
            J write_continue ; logic...



        ; if greater/lower -> jump to wrap_around_+
        wrap_around_greater: ; case - above
            ; logic...
            ; jmp to write_continue  
        wrap_around_lower: ; case - below   
            ; logic...

        write_continue: ; condition not met, no need for logic, 
            SB      r5, cipher(r1)  ;// store byte in r5 to cipher on pos *r1
            DADDI   r1, r1, 1 ; increase loop counter
            J       my_loop       ; iterate
            ; switcher

    end:
                SB R0, cipher(r1)   ; add '\0' to encrypted login
                DADDI   r4, r0, cipher ; vypis: adresa cipher do r4
                JAL     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
