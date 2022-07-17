.eqv IN_ADDRESS_HEXA_KEYBOARD   0xFFFF0012         
.eqv OUT_ADDRESS_HEXA_KEYBOARD  0xFFFF0014
.eqv LEFT_LED          0xFFFF0011
.eqv RIGHT_LED            0xFFFF0010
.data
header: .asciiz "Welcome to Minh Dang and Minh Khoi Calculator \n"
inputNumberOne: .asciiz "Please input first number Ex: 23 \n"
inputNumberTwo: .asciiz "Please input second number Ex: 34 \n"
inputOperator: .asciiz "Press a to add two number \nPress b to subtract two number\nPress c to multiply two number\nPress d to divide two number \n"
alreadyInputOne: .asciiz "You already input first number: "
alreadyInputTwo: .asciiz "You already input second number: "
chooseSum: .asciiz "You chose the addition operation \n"
chooseSub: .asciiz "You chose the subtraction operation \n"
chooseMul: .asciiz "You chose the multiplication operation \n"
chooseDiv: .asciiz "You chose the division operation \n"
choosePrint: .asciiz "Please press f to print the result \n"
result: .asciiz "The result of operator is "
end: .asciiz "End of program \n"
thanks: .asciiz "Thanks for using this calculator \n"
error: .asciiz "Error happened please try again! \n"
arrHexLeds: .word 63, 6, 91, 79, 102, 109, 125, 7, 127, 111
nextline: .asciiz "\n"
runhere: .asciiz "Run here"
runhere1: .asciiz "RUnhere 1"
runhere2: .asciiz "RUn here 2"
.text
welcome:
  li $v0, 4
  la $a0, header
  syscall
AlertNumberOne:
  li $v0, 4
  la $a0, inputNumberOne
  syscall
#---------------------------------------------------------
# Enable interrupts you expect
#---------------------------------------------------------
li $t1, IN_ADDRESS_HEXA_KEYBOARD
li $t3, 0x80 # bit 7 of = 1 to enable interrupt
sb $t3, 0($t1)
#---------------------------------------------------------
# Declare variable
#---------------------------------------------------------
li $a2, 0 # a2 is used to store right LED value
li $a3, 0 # a3 is used to store left LED value
li $s1, 0 # store value of number when input
li $s2, 0 # store value of operation when input
li $s7, 0 # store value of '=' 
li $s3, 0 # first number
li $s4, 0 # second number
li $t0, 0 # count number
li $s5, 4 # length of number is 4
#---------------------------------------------------------
# Interrupt first number
#---------------------------------------------------------

LoopNumberOne:
  beq $t0, $s5, GetFirstNumber
  nop
  b LoopNumberOne
  beq $t0, $s5, GetFirstNumber
  nop
  b LoopNumberOne


GetFirstNumber:
  add $s3, $s1, $0
  addi $s1, $0, 0 # reset input number
  addi $t0, $0, 0 # reset count number

  # print first number to console
  li $v0, 4
  la $a0, alreadyInputOne
  syscall
  li $v0, 1
  add $a0, $0, $s3
  syscall
  li $v0, 4
  la $a0, nextline
  syscall

  li $a2, 0
  li $a3, 0

AlertNumberTwo:
  li $v0, 4
  la $a0, inputNumberTwo
  syscall

LoopNumberTwo:
  beq $t0, $s5, GetSecondNumber
  nop
  b LoopNumberTwo
  beq $t0, $s5, GetSecondNumber
  nop
  b LoopNumberTwo

GetSecondNumber:
  add $s4, $s1, $0
  addi $s1, $0, 0 # reset input number
  addi $t0, $0, 0  # reset count number

  # print second number to console
  li $v0, 4
  la $a0, alreadyInputTwo
  syscall
  li $v0, 1
  add $a0, $0, $s4
  syscall
  li $v0, 4
  la $a0, nextline
  syscall

  li $a2, 0
  li $a3, 0

AlertOperator:
  li $v0, 4
  la $a0, inputOperator
  syscall

LoopOperator:
  beq $t0, 1 , getOperator
  nop
  b LoopOperator

getOperator: 
  li $s1, 0 # reset input number
  li $t0, 0 # reset count number
  switchOperator:
    case_sum: 
      bne $s2, 1 , case_sub
      la $a0, chooseSum
      li $v0, 4
      syscall
      j AlertEqual
    case_sub:
      bne $s2, 2 , case_mul
      la $a0, chooseSub
      li $v0, 4
      syscall
      j AlertEqual
    case_mul:
      bne $s2, 3 , case_div
      la $a0, chooseMul
      li $v0, 4
      syscall
      j AlertEqual
    case_div:
      la $a0, chooseDiv
      li $v0, 4
      syscall
      j AlertEqual

AlertEqual:
  li $v0, 4
  la $a0, choosePrint
  syscall

