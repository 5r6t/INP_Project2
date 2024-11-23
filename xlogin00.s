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
    DADDI  r1, r0, 1   ;// initialize loop cnt
    DADDI  r2, r0, 1   ;// initialize loop check
    DADDI  r3, r0, 3   ;// key length
    
    
    my_loop:
        LB     r5, msg(r1)     ;// load byte from msg on pos *r1
        BEQZ   r5, end        ; finish - null terminator encountered on input 
        LB     r6, key(r1)

        XORI   r2, r1, 0x1E   ; check  - comparing r1 with 30, r2=0 if true
        BEQ    r2, r0, end     ; finish - max loop iterations

        ; if end of string -> check for ascii '0' ? or '\0'
        ; The .asciiz directive behaves exactly like the .ascii command, with the difference
        ; that it automatically ends the string with a null byte.
        ; load next value
        use_key_1:
            ; logic...
        use_key_2:
            ; logic...
        use_key_3:
            ; logic...
        
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
                daddi   r4, r0, cipher ; vypis: adresa cipher do r4
                jal     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
