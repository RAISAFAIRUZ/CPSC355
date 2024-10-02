
/** 
UCID : 30162166
Assignment 2 Part 3
Course : CPSC 355
Lecture : 01
Tutorial : 03

Implement all the subroutines above as unoptimized closed subroutines, using stack variables to store all
local variables. Note that the function newCuboid() must have a local variable (called c) which is returned
by value to main(), where it is assigned to the local variables first and second. I

**/

define(FALSE, 0)                                                            //sets FALSE to 0
define(TRUE, 1)                                                             //set TRUE to 1
fmt: .string "Cuboid %s origin = (%d, %d)\n\tBase width = %d  Base length = %d\n\tHeight = %d\n\tVolume = %d\n\n"



fmtInitial:         .string "Initial cuboid values:\n"                      //string format to print initial values of the cuboid
fmtChanged:         .string "\nChanged cuboid values:\n"                    //string format to print changed values of the cuboid
//fmtOrgin:          .string "Cuboid %s orgin = (%d, %d)\n"                   //string format to print cuboid orgin point
//fmtBaseValues:      .string "\tBase width = %d Base length = %d\n"          //string format to print base values
//fmtHeight:          .string "\tHeight = %d\n"                               //string format to print height
fmtVolume:          .string "\tVolume = %d\n\n"                             //string format to print volume
fmtFirst:           .string "First"                                         //string format for label
fmtSecond:          .string "Second"                                        //string format for label 
 

                    .balign 4                                               //aligned instructions 
 
//struct point offset
point_x = 0                                                                 //offset for int x 
point_y = 4                                                                 //offset for int y
point_s = 16                                                                //size/offset of the structure point
 
//struct dimensionm offset
dimension_width = 0                                                         //offset for width
dimension_length =  4                                                       //offset for length
dimension_s = 16                                                            //size/offset for dimension structure 
 
//struct cuboid offset
cuboid_orgin = 0                                                            //offset for cuboid origin 
cuboid_base = 8                                                             //offset for cuboid base
cuboid_height = 16                                                          //offset for cuboid height 
cuboid_volume = 20                                                          //offset for cuboid volume
 

cuboid1_size = 24                                                           //cuboid 1 size
cuboid2_size = 24                                                           //cuboid 2 size
 
allocate = -(16 + cuboid1_size + cuboid2_size) & -16                        //allocating memory
deallocate = -allocate                                                      //deallocating
 
.global  main                                                               //makes the label “main” visible to the linker
 
cuboid1_s = 16                                                              //offset for 1st cuboid
cuboid2_s = 40                                                              //offset for 2nd cuboid
 
fp      .req x29                                                            //setting frame point to x29
lr      .req x30                                                            //setting link register to x30

//struct cuboid newCuboid
 
define(cuboid_base_s, x9)                                                   //sets cuboid_base_s to x9
cuboid_size = 16                                                            //a cuboid size
space_allocate = -(16 + cuboid_size) & -16                                  //allocating space for cuboid
space_deallocate = -space_allocate                                          //deallocating
cuboid_s = 16                                                               //cuboid offset
 
