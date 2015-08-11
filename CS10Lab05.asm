# David Gudeman
# CS10
# Lab four

.data
Instructions: .asciiz "Type in integers followed by a space\n"
EnterRowA: .asciiz "Array a - Enter row  "
EnterRowB: .asciiz "Array b - Enter row  "
EmptyLine: .asciiz "\n"
PrintRow: .asciiz "Row "
Colon: .asciiz ": "
Dash: .asciiz "- "
Space: .asciiz " "

listsz: .word 36 # using as array of integers
answer: .space 800
answersz: .word 73

.text
#####################get some memory to catch strings#####
la $t4, 0($sp) # set address to catch STRING in $t4
la $s4, 0($sp) # save address of STRING for LoopB
########################Print out instructions ############
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, Instructions
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 9    # ok to load 9 characters
la $a0, EmptyLine
syscall
########################Input String Text for array a #################################################
addi $t6, $zero, 1 # set enterString counter to 0
enterStringA: #Enter string numbers
li $v0, 4    # service number to PRINT STRING
li $a1, 12    # ok to load 9 characters
la $a0, EnterRowA
syscall
li $v0, 1    # service number PRINT INTEGER
move $a0, $t6 #load the value of the counter to print row number
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, Colon
syscall
la $a0, ($t4)
li $a1, 13    # ok to load 9 characters
li $v0, 8    # service number READ STRING
syscall      # read value goes into $t4

addi $t6, $t6, 1 # increment loop counter by one
addi $t4, $t4, 12 # move 8 spaces in the memory to catch next string of 4 char
ble $t6, 6, enterStringA # ends loop at number of rows to be entered
########################Print an Empty Line #######################
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, EmptyLine
syscall
########################Input String Text for array b ##############
li $t6, 1 # reset the counter to collect array B
enterStringB: #Enter string numbers
li $v0, 4    # service number to PRINT STRING
li $a1, 12    # ok to load 9 characters
la $a0, EnterRowB
syscall
li $v0, 1    # service number PRINT INTEGER
move $a0, $t6 #load the value of the counter to print row number
syscall
li $v0, 4    # service number to PRINT STRING
li $a1, 2    # ok to load 2 characters
la $a0, Colon
syscall
la $a0, ($t4)
li $a1, 13    # ok to load 9 characters
li $v0, 8    # service number READ STRING
syscall      # read value goes into $t4
addi $t6, $t6, 1 # increment loop counter by one
addi $t4, $t4, 8 # move 8 spaces in the memory to catch next string of 4 char
ble $t6, 6, enterStringB # ends loop at number of rows to be entered
############convert char to integers and put in new array#########
lw $s0, listsz   # $s0 = array dimension
sub $sp, $sp, 768 #make room on stack for 32 words
la $s1 ($sp)     #load base address of the array in $s1
li $t0, 0        # $t0 = # elems init'd

convertSringToInteger:beq $t0, $s0, doneConvert
lb $s3, ($s4) # store byte from $s4 into $s3
sub $s3, $s3, 0x30 # subtract 0x30 from character to convert to integer
sb $s3, ($s1) # store byte from $s3 to $s1
addi $s1, $s1, 4 # step to next array cell
addi $t0, $t0, 1 # count elem just init'd
addi $s4, $s4, 2 #increment the characters
b convertSringToInteger

doneConvert:
################Table of registers for the loop counters###############
#$t0 holds b array value
#$t1 holds i counter - a array row
#$t2 holds j counter - a array column
#$t3 holds k counter - b array row
#$t4 holds l counter - b array column
#$t5 holds calulations for b array
#$t6 holds value for b cell
#$t7 holds calculations for a array
#$t8 holds value for a cell and catches a value to add
#$t9 holds a array value and final calulation

#$s1 holds i calulcations a row
#$s2 holds j calculations a column
#$s3 holds k calculations b row
#$s4 holds l calculations b columns
#$s5 holds address for start of b array CONSTANT
#$s6 holds address for b array element
#$s7 holds address for a array element

