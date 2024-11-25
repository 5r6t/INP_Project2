; Autor reseni: Jaroslav Mervart xmervaj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jaroslavmervart" 
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

; zde si muzete nadefinovat vlastni promenne ci konstanty,
; m , e, r -> 109, 101, 114 -> key[i] - 'a' + 1
key:            .word 13, 5, 18; 'm', 'e', 'r'

wrap_LO_HI:      .word 24, -26 ; ('z' - 'a' - 1), ('a' - 'z' - 1)
ascii_a_b:       .word 97, 122

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)
; CODE SEGMENT
                .text
main:
    DADDIU r1, r0, key
    DADDIU r2, r0, wrap_LO_HI
    DADDIU r3, r0, ascii_a_b

    LW     r8, 0(r1)   ; store key in temporary register       
    LW     r9, 8(r1)   ; store key in temporary register     
    LW     r10, 16(r1) ; store key in temporary register

    LW     r11, 0(r2)  ; store wrap_lower  constant
    LW     r12, 8(r2)  ; store wrap_higher constant

    DADDI  r1, r0, 0   ; prep loop counter
    DADDI  r2, r0, 1   ; prep loop check
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
            DADDI   r4, r1, 0 ;
            DDIVU   r4, r3    ; R4 / 3 (remainder stored in HI)
            MFHI    r4        ; HI -> R4 

            BEQZ    r4, key_1       ; key_1 if R4 = 0, otherwise key_2
        
        key_2:
            DADDI   r4, r4, -1      ; Decrement R4
            BNEZ    r4, key_3       ; If R4 != 0 (therefore = 1 (was 2), so choose key_3), 

            DMULTU  r6, r9          ; switch * key
            J       wrap_check
        key_3:
            DMULTU  r6, r10         ; switch * key
            J       wrap_check
        key_1:
            DMULTU  r6, r8          ; switch * key
        ; key was chosen, continue in wrap check

        ; > case3: r5 is in interval <'a','z'> jump to write continue
        wrap_check:
            MFLO   r7               ; switch * key stored
            DADDI   r1, r1, 1       ; INCREMENT loop counter // here for optimalization
            
            DADD   r5, r5, r7       ; char + (switch*key)

            SLTIU r15, r5, 97 ; r15 = 1 when r5 < 'a', else r15 = 0
            SLTIU r16, r5, 123 ; r15 = 1 when r5 < 'z'+1, else r15 = 0

            BNEZ r15, wrap_lower 
            BEQZ r16, wrap_higher

            J write_continue
        ; > case2: r5 < 97 ---> r5 + ('z' - 'a' - 1) >>> 24 + r5
            wrap_lower: ; case - below r11 = 24
                DADD   r5, r5, r11
                J write_continue
            ; > case1: r5 > 122 --> r5 + ('a' - 'z' - 1) >>> r5 + r12
            wrap_higher: ; case - above r12 = -26
                DADD   r5, r5, r12

        write_continue:
            SB      r5, cipher(r1)  ; store byte in r5 to cipher on pos *r1
            J       my_loop         ; iterate

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
