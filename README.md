# Návrh počítačových systémů 2024 - projekt 2
Name: `Vigenèrova šifra na architektuře MIPS64`
Points: `max. 10b`
Deadline: `1.12.2024`

## Goal:
`porozumět principům zřetězeného zpracování instrukcí v procesorech pomocí vizualizace zřetězené linky procesoru MIPS64.`

## Assignment:
- program executing slightly changed algorithm of Vigenèrs cipher according to specifications.

In MIPS64 assembly language and using the EduMIPS64 simulator, write a program that implements a slightly modified Vigenère cipher algorithm according to the following specification. This is a stream substitution cipher, where encryption consists of replacing each letter in the message with another letter, shifted in the alphabet according to the corresponding letters of the encryption key: 
	‘a’ shifts by one letter,
	‘b’ by two letters, 
	‘c’ by three, and so on. 
Use alternating shifts forward and backward in the alphabet for each letter of the key. Encryption should always start with a forward shift. Shifts are cyclic, meaning if the encrypted character falls before the letter ‘a’ or after the letter ‘z’, it wraps around to the opposite end of the alphabet.

Consider a message consisting solely of lowercase alphabetic letters, representing your first and last name (no spaces, accents). The encryption key will be the **first** 3 letters of your last name (without accents) and will repeat periodically across the characters in the message.
#### Example:  
Message: `michalbidlo` 
Key: `bid`
Encryption process:  

| msg    | m    | i    | c    | h    | a    | l    | b    | i    | d    | l    | o    |
| ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| Key    | b    | i    | d    | b    | i    | d    | b    | i    | d    | b    | i    |
| Shift  | $+2$ | $-9$ | $+4$ | $-2$ | $+9$ | $-4$ | $+2$ | $-9$ | $+4$ | $-2$ | $+9$ |
| Result | o    | z    | g    | f    | j    | h    | d    | z    | h    | j    | x    |

Encrypted text: `ozgfjhdzhjx`
## Download/usage
[EduMIPS64](https://edumips.org/) - download latest from git-web, either `.jar` or `.msi` (don’t forget the documentation)

* Get to know the simulator `java -jar edumips64-1.3.0.jar --help`
* Detailed documentation in program menu `Help` -> `Manual` ...
* [Instruction set](https://edumips64.readthedocs.io/en/latest/instructions.html)
* Copy example file `hello.s` the same directory
* launch `java -jar edumips64-1.3.0.jar -f hello.s`
* run `F(4)` or debug `F(7)`
* default state `Ctrl-R`
## Instructions for solving/submitting:
* On the first line, add your first name, last name, and login without accents. 

* Replace the greeting string labeled `msg:` with `jaroslavmervart`
* Use the **first 3 letters** of your last name as the encryption key (`mer`) . Represent their ASCII codes in the program in a way that allows further calculations with them.

* The program must be able to encrypt any string of letters according to the described algorithm, assuming a maximum length of 30 characters (excluding the terminating 0), as reserved under the `cipher` label.

* The `cipher:` label designates the reserved space for the encrypted text. Write the encrypted characters here. Do not change the allocated size.

* The label `param_sys5:` allocates space to pass an argument to the "function" labeled `print_string:` for printing a text string. Printing is done using system call `syscall 5`. At the end, use the `print_string` call to output the encrypted text. For proper output functionality, the string must be terminated with a value of 0 (similar to strings in C).
 
* After the label `main:`, there is sample code for displaying the greeting string. Replace it with your solution.

* After completion, rename the file `hello.s` to `xlogin00.s` 

* Submit through STUDIS. Not compilable/launchable or crashing solutions will receive 0 points. $$\color{red}\text{Plagiarizers will be cleansed by the holy fire.}$$
![[EduMIPS64.v1.3.0.-.English.Manual.pdf#page=0]]

# Evaluation 10/10