newCuboid:          stp fp, lr, [sp, -32]!                                          //allocating memory, stores frame pointer fp and lr
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    add cuboid_base_s, fp, cuboid_s                                 //adding cuboid to the base address
                    str wzr, [cuboid_base_s, cuboid_orgin  + point_x]               // storing 0 in point x
                    str wzr, [cuboid_base_s, cuboid_orgin  + point_y]               // storing 0 in point y
 
                    ldr w1, [cuboid_base_s, cuboid_orgin  + point_x]                //loading the value of x into the cuboid c point x
                    str w1, [x8, cuboid_orgin  + point_x]                           //storing value of x
 
                    ldr w2, [cuboid_base_s, cuboid_orgin  + point_y]                //loading the value of y into the cuboid c point y
                    str w2, [x8, cuboid_orgin +  point_y]                           //storing the valur of y
 
                    mov w3, 2                                                       //moving 2 into register w3
                    str w3, [cuboid_base_s, cuboid_base + dimension_width]          //storing the value of w3 into the cuboid c width
                    ldr w3, [cuboid_base_s, cuboid_base + dimension_width]          //loading the value
                    str w3, [x8, cuboid_base + dimension_width]                     //storing it in the register x8
                   
                    mov w4, 2                                                       //moving 2 into register w4
                    str w4, [cuboid_base_s, cuboid_base + dimension_length]         //storing the value of w4 into the cuboid c length
                    ldr w4, [cuboid_base_s, cuboid_base + dimension_length]         //loading the value
                    str w4, [x8, cuboid_base + dimension_length]                    //storing it in the register x8
 
                    mov w5, 3                                                       //moving 3 into register w5
                    str w5, [cuboid_base_s,cuboid_height]                           //storing the value of w5 as the cuboid c height
                    ldr w5, [cuboid_base_s,cuboid_height]                           //loading the value
                    str w5, [x8, cuboid_height]                                     //storing it in the register x8
 
                    mul w6, w3, w4                                                  //multiplying width and length of the cuboid storing in w6
                    mul w6, w6, w5                                                  // multiplying w6 with height to get the volume 
                    str w6, [cuboid_base_s, cuboid_volume]                          //storing the value of w5 as the cuboid c volume
                    ldr w6, [cuboid_base_s, cuboid_volume]                          //loading the value
                    str w6, [x8, cuboid_volume]                                     //storing it in the register x8
                   
                    ldp fp, lr, [sp], 32                                            //deallocating 
                    ret                                                             //return
 
move:               stp fp, lr, [sp, -16]!                                          //stores frame pointer fp and lr
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    ldr w10, [x0, cuboid_orgin + point_x]                           //loading the value of cuboid c origin point x into w10
                    add w10, w10, w1                                                //adding deltaX 
                    str w10, [x0, cuboid_orgin + point_x]                           //storing the new value of the origin point x 
 
                    ldr w11, [x0, cuboid_orgin + point_y]                           //loading the value of cuboid c origin point y into w11
                    add w11, w11, w2                                                //adding deltaY
                    str w11, [x0, cuboid_orgin + point_y]                           //storing the new value of the origin point Y
 
                    ldp fp, lr, [sp], 16                                            //deallocating memory
                    ret                                                             //return
 
scale:              stp fp, lr, [sp, -16]!                                          //allocating memory
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    ldr w12, [x0, cuboid_base + dimension_width]                    //loading the value of cuboid c base width into w12
                    mul w12, w12, w1                                                //multiplying by factor
                    str w12, [x0, cuboid_base + dimension_width]                    //storing the new value of cuboid c base width
 
                    ldr w13, [x0, cuboid_base + dimension_length]                   //loading the value of cuboid c base length into w13
                    mul w13, w13, w1                                                //multiplying by factor
                    str w13, [x0, cuboid_base + dimension_length]                   //storing the new value of cuboid c base length
 
                    ldr w14, [x0, cuboid_height]                                    //loading the value of cuboid height
                    mul w14, w14, w1                                                //multiplying by factor
                    str w14, [x0, cuboid_height]                                    //storing the new value of cuboid height
 
                    mul w15, w12, w13                                               //multiplying the new value of cuboid, width and length and storing it in w15
                    mul w15, w15, w14                                               //multiplying w15 with height to get the volume 
                    str w15, [x0, cuboid_volume]                                    //storing the volume into w15
 
                    ldp fp, lr, [sp], 16                                            //deallocating
                    ret                                                             //return
 
printCuboid:        stp fp, lr, [sp, -16]!                                          //allocating memory
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    adrp x0, fmt                                                    //addressing the string format
                    add x0, x0, :lo12:fmt                                           // setting argument of printf
                    mov w1, w1                                                      //label
                    ldr w2, [x8, cuboid_orgin + point_x]                            //loading the value of point x
                    ldr w3, [x8, cuboid_orgin + point_y]                            //loading the value of point y
                   // bl printf
                    
                    ldr w4, [x8, cuboid_base + dimension_width]                     //loading the value of cuboid width
                    ldr w5, [x8, cuboid_base + dimension_length]                    //loading the value of length
                   
                    ldr w6, [x8, cuboid_height]                                     //loading the value of height
                   
                    ldr w7, [x8, cuboid_volume]                                     //loading the value of volume
                    
                    bl printf                                                       //calling print to print the string labeled: fmt
 
                    ldp fp, lr, [sp], 16                                            //deallocating memory
                    ret                                                             //return
 
                    define(result, w19)                                             //storing the result into the register w19
 
 
