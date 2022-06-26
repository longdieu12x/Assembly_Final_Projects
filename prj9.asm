.data  
# 16 rows, 60 cols
line1: .asciiz "                                            ************* \n"
line2: .asciiz "**************                            *3333333333333* \n"
line3: .asciiz "*222222222222222*                         *33333********  \n"
line4: .asciiz "*22222******222222*                       *33333*         \n"
line5: .asciiz "*22222*      *22222*                      *33333********  \n"
line6: .asciiz "*22222*       *22222*      *************  *3333333333333* \n"
line7: .asciiz "*22222*       *22222*    **11111*****111* *33333********  \n"
line8: .asciiz "*22222*       *22222*  **1111**       **  *33333*         \n"
line9: .asciiz "*22222*       *22222*  *1111*1            *33333********  \n"
line10:.asciiz "*22222*******222222*  *11111*             *3333333333333* \n"
line11:.asciiz "*2222222222222222*    *11111*              *************  \n"
line12:.asciiz "***************       *11111*                             \n"
line13:.asciiz "      ---              *1111**                            \n"
line14:.asciiz "    ( o o )             *1111****   *****                 \n"
line15:.asciiz "    (   > )              **111111***111*                  \n"
line16:.asciiz "     -----                 ***********    dce.hust.edu.vn \n"
#Menu
header: .asciiz "Welcome to Minh Dang and Minh Khoi Projects\n"
subheader: .asciiz "Please choose your choice: \n"
option1: .asciiz "1. Print image to the console \n"
option2: .asciiz "2. Print image with only border \n"
option3: .asciiz "3. Print image with ECD instead \n"
option4: .asciiz "4. Change color of the image \n"
option5: .asciiz "5. Exit \n"
colorD: .asciiz "Please choose color of D from (0-9): \n"
colorC: .asciiz "Please choose color of C from (0-9): \n"
colorE: .asciiz "Please choose color of E from (0-9): \n"
.text
main:
#Initialize
li $s2, 16 # row
li $s3, 60 # col
li $s4, 0x20 #space
#print all options
li $v0, 4
la $a0, header
syscall
li $v0, 4
la $a0, option1
syscall
li $v0, 4
la $a0, option2
syscall
li $v0, 4
la $a0, option3
syscall
li $v0, 4
la $a0, option4
syscall
li $v0, 4
la $a0, option5
syscall
#handle option
li $v0, 4
la $a0, subheader
syscall
li $v0, 5
syscall
switch_case:
  beq $v0, 1, handleOption1
  beq $v0, 2, handleOption2
  beq $v0, 3, handleOption3
  beq $v0, 4, handleOption4
  beq $v0, 5, exit
j main


exit:
li $v0, 10
syscall

handleOption1:
  li $t0, 0 #load index row
  la $a0, line1
  loopOption1:
    beq $t0, $s2, main #end row
    li $v0, 4
    syscall
    add $a0, $a0, $s3 #move to next row
    add $t0, $t0, 1
    j loopOption1



handleOption2:
  li $t0, 0 #row
  la $t2, line1
  loopOption2:
    beq $t0, $s2, main #end row
    li $t1, 0 #col
    addi $t0, $t0, 1 #increase index row
    printCharacterCol:
      beq $t1, $s3, loopOption2 #end col
      lb $a0, 0($t2)
      sge $k0, $a0, 48 # 0 in ascii
      sle $k1, $a0, 57 # 0 in ascii
      and $t3, $k0, $k1
      bne $t3, $0, replaceCharacterWithSpace
      j notReplace
      replaceCharacterWithSpace:
        add $a0, $0, $s4
      notReplace:
      li $v0, 11
      syscall
      addi $t2, $t2, 1
      addi $t1, $t1, 1
      j printCharacterCol
    j loopOption2
  

handleOption3:
  li $t0, 0 #load index row
  la $t2, line1
  loopOption3:
    beq $t0, $s2, main #end row
    # Divide space of each character in image\
    sb $0, 21($t2) #D
    sb $0, 41($t2) #C
    sb $0, 57($t2) #E
    # ECD
    li $v0, 4 
    la $a0, 42($t2) #E
    syscall

    li $v0, 11
    add $a0, $0, $s4
    syscall

    li $v0, 4 
    la $a0, 22($t2) #C
    syscall

    li $v0, 11
    add $a0, $0, $s4
    syscall

    li $v0, 4 
    la $a0, 0($t2) #E
    syscall

    li $v0, 4 
	  la $a0, 58($t2) # print \n
	  syscall

    recoverDCE:
      sb $s4, 21($t2)
      sb $s4, 41($t2)
      sb $s4, 57($t2)
    
    addi $t0, $t0, 1
    add $t2, $t2, $s3
    j loopOption3

handleOption4:
inputColorD:
  li $v0, 4
  la $a0, colorD
  syscall
  li $v0, 5
  syscall
  blt $v0, 0, inputColorD
  bgt $v0, 9, inputColorD
  addi $t4, $v0, 48
inputColorC:
  li $v0, 4
  la $a0, colorC
  syscall
  li $v0, 5
  syscall
  blt $v0, 0, inputColorC
  bgt $v0, 9, inputColorC
  addi $t5, $v0, 48
inputColorE:
  li $v0, 4
  la $a0, colorE
  syscall
  li $v0, 5
  syscall
  blt $v0, 0, inputColorE
  bgt $v0, 9, inputColorE
  addi $t6, $v0, 48

handleChangeColor:
  li $t0, 0 #load index row
  la $t2, line1
  loopOption4:
    bge $t0, $s2, main
    li $t1, 0 #col
    loopColumns:
      lb $a1, 0($t2)
      add $a0, $a1, $0
      bge $t1, $s3, increaseRowOption4
      ble $t1, -1, continueD
      conditionChangeColorD:
        sge $a2, $a1, 48
        sle $a3, $a1, 57
        and $a2 ,$a2, $a3
        bne $a2, $0, changeColorD
        j continueD
        changeColorD:
          add $a0, $0, $t4
          sb $a0, 0($t2)
      continueD:
      ble $t1, 21, continueC
      conditionChangeColorC:
        sge $a2,$a1, 48
        sle $a3, $a1, 57
        and $a2 ,$a2, $a3
        bne $a2, $0, changeColorC
        j continueC
        changeColorC:
          add $a0, $0, $t5
          sb $a0, 0($t2)
      continueC:
      ble $t1, 41, continueE
      conditionChangeColorE:
        sge $a2,$a1, 48
        sle $a3, $a1, 57
        and $a2 ,$a2, $a3
        bne $a2, $0, changeColorE
        j continueE
        changeColorE:
          add $a0, $0, $t6
          sb $a0, 0($t2)
      continueE:
      li $v0, 11
      syscall
      addi $t1, $t1, 1
      addi $t2, $t2, 1
      j loopColumns
    increaseRowOption4:
    addi $t0, $t0, 1
    j loopOption4