LoopEqual:
  beq $s7, 1 ,getEqual
  b LoopEqual

getEqual:
  switchEqualOperator:
    case_sum_handler: 
      bne $s2, 1 , case_sub_handler
      addu $t8, $s3, $s4
      #print
      li $v0, 4
      la $a0, result
      syscall
      li $v0, 1
      add $a0, $0, $t8
      syscall
      li $v0, 4
      la $a0, nextline
      syscall
      # end print
      j HandleResult
    case_sub_handler:
      bne $s2, 2 , case_mul_handler
      subu $t8, $s3, $s4
      #print
      li $v0, 4
      la $a0, result
      syscall
      li $v0, 1
      add $a0, $0, $t8
      syscall
      li $v0, 4
      la $a0, nextline
      syscall
      # end print
      j HandleResult
    case_mul_handler:
      bne $s2, 3 , case_div_handler
      mul $t8, $s3, $s4
      #print
      li $v0, 4
      la $a0, result
      syscall
      li $v0, 1
      add $a0, $0, $t8
      syscall
      li $v0, 4
      la $a0, nextline
      syscall
      # end print
      j HandleResult
    case_div_handler:
      bne $s2, 4 , case_error_handler
      div $t8, $s3, $s4
      #print
      li $v0, 4
      la $a0, result
      syscall
      li $v0, 1
      add $a0, $0, $t8
      syscall
      li $v0, 4
      la $a0, nextline
      syscall
      # end print
      j HandleResult

case_error_handler:
  li $v0, 4
  la $a0, error
  syscall
  j welcome

HandleResult: #get the last two numbers
  li $t6,0
  li $t7,0
  div $t6,$t8,10
  mfhi $t7
  beq $t6,0, ShowResultOnLeds
  div $t6, $t6 ,10
  mfhi $t6

ShowResultOnLeds:
  li $t2,RIGHT_LED   # set light on LED right
  add $s0,$zero,$t7 
  jal HandleShow
  nop
  li $t2,LEFT_LED  # set light on LED left
  add $s0,$zero,$t6 
  jal HandleShow
  nop
  j endMain

endMain:
  la $a0, end
  li $v0, 4     
  syscall
  la $v0, 10   
  syscall

HandleShow:
  la $k0, arrHexLeds
  la $k1, nextline
  li $t9, 0
  loopShow:
    beq $k0, $k1, backToPosition
    nop
    beq $s0, $t9, getValueShowInHex
    addi $k0, $k0 ,4
    addi $t9, $t9, 1
    j loopShow
  j backToPosition
  getValueShowInHex:
    lb $t9, 0($k0)
    sb $t9, 0($t2)
  backToPosition: 
    li $k0, 0 #reset
    li $k1, 0 #reset
    li $t9, 0 #reset
    jr $ra


.ktext 0x80000180
 #--------------------------------------------------------
 # Processing
 #--------------------------------------------------------
IntSR:
#--------------------------------------------------------
# Process
#--------------------------------------------------------
  addi $t0,$t0,1
  jal handleInInterruptRowOne
  nop
  jal handleInInterruptRowTwo
  nop
  jal handleInInterruptRowThree
  nop
  jal handleInInterruptRowFour
  nop
#--------------------------------------------------------
# Evaluate the return address of main routine
# epc <= epc + 4
#--------------------------------------------------------
next_pc:mfc0 $at, $14 # $at <= Coproc0.$14 = Coproc0.epc
 addi $at, $at, 4 # $at = $at + 4 (next instruction)
 mtc0 $at, $14 # Coproc0.$14 = Coproc0.epc <= $at
return: eret 
#--------------------------------------------------------
# Restore variable
#--------------------------------------------------------
recoverStack:

# ------ 1 ------
handleInInterruptRowOne:
  subu $sp,$sp,4
  sw $ra,0($sp) 
  li $t1,IN_ADDRESS_HEXA_KEYBOARD
  li $t3,0x81     # Allow choose row 1
  sb $t3,0($t1)
  li $t1,OUT_ADDRESS_HEXA_KEYBOARD
  lb $t3,0($t1)   # Load value of row 1
  case_interrupt_0:
    li $t5,0x11
    bne $t3, $t5 ,case_interrupt_1  # case 0x11
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,0  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptOne
  case_interrupt_1:
    li $t5,0x21
    bne $t3, $t5 ,case_interrupt_2  # case 0x12
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,1  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptOne
  case_interrupt_2:
    li $t5,0x41
    bne $t3, $t5 ,case_interrupt_3  # case 0x13
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,2  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptOne
  case_interrupt_3:
    li $t5, 0xffffff81
    bne $t3, $t5 , getInterruptOne  # case 0x14
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,3  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptOne
  showInInterruptOne:
    li $t2,RIGHT_LED   # set light on LED right
    add $s0,$zero,$a2 # 
    jal displayLED
    nop
    li $t2,LEFT_LED  # set light on LED left
    add $s0,$zero,$a3 
    jal displayLED
    nop  
  getInterruptOne:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ------ 2 ------
