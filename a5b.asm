define(i_r, w19)        //set i_r to w19
define(argc_r, w20)     //set argc_r to w20
define(month_r, w26)    //set argc_r to w26
define(day_r, w22)      //set day_r to w22
define(season_r, w23)   //set season_r to w23
define(suffix_r, w24)   //set suffix_r to w24
define(base_r, x25)     //set base_r to x25
define(argv_r, x21)     //set argv_r to X21


	            .text       //read-only, programmer-initialized data

january:        .string "January"        //string format to print january
febuary:        .string "Febuary"        //string format to print febuary
march:          .string "March"          //string format to print march
april:          .string "April"          //string format to print april
may:            .string "May"            //string format to print may
june:           .string "June"          //string format to print june
july:           .string "July"          //string format to print july
august:         .string "August"        //string format to print august
september:      .string "September"     //string format to print september
october:        .string "October"       //string format to print obctober
november:       .string "November"      //string format to print november
december:       .string "December"      //string format to print december 

st:             .string "st"            //string format for suffix st
nd:             .string "nd"            //string format for suffix nd
rd:             .string "rd"            //string format for suffix rd
th:             .string "th"            //string format for suffix th

winter:         .string "Winter"        //string format for winter
spring:         .string "Spring"         //string format for winter
summer:         .string "Summer"         //string format for winter
fall:           .string "Fall"           //string format for winter

display_date:   .string "%s %d%s is %s\n"       //display output
error:          .string "usage: a5b mm dd"      //display error

                .data                           // Create array of pointers
                .balign 8                       //Must be double-word aligned

month_m:        .dword january, febuary, march, april, may, june, july, august, september, october, november, december
suffix_m:       .dword st, th, nd, rd
season_m:       .dword winter, spring, summer, fall

                .text
                .balign 4
                .global main

main:           stp   x29, x30, [sp, -16]!           //allocating memory, stores frame pointer fp and lr
	            mov   x29, sp                        //Updates FP to the current SP

                mov argc_r, w0                       //mov value of w0 to argc_r     
                mov argv_r, x1                       //mov value of x1 to argv_r

                cmp argc_r, 3                        //compare the number of argument inputs
                b.ne error_message                   //if wrong number input print error message 

                mov i_r, 1                           //set up argument 
                ldr x0, [argv_r, i_r, SXTW 3]        //Calc array base address
                bl atoi                              //convert string to int
                mov month_r, w0                      //put the value of w0 to month register 

                cmp month_r, 0                       //if month input less or equal 0 
                b.le error_message                   //error 
                cmp month_r, 12                      //if month input greater than 12
                b.gt error_message                   //error

                mov i_r, 2                          //set up argument 
                ldr x0, [argv_r, i_r, SXTW 3]       //Calc array base address
                bl atoi                             //convert string to int
                mov day_r, w0                       //pu the value of day from w0 to register 

                cmp day_r, 0                        //if day input less or equal 0
                b.le error_message                  //error
                cmp day_r, 31                       //if input less or equal 31
                b.gt error_message                  //error

suffix_check:   cmp day_r, 1                       //if the date is 1, 21, 31 go to suffix_st to add the st suffix after date
                b.eq suffix_st
                cmp day_r, 21
                b.eq suffix_st
                cmp day_r, 31
                b.eq suffix_st

                cmp day_r, 2                       //if the date is 2, 22 go to suffix_st to add the nd suffix after date
                b.eq suffix_nd
                cmp day_r, 22
                b.eq suffix_nd

                cmp day_r, 3                       //if the date is 3, 23 go to suffix_st to add the rd suffix after date
                b.eq suffix_rd
                cmp day_r, 23
                b.eq suffix_rd

                b suffix_th                         //for all the other date go to suffix_th to add the th suffix after date

suffix_st:      mov suffix_r, 0                     //mov 0 to suffix register       
                b season                            //go to season

suffix_nd:      mov suffix_r, 1                     //mov 1 to suffix register       
                b season                            //go to season

suffix_rd:      mov suffix_r, 2                     //mov 2 to suffix register       
                b season                            //go to season

suffix_th:      mov suffix_r, 3                     //mov 3 to suffix register       
                b season                            //go to season

season:         cmp month_r, 1                      //january = winter 
                b.eq win                            
                cmp month_r, 2                      //february = winter 
                b.eq win 
                
                cmp month_r, 3                      //march = winter or spring
                b.eq winOrSpri

                cmp month_r, 4                      //april = spring 
                b.eq spri
                cmp month_r, 5                      //may = spring
                b.eq spri
                
                cmp month_r, 6                      //june = spring or summer
                b.eq spriOrSum

                cmp month_r, 7                      //july = summer
                b.eq sum
                cmp month_r, 8                      //august = summer
                b.eq sum

                cmp month_r, 9                      //september = summer or fall
                b.eq sumOrFall

                cmp month_r, 10                     //october = fall
                b.eq fal
                cmp month_r, 11                     //november = fall
                b.eq fal

                cmp month_r, 12                     //december = fall or winter 
                b.eq fallOrWin

winOrSpri:      cmp day_r, 21                       
                b.ge spri                           //if March is less than 21, winter
                b.lt win                            //if March is greater equal than 21, spring

spriOrSum:      cmp day_r, 21
                b.ge  sum                           //if June is less than 21, spring
                b.lt spri                           //if june is greater equal than 21, summer

sumOrFall:      cmp day_r, 21
                b.ge fal                            //if september is less  than 21, summer
                b.lt sum                            //if september is greater equal than 21, fall

fallOrWin:      cmp day_r, 21                       
                b.ge win                            //if december is less  than 21, fall
                b.lt fal                            //if december is greater than  than 21, winter 

win:            mov season_r, 0                     //put 0 to season register for winter 
                b printOutput

spri:           mov season_r, 1                     //put 1 to season register for spring
                b printOutput

sum:            mov season_r, 2                     //put 2 to season register for fall
                b printOutput

fal:            mov season_r, 3                     //put 3 to season register for winter 
                b printOutput   

error_message:  adrp x0, error                      //error message load to x0
                add x0, x0, :lo12:error
                bl printf                           //print error message 
                b done                              //go to done 

printOutput:    adrp x0, display_date                       //load display output to x0
                add x0, x0, :lo12:display_date

                adrp base_r, month_m                        //calculate array base address for month
	            add base_r, base_r, :lo12:month_m
	            sub month_r, month_r, 1                     //subtract month by 1      
	            ldr x1, [base_r, month_r, SXTW 3]           //set up first argument 

                mov w2, day_r                               //move value of day to w2

                adrp base_r, suffix_m                       //calculate array base address for suffix
	            add base_r, base_r, :lo12:suffix_m            
	            ldr x3, [base_r, suffix_r, SXTW 3]          //set up argument 

                adrp base_r, season_m                       //calculate array base address for season
	            add base_r, base_r, :lo12:season_m                 
	            ldr x4, [base_r, season_r, SXTW 3]          //set up argument 
                bl printf                                   //print display output

                b done                                      //go to done

done:           ldp   x29, x30, [sp], 16                    //deallocate 
	            ret


                














                 