equalSize:          stp fp, lr, [sp, allocate]!                                     //allocating memory
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    mov result, FALSE                                               //setting result to FALSE, 0 
 
                    ldr w10, [x0, cuboid_base + dimension_width]                    //loading the value of the first cuboid width into w10
                    ldr w11, [x0, cuboid_base + dimension_length]                   //loading the value of the first cuboid length into w11
                    ldr w14, [x0,cuboid_height]                                     //loading the value of the first cuboid height into w14
 
                    ldr w12, [x1, cuboid_base + dimension_width]                    //loading the value of the second cuboid width into w12
                    ldr w13, [x1, cuboid_base + dimension_length]                   //loading the value of the second cuboid length into w13
                    ldr w15, [x1,cuboid_height]                                     //loading the value of the second cuboid height into w15
 
                    cmp w10, w12                                                    //comparing the 1st and 2nd cuboid width
                    b.ne return                                                     //if not equal it goes to return
 
                    cmp w11, w13                                                    //comparing the 1st and 2nd cuboid length
                    b.ne return                                                     //if not equal it goes to return
 
                    cmp w14, w15                                                    //comapring the 1st and 2nd cuboid height
                    b.ne return                                                     //if not equal it goes to return 
 
                    mov result, TRUE                                                //if the comparison is equal then set result to true
                    mov w0, result                                                  //move result result into w0
                    bl dealloc                                                      //calling deallocating       
 
return:             mov w0, result                                                  //moves the false result into w0
 
dealloc:            ldp fp, lr, [sp], deallocate                                    //deallocate memory
                    ret                                                             //return 
                    
 
main:               stp fp, lr, [sp, allocate]!                                     //allocating memory
                    mov fp, sp                                                      //Updates FP to the current SP
 
                    add x8, fp, cuboid1_s                                           //storing the first cuboid 
                    bl newCuboid                                                    //calling newCuboid 
 
                    add x8, fp, cuboid2_s                                           //storing the second cuboid 
                    bl newCuboid                                                    //calling newCuboid
                    
                    adrp x0, fmtInitial                                             //addressing the string format
                    add x0, x0, :lo12:fmtInitial                                    //setting argument to fmtInitial
                    bl printf                                                       //calling print

                    add x8, fp, cuboid1_s                                           //storing the first cuboid
                    ldr x1, =fmtFirst                                               //loading the string fmtFirst into w1 to print
                    bl printCuboid                                                  //calls printCuboid
 
                    add x8, fp, cuboid2_s                                           //storing the second cuboid
                    ldr x1, =fmtSecond                                              //loading the string fmtSecond into w1 to print
                    bl printCuboid                                                  //calls printCuboid
 
                    add x0, fp, cuboid1_s                                           //storing address of cuboid 1 into x0
                    add x1, fp, cuboid2_s                                           //storing address of cuboid 2 into x1
                    bl equalSize                                                    //calls equalSize
 
                    cmp w0, FALSE                                                   //comaparing w0 with FALSE, 0 
                    b.eq printNew                                                   //if equal calls printNew
 
if_statement:       add x0, fp, cuboid1_s                                           //storing the addrress of cuboid 1 to x0
                    mov w1, 3                                                       //moving 3 into w1            
                    mov w2, -6                                                      //moving -6 into w2
                    bl move                                                         //calls move
 
                    add x0, fp, cuboid2_s                                           //storing the addrress of cuboid 2 to x0
                    mov w1, 4                                                       //mov 4 into w1
                    bl scale                                                        //calls scale
 
printNew:           adrp x0, fmtChanged                                            //addressing the string format
                    add x0, x0, :lo12:fmtChanged                                   //setting argument to fmtChanged
                    bl printf                                                      //prints the string
 
                    add x8, fp, cuboid1_s                                           //storing the first cuboid  
                    ldr w1, =fmtFirst                                               //loading the string fmtFirst into w1 to print
                    bl printCuboid                                                  //calling printcuboid to print values of the first cuboid
 
                    add x8, fp, cuboid2_s                                           //storing the second cuboid
                    ldr w1, =fmtSecond                                              //loading the string fmtSecond into w1 to print
                    bl printCuboid                                                  //calling printCuboid
 
done:               mov x0, 0
                    ldp fp, lr, [sp], deallocate                                    //deallocating memory 
                    ret                                                             //return
 







                    


                    
                    





















