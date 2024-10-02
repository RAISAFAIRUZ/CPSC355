/** 
UCID : 30162166
Assignment 2 Part 3
Course : CPSC 355
Lecture : 01
Tutorial : 03

Create an ARMv8 assembly language program that implements the following integer
multiplication program. Be sure to use 32-bit registers for variables declared using int, and 64-bit registers for variables
declared using long int. Use m4 macros to name the registers to make your code more readable.
Create a second version of the program (called assign2b.asm) that uses 522133279 for the
multiplicand, and 200 for the multiplier. 

**/



//define macros

define(multiplier_r, w19)       //sets register w19, to the value of multiplier 
define(multiplicand_r,w20)      //sets register w20, to the value of multiplicand 
define(product_r,w21)           //sets register w21, to the value of product 
define(i_r,w22)                 //sets register w22, to the value of loop counter, i 
define(negative_r, w24)         //sets register w24, to the value of negative flag

define(result_r, x25)           //sets register x25, to the value of result in 64bits 
define(temp1_r, x26)            //sets register x26, to the value of x to temporary register for product
define(temp2_r, x27)            //sets register x27, to the value of x to temporary register for multiplier 

fmtInitial:    .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"        //formating string the print statement 
fmt:           .string "product = 0x%08x multiplier = 0x%08x\n"                         // Print out product and multiplier
fmtResult:     .string "64-bit result = 0x%016lx (%ld)\n"                               // Print out 64-bit result
               .balign 4                                                                // aligned instructions 
               .global main                                                             // makes the label “main” visible to the linker

main:           
                stp x29, x30, [sp, -16]!	//stores frame pointer fp and lr
		mov x29, sp		        //Updates FP to the current SP
                mov multiplier_r, -256             //multiplier value moved to register                                        
                mov multiplicand_r, -252645136   //multiplicand value moved to register 
                mov product_r, 0                // product starts with 0
                mov i_r, 0                      //for loop counter, starts with 0 

                adrp x0, fmtInitial            //addressing the string format
                add x0, x0, :lo12:fmtInitial   //setting argument of printf
                mov w1, multiplier_r           //value of multiplier in hexadecimal is set in the register to print  
                mov w2, multiplier_r           //value of the multiplier in decimal is set in the register to print 
                mov w3, multiplicand_r         //value of the multiplicand in hexadecimal is set in the register to print 
                mov w4, multiplicand_r         //value of the multiplicand in decimal is set in the register to print 
       
                bl  printf                      //prints the first string, the intial values 

                cmp multiplier_r, 0             //compares multiplier with 0
                b.lt negative                   //if multiplier is less than 0, it goes to negative

                mov negative_r, 0               //otherwise a 0 flag is set, for FALSE
                b loop_condition                //goes to loop_condition after

negative:       mov negative_r, 1               //if the multiplier is negative, register is set to 1 for TRUE
                b loop_condition                //goes to loop_condition after

for_loop:       tst multiplier_r, 0x1           //sets or clears flags according to the result, checks if the last bit is 1 in multiplier
                b.eq shiftright_if              //goes to Arithmetic shift right
                add product_r, product_r, multiplicand_r        //product = product + multiplicand


shiftright_if:  asr multiplier_r, multiplier_r, 1       //multiplier = multiplier >> 1
                tst product_r, 0x1                      //compares last bit product and 1,product & 0x1 
                b.eq shiftright_else                    // loops to else 
                orr multiplier_r, multiplier_r, 0x80000000      //otherwise, multiplier = multiplier | 0x80000000
                b product_shift                                 //goes to arithmatic shift for product 

shiftright_else: and multiplier_r, multiplier_r, 0x7FFFFFFF     //multiplier = multiplier & 0x7FFFFFFF

product_shift: asr product_r, product_r, 1                      //product = product >> 1, arithmatic right shift of product
               add i_r, i_r, 1                                  //adds one to loop counter to go into the loop again, next line.

loop_condition: cmp i_r, 32                     //compares the loop counter with 32 
                b.lt for_loop                   //if less, it enters the for loop
                
                cmp negative_r, 0               //compares if the flag is set to 0,which is the multiplier is not negative
                b.eq print                      //goes to print 
                
                sub product_r, product_r, multiplicand_r        //otherwise if negative, product = product - multiplicand

print:          adrp x0, fmt            //addressing the string format
                add x0, x0, :lo12:fmt   // setting argument of printf
                mov w1, product_r       //sets w1 to product to print          
                mov w2, multiplier_r    //sets w2 to multiplier to print
                bl printf               //prints the 2nd string

                sxtw temp1_r, product_r         //Sign-extends bit 31 to bits 32-63, for product
                and temp1_r, temp1_r, 0xFFFFFFFF        //temp1=product & 0xFFFFFFFF
                lsl temp1_r, temp1_r, 32                //left shifts for temp1 << 32

                sxtw temp2_r, multiplier_r              //Sign-extends bit 31 to bits 32-63, for multiplier
                and temp2_r, temp2_r, 0xFFFFFFFF        //temp2=multiplier & 0xFFFFFFFF
                add result_r, temp1_r, temp2_r          //Combine product and multiplier together

                adrp x0, fmtResult           //addressing the string format
                add x0, x0, :lo12:fmtResult   // setting argument of printf
                mov x1, result_r              //hexadecimal value for result is moved to register to print        
                mov x2, result_r              //decimal value for result is moved to register to print
                bl printf                     //prints the 3rd string

                b done

done:  mov x0, 0
        ldp x29, x30, [sp], 16  //Restores the state of the FP and LR registers and deallocates 16 bytes of stack memory
        ret                     //returns control to calling code (in OS)
 







