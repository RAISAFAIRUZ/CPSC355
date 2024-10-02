/** 
UCID : 30162166
Assignment 3
Course : CPSC 355
Lecture : 01
Tutorial : 03

Create an ARMv8 assembly language program that implements the given algorithm

**/



//define macros

define(i, w19)     //register for i
define(j, w20)      //register for j
define(temp, w21)   //register for temp
define(vi, w22)     //register for v[i]
define(vj, w23)     //register for v[j]
define(vj_1, w24)   //register for v[j-1]
define(array_base, x25) //register to store array base
define(j_1, w26)    //register for j-1

fmtInitialArray:    .string "v[%d]: %d\n"           //print unsorted array format
fmtSortedArray:     .string "\nSorted array:\n"     //print sorted array format
fmtArrayElements:   .string "v[%d]: %d\n"           //print individual elements of array format
                    .balign 4                       // aligned instructions 
                    .global main                    // makes the label “main” visible to the linker

array_size = 50     //#define SIZE 50
array_size_bytes = array_size * 4       //4 bytes for each element in array

i_size = 4      //4 bytes for i   
j_size = 4      // 4 bytes for j
temp_size = 4  //4 bytes for temp

i_s = 16             //offset for i
j_s = i_s + 4        //offset for j
temp_s = j_s + 4     //offset for temp
array_base_s = temp_s + 4   //offset for array base

allocate = -(16 + array_size_bytes + i_s + j_s + temp_s + array_base_s) & -16
deallocate = -allocate

fp      .req x29
lr      .req x30

main:           stp fp, lr, [sp, allocate]!	            //stores frame pointer fp and lr
                mov fp, sp		                        //Updates FP to the current SP

               
                add array_base, fp, array_base_s    //array base address

                ldr i, [fp, i_s]    //load value of i 
                mov i, 0            //initiate i from 0
                str i, [fp, i_s]    //store value of i to stack

                b test1

loop1:          ldr i, [fp, i_s]    //load value of i
                bl rand             //generate random number store it in w0
                and vi, w0, 0xFF    //add the numbers to v[i]
              
                //add array_base, fp, array_base_s
                //ldr vi, [array_base, i, SXTW 2]
                str vi, [array_base, i, SXTW 2] //stores v[i] in array base address

                adrp    x0, fmtInitialArray           //addressing the string format
                add x0, x0, :lo12:fmtInitialArray   // setting argument of printf
                mov w1, i       //sets w1 to i to print          
                mov w2, vi    //sets w2 to v[i] to print
                bl printf    

                add i, i, 1         //increaments i
                str i, [fp, i_s]    // stores new value of i to stack

test1:          ldr i, [fp, i_s]    //loads value of i
                cmp i, array_size   //compares i with array size = 50
                b.lt loop1          // if less, enters loop1, to generate the unsorted array

                mov i,1             //for (i = 1)   
                str i, [fp, i_s]    //stores i value in stack
                b   testOuterLoop   //goes to test outer loop

outerLoop:     ldr i, [fp, i_s]
               ldr temp, [array_base, vi, SXTW 2]   //loads vi value to temp, temp = v[i]

               mov j, i                             //j = i
               ldr j, [fp, i_s]
               str j, [fp, i_s]
               b   testInnerLoop                      

innerLoop:     ldr j, [fp, j_s]  
               //sub j_1, j, 1
               ldr vj_1, [array_base, j_1, SXTW 2]      //value of j-1 is loaded into v[j-1]
               str vj, [array_base, vj_1, SXTW 2]       //v[j] = v[j-1]

               sub j, j, 1          //decreaments j by 1


testInnerLoop: ldr j, [fp, j_s]     //loads the value of j
               cmp j, 0             //comapres value of j to 0
               b.le outside         // if less or less than equal goes to outside of the inner loop

               sub j_1, j, 1        //j-1 = j - 1
               ldr vj_1, [array_base, j_1, SXTW 2]  //value of j-1 is loaded into v[j-1]

               ldr temp, [fp, temp_s]   
               str temp, [fp, temp_s]   
               cmp temp, vj_1   //compares temp with v[j-1]
               b.ge outside     //if temp > v[j-1] it goes to outside of the inner loop
               b innerLoop      //else go to inner loop

outside:       ldr temp, [fp, temp_s]
               ldr j, [fp, j_s]
               str temp, [array_base, vj, SXTW 2]   //v[j] = temp
                
               ldr i, [fp, i_s]
               add i, i, 1          //increaments i by 1
               str i, [fp, i_s]     //stores the new value in the stack
               

testOuterLoop: ldr i, [fp, i_s]
               cmp i,array_size     //compares i with array size = 50
               b.lt outerLoop       //if less than 50, goes to outer loop

printSorted:   adrp    x0, fmtSortedArray       //addressing the string format
               add x0, x0, :lo12:fmtSortedArray //prints sorted array

               bl printf

               mov i, 0             //i starts from 0 to print the elements

printElements: ldr i, [fp, i_s]
               cmp i, array_size    //compares i with array size = 50
               b.ge done            //if i >= 50, loop ends goes to done

               adrp    x0, fmtArrayElements       //addressing the string format
               add x0, x0, :lo12:fmtArrayElements
               mov w1, i    //loads value of i 
               mov w2, vi   //loads value of v[i]
               bl printf

               add i, i, 1  //increament i by 1 
               ldr i, [fp, i_s]
               str i, [fp, i_s]
               b printElements

done:          mov x0, 0   
               ldp x29, x30, [sp], deallocate  //Restores the state of the FP and LR registers and deallocates 16 bytes of stack memory
               ret               