handleInInterruptRowTwo:
  subu $sp,$sp,4
  sw $ra,0($sp) 
  li $t1,IN_ADDRESS_HEXA_KEYBOARD
  li $t3,0x82     # Allow choose row 2
  sb $t3,0($t1)
  li $t1,OUT_ADDRESS_HEXA_KEYBOARD
  lb $t3,0($t1)   # Load value of row 2
  case_interrupt_4:
    li $t5,0x12
    bne $t3, $t5 ,case_interrupt_5  # case 0x11
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,4  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptTwo
  case_interrupt_5:
    li $t5,0x22
    bne $t3, $t5 ,case_interrupt_6  # case 0x12
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,5  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptTwo
  case_interrupt_6:
    li $t5,0x42
    bne $t3, $t5 ,case_interrupt_7  # case 0x13
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,6  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptTwo
  case_interrupt_7:
    li $t5, 0xffffff82
    bne $t3, $t5 , getInterruptTwo  # case 0x14
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,7  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptTwo
  showInInterruptTwo:
    li $t2,RIGHT_LED   # set light on LED right
    add $s0,$zero,$a2 # 
    jal displayLED
    nop
    li $t2,LEFT_LED  # set light on LED left
    add $s0,$zero,$a3 
    jal displayLED
    nop  
  getInterruptTwo:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


# ------ 3 ------
handleInInterruptRowThree:
  subu $sp,$sp,4
  sw $ra,0($sp) 
  li $t1,IN_ADDRESS_HEXA_KEYBOARD
  li $t3,0x84     # Allow choose row 2
  sb $t3,0($t1)
  li $t1,OUT_ADDRESS_HEXA_KEYBOARD
  lb $t3,0($t1)   # Load value of row 2
  case_interrupt_8:
    li $t5,0x00000014
    bne $t3, $t5 ,case_interrupt_9  # case 0x11
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,8  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptThree
  case_interrupt_9:
    li $t5,0x00000024
    bne $t3, $t5 ,case_interrupt_a  # case 0x12
    addi $a3,$a2,0    # store left value
    addi $a2,$zero,9  # set right value
    mul $s1,$s1,10
    add $s1,$s1,$a2   # implement s1 = s1 * 10 + right value to get value of full number
    j showInInterruptThree
  case_interrupt_a:
    li $t5,0x44
    bne $t3, $t5 ,case_interrupt_b  # case 0x13
    addi $s2, $0, 1
    j getInterruptThree
  case_interrupt_b:
    li $t5, 0xffffff84
    bne $t3, $t5 , getInterruptThree  # case 0x14
    addi $s2, $0, 2  
    j getInterruptThree
  showInInterruptThree:
    li $t2,RIGHT_LED   # set light on LED right
    add $s0,$zero,$a2 # 
    jal displayLED
    nop
    li $t2,LEFT_LED  # set light on LED left
    add $s0,$zero,$a3 
    jal displayLED
    nop  
  getInterruptThree:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ------ 4 ------
handleInInterruptRowFour:
  subu $sp,$sp,4
  sw $ra,0($sp) 
  li $t1,IN_ADDRESS_HEXA_KEYBOARD
  li $t3,0x88     # Allow choose row 2
  sb $t3,0($t1)
  li $t1,OUT_ADDRESS_HEXA_KEYBOARD
  lb $t3,0($t1)   # Load value of row 2
  case_interrupt_c:
    li $t5,0x18
    bne $t3, $t5 ,case_interrupt_d  # case 0x13
    addi $s2, $0, 3
    j getInterruptFour
  case_interrupt_d:
    li $t5, 0x28
    bne $t3, $t5 , case_interrupt_f  # case 0x14
    addi $s2, $0, 4  
    j getInterruptFour
  case_interrupt_f:
    li $t5, 0xffffff88 
    bne $t3, $t5 , getInterruptFour # case 0x14
    addi $s7, $0, 1  
    j getInterruptFour
  getInterruptFour:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

displayLED: 
  subu $sp,$sp,4
  sw $ra,0($sp)   # save $ra
handleLedInterrupt:    
  la $k0, arrHexLeds
  la $k1, nextline
  li $t9, 0
  LoopLedInterrupt:
    beq $k0, $k1, case_error_handler
    nop
    beq $s0, $t9, getValueShowInHexInterrupt
    addi $k0, $k0 ,4
    addi $t9, $t9, 1
    j LoopLedInterrupt
  getValueShowInHexInterrupt:
    lb $t9, 0($k0)
    sb $t9, 0($t2)
resetInterrupt: 
  li $k0, 0 #reset
  li $k1, 0 #reset
displayLEDrt: 
  lw $ra,0($sp)
  addi $sp,$sp,4
  jr $ra