#$a2 hold counter for the answer which incrments by 4
#$a3 holds address for the answer
##################initialize values for the loops###################
li $t1, 0x00 # i counter
li $t2, 0x00 # j counter
li $t3, 0x00 # k counter
li $t4, 0x00 # l counter
li $a2, 0x00 # ANSWER COUNTER
li $t7, 0x00 # m start the loop counter to calculate the answer array
li $t8, 0x00 # j counter for columns of Array One
li $t9, 0x00 # k counter for rows of Array Two
###########set base addresses for arrays to calculate and catch answer###
la $s5, 64($sp) # array b: add 64 to sp get to start of array b CONSTANT
la $a3 224($sp)#a3 will be the base address of answer array CONSTANT
###########start loops##################################################
i_loop:
li $t4, 0x00 # l counter

l_loop:
li $t2, 0x00 # j counter
li $t3, 0x00 # k counter

k_loop:
#set up b array
mul $s4, $t4, 6   # array b: l * 4 caclulates the b column
mul $s3, $t3, 36  # array b: k * 16 calculates the b row
add $t5, $s3, $s4 # array b: adds (4*l) + (16*k)
add $s6, $s5, $t5 # array b:  add offset $t5 to base of b array $s5 yields b cell address
lw $t6, ($s6)     # array b: operand for b loaded in $t6
#set up array
mul $s1, $t1, 36  # array a: i * 16 calculates a row
mul $s2, $t2, 6   # array a: j * 4 calculates the a column
add $t7, $s1, $s2 # array a: (i * 16)+(j*4) yeilds offset
add $s7, $sp, $t7 # array a: this adjusts the address to fetch
#calculate
lw $t0, ($s6)	  # array b: load operand
lw $t9, ($s7)     # array a: load operand 
mul $t9, $t0, $t9 # a * b sore in $t9
lw $t8 ($a3)      # array ANSWER - pull word out to add from the answer field
add $t8, $t9, $t8 # c + ab -
sw $t8, ($a3)     # array ANSWER store back in answer field
#increment counters
addi $a2, $a2, 1  # ANSWER: increment counter 
addi $t2, $t2, 1  # array a: increment j
addi $t3, $t3, 1  # array b: increment k
blt $t3, 6, k_loop
#increment counters
addi $a3, $a3, 4  #increments the address for the answer every 4
addi $t4, $t4, 1  # array b: $t4 is l, column counter for b
blt $t4, 6, l_loop
#increment counter
addi $t1, $t1, 1  # array a: $t1 is i, row counter for a
blt $t1, 6, i_loop
#exit:
####################Print out ANSWER array################################
la $a3 1280($sp)#a3 will be the base address of answer array CONSTANT
li $t8, 0x00 # initialize a counter for the OuterLoop
#sub $s1, $s1, 132 # load base address of the array

AnswerArrayPrintOut:
addi $t7, $zero, 0 # initialize a counter for InnerLoopOutPut
addi $a0, $0, 0xA #ascii code for Line Feed
addi $v0, $0, 0xB #syscall 11 prints the lower 8 bits of $a0 as an ascii character.
syscall

FourIntegerRowPrintOut: # cycles through 4 integers per row
lw $t5, ($a3) #loads INTEGER to print into $t5
li $v0, 1 # service number PRINT INTEGER
move $a0, $t5 #load the value $t5 (INTEGER) into $a0 for syscall
syscall
li $v0, 4 # service number to PRINT SPACE
li $a1, 2 # ok to load 9 characters
la $a0, Space # load address of Space into $a0
syscall
addi $t7, $t7, 1 # increment counter for InnerLoopOutPut
addi $a3, $a3, 4 # add to get to the next word in array

ble $t7, 6, FourIntegerRowPrintOut # break out of inner loop at 4
addi $t8, $t8, 1 # increment outer loop counter by one
ble $t8, 6, AnswerArrayPrintOut # break out of Loop if 9 rows is hit

li $v0, 10
syscall 
