; Autor reseni: Jaroslav Mervart xmervaj00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "jaroslavmervart" 

cipher:         .space  31 ; misto pro zapis zasifrovaneho textu

; zde si muzete nadefinovat vlastni promenne ci konstanty,

key:            .word 13, 5, 18   ; 'm' , 'e', 'r' = 109, 101, 114 -> key[i] - 'a' + 1

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)
; CODE SEGMENT
                .text
main:
    DADDI  r1, r0, 0       ; prep loop counter
    DADDI  r2, r0, 1       ; prep loop check
    DADDI  r3, r0, 3       ; key length
    DADDI  r6, r0, -1      ; switcher

    DADDIU r4, r0, key

    LW     r8, 0(r4)        ; store key in tmp R8      
    LW     r9, 8(r4)        ; store key in tmp R9  
    LW     r10, 16(r4)      ; store key in tmp R10

    my_loop:
        LB     r5, msg(r1)    ; Load byte from 'msg' at position R1
        DSUB   r6, r0, r6     ; invert SWITCHER (always -1 or 1)
        XORI   r2, r1, 0x1E   ; compare R1 with 30, R2 = 0 if true
        
        DADDI   r4, r1, 0     ; - copy LOOP_COUNTER to R4 for modulo check 

        BEQZ   r5, end        ; finish - '\0' on input 
        BEQ    r2, r0, end    ; finish - 30 iterations reached
        
        modulo:
            DDIVU   r4, r3       ; R4 / 3 (remainder stored in HI)
            MFHI    r4           ; HI -> R4 
            BEQZ    r4, key_1    ; key_1 if R4 = 0, otherwise key_2
        
        key_2:
            DADDI   r4, r4, -1      ; decrement R4
            BNEZ    r4, key_3       ; If R4 != 0 (means R4 = 2 before decrementation), 
            DMULTU  r6, r9          ; switch * key
            J       wrap_check
        key_3:
            DMULTU  r6, r10         ; switch * key
            J       wrap_check
        key_1:
            DMULTU  r6, r8          ; switch * key

        wrap_check:
            MFLO   r7               ; switch * key stored
            DADD   r5, r5, r7       ; char + (switch*key)

            SLTIU r15, r5, 97  ; R15 = 1 when R5 < 'a'     else R15 = 0
            SLTIU r16, r5, 123 ; R16 = 1 when R5 < 'z'+1   else R15 = 0

            BNEZ r15, wrap_lower 
            BEQZ r16, wrap_higher

            J write_continue   ; case_correct: R5 is in <'a','z'>
        
            wrap_lower: ; R5 < 97   --> R5 + ('z' - 'a' + 1) >>> R5 + 26
                DADDI   r5, r5, 26
                J write_continue
            
            wrap_higher: ; R5 > 122 --> R5 + ('a' - 'z' - 1) >>> R5 -26
                DADDI   r5, r5, -26

        write_continue:
            SB      r5, cipher(r1)  ; store byte from R5 to cipher on pos LOOP_COUNTER
            DADDI   r1, r1, 1       ; increment LOOP_COUNTER
            J       my_loop

    end:
                SB R0, cipher(r1)   ; add '\0' to cipher
                DADDI   r4, r0, cipher ; vypis: adresa cipher do r4
                JAL     print_string ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address