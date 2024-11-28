#include <stdio.h>
/**
 * @file xlogin.c
 * @brief program executing slightly changed algorithm of Vigenèrs cipher
 * - input is msg
 */

int main (void) {
    // data
    char msg[] = "jaroslavmervart";
    //char msg[] = "michalbidlo";
    char cipher[31] = { '\0' };

    char key[4]= {"mer"};
    //char key[4]= {"bid"};
    int shiftM = key[0] - 'a' + 1; // 2
    int shiftE = key[1] - 'a' + 1; // 9
    int shiftR = key[2] - 'a' + 1; // 4

    int curr_val;
    int switcher = 1;

    for (int i = 0; msg[i] != '\0'; i++) {
        
        curr_val = msg[i];
        if (i % 3 == 0) { 
            curr_val = curr_val +  shiftM*switcher;   
        }
        else if (i % 3 == 1) {
            curr_val = curr_val + shiftE*switcher;
        }
        else {
            curr_val = curr_val + shiftR*switcher;
        }

        if (curr_val > 122) { // greater than z
            curr_val = -26 + curr_val; // reach around; example: str_i = 114, +18 = 132, 
        }
        else if (curr_val < 97) { // smaller than a
            curr_val= 26 + curr_val; // reach around; example: str_i_new = 95, 97 - 95 = 2; z - 2 = x
        }
        cipher[i] = curr_val;
        switcher = switcher * (-1);
        printf("%c to %c\n", msg[i], cipher[i]); // debug
    }
    printf("> cipher: \"%s\" using \"%s\" as input, and \"%s\" as key \n", cipher, msg, key);

    return 0;
}
