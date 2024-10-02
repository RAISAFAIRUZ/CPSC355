/** 
UCID : 30162166
Assignment 1 Part 2
Course : CPSC 355
Lecture : 01
Tutorial : 03

Question : Create an ARMv8 A64 assembly language program that finds the minimum of y = 3x^3 + 31x^2 - 15x -127
in the range -10<= x <= 4, by stepping through the range one by one in a loop and testing. Use only long
integers for x, and do not factor the expression. Use the printf() function to display to the screen the values
of x, y and the current minimum on each iteration of your loop.

Optimize the above program by putting the loop test at the bottom of the loop (make sure it is still a
pre-test loop), and by making use of the madd instruction. Also, add macros to the above program to
make it more readable (use m4). In particular, provide macros for heavily used registers

 */



//define macros 
define(x_r, x19)       //sets register x19, the value of x to x_r 
define(y_r, x20)       //sets register x20, the value of y to y_r 
define(z_r, x21)       //sets register x21, the minimum value to z_r 
define(a_r, x22)       //sets temporary register x22 to a_r, for calculations
define(b_r, x23)       //sets temporary register x23 to b_r 
define(c_r, x24)       //sets temporary register x24 to c_r 
define(d_r, x25)       //sets temporary register x25 to d_r 


fmt:    .string "Current value of X is %d, current value of Y is %d and the current minimum value of Y is %d\n"       //formating string the print statement 
        .balign 4       // aligned instructions 
        .global main    // makes the label “main” visible to the linker


main:   stp x29, x30, [sp, -16]!        //Stores the contents of the pair of registers to the stack 
        mov x29, sp                     //Updates FP to the current SP
        mov x_r, -10                    //stores the value of x which starts from -10
        mov y_r, 0                      //stores the value of y according to the calculations  
        mov z_r, 1000                   // z_r stores the current minimum value, which is set to a bigger value to be compared with a lesser value of y

        
        b   test                        //goes to test to test the loop

top:    mov y_r, 0                      // y is set to 0 for each iteration of the loop
        mov a_r, -127                   // a_r is set to -127
        mov b_r, -15                    // b_r is set to -15
        madd a_r, b_r, x_r, a_r         //multiplying the value of x to the value of b_r and adding the value of a_r. a_r = a_r + (b_r*x) = -127 -15x

        mov c_r, 31                     //c_r is set to 31
        mul c_r, c_r, x_r               //the value of x is multiplied with the value in c_r and stored in c_r = 31x
        madd a_r, c_r, x_r, a_r         //multiplying the value of x to the value of c_r and adding the value of a_r. a_r = a_r + (c_r*x) = -127 -15x + 31x^2

        mov d_r, 3                      //d_r is set to 3
        mul d_r, d_r, x_r               //the value of x is multiplied with the value in d_r and stored in d_r = 3x
        mul d_r, d_r, x_r               //the value of x is multiplied with the value in d_r and stored in d_r = 3x^2
        madd a_r, d_r, x_r, a_r         //a_r = 3x^3+31x^2 - 15x -127

        add y_r, y_r, a_r               //y_r, the value of y is updated to the calculated value of the polinomial for each x
        
        cmp y_r, z_r                    //comparing the values stored in y_r which is the current y value with the register z_r which is the current minimum
        b.gt  print                     //if y value is greater it goes to the print section

        mov z_r, y_r                    //otheriwse the current minimum value of y is updated then printed 
         
        
print:  adrp x0, fmt            //addressing the string format
        add x0, x0, :lo12:fmt   // setting argument of printf
        mov x1, x_r             //final value of x is set to the register x1 to print
        mov x2, y_r             //final value of y is set to the register x2 to print
        mov x3, z_r             //final value of current minimum y is set to the register x3 to print
       
        bl printf               //function call
        
        add x_r, x_r, 1         //increaments the value of x by 1 each time
        b test                  //goes back to test
        
test:   cmp x_r, 4              // comapring the current value of x with 4
        b.gt done               // if x_r is greater than 4 then it goes to done
        b.le top                // the loop iterates till x_r is less than or equal to 4


done:   mov w0, 0
        ldp x29, x30, [sp], 16  //Restores the state of the FP and LR registers and deallocates 16 bytes of stack memory
        ret                     //returns control to calling code (in OS)
