define(FALSE, 0)                //sets FALSE to 0
define(TRUE, 1)                 //sets FALSE to 1

define(head_r, w10)             //head register put to w10
define(tail_r, w11)             //tail register put to w11
define(queue_r, w12)            //queue register put to w12

define(value, w9)               //value register put to w9

define(i, w22)                  //i is set to w22
define(j, w23)                  //j is set to w23
define(count, w24)              //count is set to w24
define(base_r, x20)             //base_r is set to x20

        .text

QUEUESIZE = 8           
MODMASK = 0x7


fp      .req x29                //setting frame point to x29
lr      .req x30                //setting link register to x20



                .data               // Create array of pointers
                .global head        //make head visible
                .global tail        //make tail visible
head:           .word   -1          //head at -1
tail:           .word   -1          //tail at -1

                .bss                
                .global queue           //make queue visible
queue:          .skip   QUEUESIZE * 4   //creates array with queuesize

                .text
                

overflow:       .string "\nQueue overflow! Cannot enqueue into a full queue.\n"         //string format for overflow
underflow:      .string "\nQueue underflow! Cannot dequeue from an empty queue.\n"      //string format for underflow
empty:          .string "\nEmpty queue\n"                                               //string format for empty queue
current:        .string "\nCurrent queue contents:\n"                                   //string format for current queue
elements:       .string " %d"                                                           //string format for each element
headDisplay:           .string " <-- head of queue"                                     //head of queue
tailDisplay:           .string "<-- tail of queue"                                      //tail of queue
endLine:        .string "\n"                                                            //end line

                                                        

                .balign 4
                .global enqueue

enqueue:        stp fp, lr, [sp, -16]!                                          //allocating memory, stores frame pointer fp and lr
                mov fp, sp                                                      //Updates FP to the current SP

                mov value, w0                       //mov w0 to value

                b  queueFull                        // go to queuefull
                cmp w0, TRUE                        //check if it is full
                b.ne enqueue_if2                    //if not go to if

                adrp x0, overflow                   //if full overflow
                add x0, x0, :lo12:overflow
                bl printf                           //print overflow

                b enqueue_end                       //go to deallocate 

/** if (queueEmpty()) {
    head = tail = 0;
}*/
enqueue_if2:    b queueEmpty                
                cmp w0, TRUE                        //if queue is not empty for go to else
                b.ne enqueue_else

                adrp base_r, head
                add base_r, base_r,:lo12:head        //calculate array base address for head
                mov w5, 0                            //move 0 to w5
                str w5, [base_r]                     //head = 0
                
                adrp base_r, tail                   //calculate array base address for tail
                add base_r, base_r,:lo12:tail
                mov w5, 0                           //move 0 to w5
                str w5, [base_r]                    //tail= 0
                b tail_value                        //go to new value esle statement

/**else {
    tail = ++tail & MODMASK;
} */
enqueue_else:   adrp base_r, tail                   //calculate array base address of tail
                add base_r, base_r,:lo12:tail
                ldr tail_r, [base_r]                //load tail register 

                add tail_r, tail_r, 1               //tail = ++tail
                and tail_r, tail_r, MODMASK         //tail = ++tail & MODMASK
                str tail_r, [base_r]                //store tail into base

/** queue[tail] = value*/
tail_value:     adrp base_r, tail                   //calculate array base address of tail
                add base_r, base_r,:lo12:tail
                ldr tail_r, [base_r]                //load tail register 

                adrp base_r, queue                  //calculate array base address of queue
                add base_r, base_r, :lo12:queue

                str value, [base_r, tail_r, SXTW 2]         //queue[tail] = value

//return
enqueue_end:    ldp fp, lr, [sp], 16                                            //deallocating memory
                ret   

                .balign 4
                .global dequeue                 //makes dequeue visible

dequeue:        stp fp, lr, [sp, -16]!          //allocating memory, stores frame pointer fp and lr
                mov fp, sp     

                b queueEmpty                    //if queue is not empty go to dequeue if statement
                cmp w0, TRUE
                b.ne dequeue_if1

                adrp x0, underflow              //if queue empty then underflow
                add x0, x0, :lo12:underflow
                bl printf                       //print underflow string

                mov w0, -1
                b dequeue_end

