; Autor reseni: Jaroslav Mervart xmervaj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jaroslavmervart" ; sem doplnte vase "jmenoprijmeni" 
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

; zde si muzete nadefinovat vlastni promenne ci konstanty,
key:            .word 13, 5, 18 ; m , e, r -> key[i] - 'a' + 1
switcher:       .word 1 ; used for inverting values, switcher * key[i]



params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:
    my_loop:
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
            ; switcher

            ;write to cipher and iterate

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
