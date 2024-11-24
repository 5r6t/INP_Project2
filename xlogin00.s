; Autor reseni: Jaroslav Mervart xmervaj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jaroslavmervart" ; sem doplnte vase "jmenoprijmeni" 
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

; zde si muzete nadefinovat vlastni promenne ci konstanty,

; m , e, r -> 109, 101, 114 -> key[i] - 'a' + 1
key:            .word 13, 5, 18

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:
    DADDIU r1, r0, key   
    LW     r8, 0(R1)         
    LW     r9, 8(r1)        
    LW     r10, 16(R1)        


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
            ; R4 = R1 => R4 % 3 = HI => R4 = HI 
            DADDI   r4, r1, 0 ; R4 = loop_cnt - to avoid changing R1's content
            DDIVU   r4, r3    ; R4 / 3 (remainder stored in HI)
            MFHI    r4        ; HI -> R4 
            
            ; cases: 0->key_1(jump), 1->key_2(jump), 2->key_3 (fall through)
            

            BEQZ    r4, key_1       ; key_1 if R4 = 0
            
        ;POSSIBLE values of R4: 0 = key1; 1 or 2 == key2... if key2, then if R4-1=0 stay, else jump to key 3 
        key_2:
            DADDI   r4, r4, -1      ; Decrement R4
            BNEZ    r4, key_3       ; If R4 != 0 (therefore = 1 (was 2), so choose key_3), 
            ;LW      r4, 4(r7) 
            DMULTU  r6, r9          ; switch * key
            MFLO    r7              ; switch * key stored
            DADD   r5, r5, r7       ; char + (switch*key)

            J    write_continue
        key_3:
            ;LW   r4, 8(r7) 
            ; logic...
            ; switcher * shift ( shifter can be negative)
            DMULTU  r6, r10          ; switch * key
            MFLO    r7              ; switch * key stored
            DADD   r5, r5, r7       ; char + (switch*key)
            J    write_continue 
        key_1:
            ; logic...
            DMULTU  r6, r8          ; switch * key
            MFLO    r7              ; switch * key stored
            DADD   r5, r5, r7       ; char + (switch*key)
            J    write_continue

            ; r5 * switcher * shift

        ; HOW TO WRAP LOWER OR GREATER:
        ; 1. 'z' (ASCII 122) - R5 ???
        ; > case1: r5 > 0
        ; > case2: r5 < 0
        ; > case3: r5 = 0

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