dequeue_if1:    adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

                adrp base_r, queue
                add base_r, base_r,:lo12:queue
                ldr value, [base_r, head_r, SXTW 2]  //value = queue[head]

                adrp base_r, tail
                add base_r, base_r,:lo12:tail
                ldr tail_r, [base_r]

                cmp head_r, tail_r      //if (head == tail)
                b.ne dequeue_else       // not equal go to else

                adrp base_r, head
                add base_r, base_r,:lo12:head
                mov w6, -1
                str w6, [base_r]    //head = -1
                
                adrp base_r, tail
                add base_r, base_r,:lo12:tail
                mov w6, -1
                str w6, [base_r]    //tail = -1 

                b dequeue_return

//head = ++head & MODMASK
dequeue_else:   add head_r, head_r, 1
                and head_r, head_r, MODMASK

                adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

//move value to w0
dequeue_return: mov w0, value

dequeue_end:    ldp fp, lr, [sp], 16                 //deallocating memory
                ret 

                .balign 4
                //.global dequeue

//checks if queue is full for not

queueFull:     stp fp, lr, [sp, -16]!               //allocating memory, stores frame pointer fp and lr
                mov fp, sp  

                adrp base_r, tail
                add base_r, base_r,:lo12:tail
                ldr tail_r, [base_r] 

                adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

                add tail_r, tail_r, 1
                and tail_r, tail_r, MODMASK     //((tail + 1) & MODMASK) == head

                cmp tail_r, head_r          //check if head and tail same
                b.ne queue_notFull          //not equal then not full

                mov w0, TRUE                //full

                b queueFull_end

queue_notFull:  mov w0, FALSE 

queueFull_end: ldp fp, lr, [sp], 16          //deallocating memory
                ret 

                .balign 4
                //.global dequeue

queueEmpty:    stp fp, lr, [sp, -16]!       //allocating memory, stores frame pointer fp and lr
                mov fp, sp  

                adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

                cmp head_r, -1              //(head == -1)
                b.ne queue_notEmpty

                mov w0, TRUE
                b queueEmpty_end

queue_notEmpty: mov w0, FALSE

queueEmpty_end: ldp fp, lr, [sp], 16        //deallocating memory
                ret 

                .balign 4
                .global display

display:        stp fp, lr, [sp, -16]!     //allocating memory, stores frame pointer fp and lr
                mov fp, sp  

                b queueEmpty
                cmp w0, TRUE
                b.ne display_if2

                adrp x0, empty
                add x0, x0, :lo12:empty
                bl printf

                b display_end

display_if2:    adrp base_r, tail
                add base_r, base_r,:lo12:tail
                ldr tail_r, [base_r] 

                adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

                sub count, tail_r, head_r   //count = tail - head + 1
                add count, count, 1

                cmp count, 0                //compare to 0
                b.gt display_current        //if greater go to loop

                add count, count, QUEUESIZE     //count += QUEUESIZE

display_current:  adrp x0, current
                  add base_r, base_r,:lo12:current
                  bl printf

                  adrp base_r, head
                  add base_r, base_r,:lo12:head
                  ldr head_r, [base_r]

                  mov i, head_r         //i = head
                  mov j, 0              //set j to 0 for loop counter
                  b test

display_loop:   adrp base_r, queue
                add base_r, base_r, :lo12:queue

                adrp x0, elements
                add base_r, base_r,:lo12:elements

                ldr w1, [base_r, i, SXTW 2]         //queue[i]

                bl printf

                adrp base_r, head
                add base_r, base_r,:lo12:head
                ldr head_r, [base_r]

                cmp i, head_r               //if i not equal head go to next if
                b.ne display_if3

                adrp x0, headDisplay
                add x0, x0, :lo12:headDisplay
                bl printf

display_if3:    cmp i, tail_r             //i == tail
                b.ne display_endLine

                adrp x0, tailDisplay
                add x0, x0, :lo12:tailDisplay
                bl printf

display_endLine: adrp x0, endLine
                add x0, x0, :lo12:endLine
                bl printf

                add i, i, 1             //i = ++i & MODMASK
                and i, i, MODMASK

                add j, j, 1

test:           cmp j, count            //check against count 
                b.lt display_loop       //if less than go to display loop

display_end:    ldp fp, lr, [sp], 16    //deallocating memory
                ret 
                














