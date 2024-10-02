/**

UCID : 30162166
Assignment 6
Course : CPSC 355
Lecture : 01
Tutorial : 03

File I/O and Floating-Point Numbers

**/

define(fd, w19)                 //register for file descriptor
define(read_r, x20)             //number of bites read stored into register 
define(buf_r, x21)              //buffer where the bytes to write are stored register

define(ex, d1)                 //register to store e^x
define(enegatex, d2)           //register to store e^-x

define(numerator, d22)          //register for nomenator
define(denomenator, d23)        //register for denomenator
define(currentRatioResult, d25) //register for result
define(power, d26)              //register to hold power value
define(accumulator, d28)        //register for accumulator
define(counter, d29)            //register for counter
define(value, d30)              //absolute value gets saved register 

buf_size = 8                    //buffer size
alloc = -(16 + buf_size) & -16    //allocating memory of buffer size
dealloc = -alloc                //deallocating
buf_s = 16                      //buffer base

                .data
absoluteValue:  .double 0r1.0e-10       //absolute value of the term is less than 1.0e-10


                .text
pn:             .string "input.bin"                                     //input file
header:         .string "       x           e^x             e^-x \n"  //header string      
output:         .string "%13.10f    \t%13.10f        %13.10f\n"       //output value
error:          .string "\nSomething went wrong. Try again!\n"         //error message


                .balign 4                               
                .global main                        
main:           stp     x29, x30, [sp, alloc]!                       //allocating memory
                mov     x29, sp

                //fmov    loopCounter, 1.0e+0 

                adrp	x0, header                                  //add header string x0
	            add	    x0, x0, :lo12:header                        //Pprint header
	            bl	    printf	

                mov     w0, -100                                    //1st argument(use cwd)
                adrp    x1, pn                                      //2nd argument (path name)
                add     x1, x1, :lo12:pn                           
                mov     w2, 0                                        //3rd argument (read only)
                mov     w3, 0                                        //4th arg (not used)
                mov     x8, 56                                      //openat I/O request
                svc     0                                           //call system function
                mov     fd, w0                                      //error check

                cmp     fd, 0                                       //compare it to 0 
                b.ge    open_ok                                     //go to open_ok if it is greater than 0

                adrp    x0, error                                   //if file not opened then load error message
                add     x0, x0, :lo12:error                         //print error message
                bl      printf  
                mov     w0, -1                                      //move -1 then go to deallocate

                b       done 

open_ok:        add	    buf_r, x29, buf_s                          //calculate buffer base

read_file:      mov     w0, fd                                      //1st argument(use cwd)
                mov     x1, buf_r                                   //2nd arg (ptr to buf)
                mov     w2, buf_size                                //3rd arg (n)
                mov     x8, 63                                      // read I/O request
                svc     0                                           //call sys function
                mov     read_r, x0                                  //move them to read values

                cmp     read_r, buf_size                            //compare if they are equal to check file read correctly
                b.ne    closeFile                                   //not equal then close file
                ldr     d0, [buf_r]                                 //load base address for e^x
                bl      startCal                                    //start the calculation
                fmov    ex, d0                                      //move the value to ex

                ldr     d0, [buf_r]                                 //load base address for e^-x
                fneg    d0, d0                                      //add the negative sign for e^-x
                bl      startCal                                    //start the calculation
                fmov    enegatex, d0                                //move the value to e^-x

                adrp	x0, output                                  //load output to print
	            add	    x0, x0, :lo12:output                        //add value to x0 register
	            ldr	    d0, [buf_r]                                 //load the calculated value
	            bl	    printf	                                    //print

	            b	    read_file                                   //do it for all values

closeFile:      mov     w0, fd                                      //1st argument 
                mov     x8, 57                                      //read I/O request
                svc     0                                           //call sys function
                mov     w0, 0                                       //move 0 then deallocate

done:           ldp     x29, x30, [sp], dealloc                     //deallocate
                ret

                .balign 4
                .global startCal

startCal:       stp     x29, x30, [sp, -16]!                        //allocatate memory for calculation
                mov     x29, sp

                fmov    numerator, d0                               //move value to be nomenator
                fmov    power, 1.0                                  //power starts with being 1
                fmov    counter, 1.0                                //counter is 1
                fmov    accumulator, 1.0                            //accumulator 1

                fmov    denomenator, power                          //denomenator is same as power

                fdiv    currentRatioResult, numerator, denomenator        //result = nomenator/denomenator
                fadd    accumulator, accumulator, currentRatioResult      //accumulator = 1 + result


calculation:    fmul    numerator, numerator, d0                        //x gets multiplied for each counter
                fadd    power, power, counter                           //power increases by 1 for rach loop
                fmul    denomenator, denomenator, power                 //denomenator is multiplied by the power for factorial
                fdiv    currentRatioResult, numerator, denomenator      //result = nomenator / denomenator
                fadd    accumulator, accumulator, currentRatioResult    //accumulator = 1 + result
                fabs    currentRatioResult, currentRatioResult

                adrp    x22, absoluteValue                              //load absolute value to x22
                add     x22, x22, :lo12:absoluteValue                   
                ldr     value, [x22]                                   //load it to value
                      
                fcmp    currentRatioResult, value                       //compare result with absolute value      
                b.ge    calculation

                fmov    d0, accumulator                                 //final result to print

                ldp     x29, x30, [sp], 16                                                      
                ret