.data
	string: .space 20
	firstCharacter: .space 4
	secondCharacter: .space 4
	thirdCharacter: .space 4
	fourthCharacter: .space 4
	fifthCharacter: .space 4
	sixthCharacter: .space 4
	seventhCharacter: .space 4
	lastCharacter: .space 4
	opcodeNum: .word 0
	opcode: .word 0
	funct: .word 0
	rs: .word 0
	rt: .word 0
	rd: .word 0
	immediate: .word 0
	shamt: .word 0
	jumpAddress: .word 0
	hexDigit1: .word 0
	hexDigit2: .word 0
	hexDigit3: .word 0
	hexDigit4: .word 0
	hexDigit5: .word 0
	hexDigit6: .word 0
	fileText: .space 1200
	A: .asciiz "A"
	B: .asciiz "B"
	C: .asciiz "C"
	D: .asciiz "D"
	E: .asciiz "E"
	F: .asciiz "F"
	leading00: .asciiz "00"
	dollarSign: .asciiz "$"
	paranthese1: .asciiz "("
	paranthese2: .asciiz ")"
	space: .asciiz ", "
	Ox: .asciiz "0x"
	promptHexString: .asciiz "\nEnter 8 digit hexadecimal value: \n"
	msgEmptyString: .asciiz "\nThe entered string was empty"
	msgShortString: .asciiz "\nThe entered string is too short"
	msgLongString: .asciiz "\nThe entered string is too long"
	msgInvalidDigit: .asciiz "\nThe string has an invalid hex digit"
	opcodelw: .asciiz "\nlw "
	opcodesw: .asciiz "\nsw "
	opcodeaddi: .asciiz "\naddi "
	opcodebeq: .asciiz "\nbeq "
	opcodebne: .asciiz "\nbne "
	opcodej: .asciiz "\nj "
	opcodejal: .asciiz "jal "
	functadd: .asciiz "\add "
	functsub: .asciiz "\sub "
	functmul: .asciiz "\mul "
	functdiv: .asciiz "\div "
	functor: .asciiz "\or "
	functand: .asciiz "\and "
	functnor: .asciiz "\nor "
	functslt: .asciiz "\slt " 
	functsll: .asciiz "\nsll "
	functsrl: .asciiz "\nsrl "
	functjr: .asciiz "\njr "
	fileName: .asciiz "C:\Users\CHRIS\Desktop\Comp Arch Source Code\course_project_Chris_Enciso\CompArchInputFile.txt"
	msgRType: .asciiz "\nThe opcode is for an arithmatic/logical instruction. The opcode is "
	msgInvalidOpcode: .asciiz "\nERROR: unrecognized opcode "
	

.text
main:
	start:
	
	
	
	
	li $v0, 4			#Prompts the user to input 8 digit hexadecimal string
	la $a0, promptHexString
	syscall
	
	la $a0, string 			#Reads in the input string 
	li $a1, 20
	
	li $v0, 8			#Instruction for reading in String
	syscall
	
	
	
	la $t1, string		#Reading the string characters into registers
	lb $s0, 0($t1)
	lb $s1, 1($t1)
	lb $s2, 2($t1)
	lb $s3, 3($t1)
	lb $s4, 4($t1)
	lb $s5, 5($t1)
	lb $s6, 6($t1)
	lb $s7, 7($t1)
	
	
	
	
	sw $s0, firstCharacter
	sw $s1, secondCharacter
	sw $s2, thirdCharacter
	sw $s3, fourthCharacter
	sw $s4, fifthCharacter
	sw $s5, sixthCharacter
	sw $s6, seventhCharacter
	sw $s7, lastCharacter
	
	li $t1, 10			
	lw $t0, firstCharacter
	
	beq $t1, $t0, Label		#Checks if the enetered string was empty
	j Exit
	Label: 
	li $v0, 4			
	la $a0, msgEmptyString
	syscall
	li $v0 10
	syscall
	Exit:
	
	lw $t2, lastCharacter
	
	beq $t2, $zero, Label1		#Checks if the entered string is too short
	beq $t2, $t1, Label1
	j leave
	Label1:  
	li $v0, 4
	la $a0, msgShortString
	syscall
	j start
	leave:
	
	la $t1, string
	lb $t2, 8($t1)
	
	bne $t2, 10, tooLong		#Checks if the entered string is too long
	j leave2
	tooLong:  
	li $v0, 4
	la $a0, msgLongString
	syscall
	j start
	leave2:
	
	
	la $s0, string
	li $s1, 0
	
	loop:				#Checks if each character is valid
	li $t4, 48
	beq $s1, 8, EndLoop
	lb $t0, ($s0)
	slt $t3, $t0, $t4		#Checks if character is less than 48
	beq $t3, 1, Invalid
	
	li $t4, 57
	sgt $t3, $t0, $t4		#Checks if character is greater than 57
	beq $t3, 1, GT57
	j loopBack
	
	
	GT57:
	li $t4, 65
	slt $t3, $t0, $t4		#checks if character is less than 65
	beq $t3, 1, Invalid
	
	li $t4, 70
	sgt $t3, $t0, $t4		#Checks if character is greater than 70
	beq $t3, 1, Invalid
	j loopBack
	
	
	Invalid: 
	li $v0, 4			#Invalid character is found exit the program
	la $a0, msgInvalidDigit
	syscall
	
	j start
	
	
	loopBack:
	addi $s1, $s1, 1		#Updates the current character and counter
	addi $s0, $s0, 1
	j loop
	
	
	EndLoop:			#Resuming after all characters are verified as valid
	
	li $t2, 58
	lw $t0, firstCharacter
	lw $t1, secondCharacter
	
	
	slt $t3, $t0, $t2, 		#Turns the first two hexadecimal values into decimal
	beq $t3, 1, Digit
	subi $t0, $t0, 55
	sw   $t0, firstCharacter
	j converted1
	Digit:
	subi $t0, $t0, 48
	sw   $t0, firstCharacter
	j converted1
	converted1:
	
	slt $t3, $t1, $t2
	beq $t3, 1, Digit2
	subi $t1, $t1, 55
	sw $t1, secondCharacter
	j converted2
	Digit2:
	subi $t1, $t1, 48
	sw $t1, secondCharacter
	j converted2

	
	converted2:
	lw $t0, thirdCharacter
	lw $t1, fourthCharacter
	
	slt $t3, $t0, $t2
	beq $t3, 1, Digit3
	subi $t0, $t0, 55
	sw $t0, thirdCharacter
	j converted3
	Digit3:
	subi $t0, $t0, 48
	sw $t0, thirdCharacter
	j converted3
	
	converted3:
	slt $t3, $t1, $t2
	beq $t3, 1, Digit4
	subi $t1, $t1, 55
	sw $t1, fourthCharacter
	j converted4
	Digit4:
	subi $t1, $t1, 48
	sw $t1, fourthCharacter
	j converted4
	
	converted4:
	lw $t0, fifthCharacter
	lw $t1, sixthCharacter
	
	slt $t3, $t0, $t2
	beq $t3, 1, Digit5
	subi $t0, $t0, 55
	sw $t0, fifthCharacter
	j converted5
	Digit5:
	subi $t0, $t0, 48
	sw $t0, fifthCharacter
	j converted5
	
	converted5:
	slt $t3, $t1, $t2
	beq $t3, 1, Digit6
	subi $t1, $t1, 55
	sw $t1, sixthCharacter
	j converted6
	Digit6:
	subi $t1, $t1, 48
	sw $t1, sixthCharacter
	j converted6
	
	converted6:
	lw $t0, seventhCharacter
	lw $t1, lastCharacter
	slt $t3, $t0, $t2
	beq $t3, 1, Digit7
	subi $t0, $t0, 55
	sw $t0, seventhCharacter
	j converted7
	Digit7:
	subi $t0, $t0, 48
	sw $t0, seventhCharacter
	j converted7
	
	converted7:
	slt $t3, $t1, $t2
	beq $t3, 1, Digit8
	subi $t1, $t1, 55
	sw $t1, lastCharacter
	j converted8
	Digit8:
	subi $t1, $t1, 48
	sw $t1, lastCharacter
	j converted8
	
	converted8:

	lw $t0, firstCharacter
	lw $t1, secondCharacter
	
	
	sll $t0, $t0, 4			#Extracts the opcode from the first 8 bits
	or $t0, $t0, $t1
	srl $t0, $t0, 2
	sw $t0, opcodeNum
	
	beq $t0, 35, loadWord		#Identifies the type of instruction from the opcode
	beq $t0, 43, storeWord
	beq $t0, 8, Addi
	beq $t0, 4, branchEqual
	beq $t0, 5, branchNotEqual
	beq $t0, $zero, RType
	beq $t0, 28, Mul
	beq $t0, 2, J
	beq $t0, 3, Jal
		
	li $v0, 4
	la $a0, msgInvalidOpcode	
	syscall
	
	li $v0, 4
	la $a0, string
	syscall
	
	li $v0, 10
	syscall
	
					#Ouputs the decimal representation of the opcode
	loadWord:
	li $v0, 4			
	la $a0, opcodelw
	syscall
	
	
	j IType
	
	storeWord:
	li $v0, 4
	la $a0, opcodesw
	syscall
	
	j IType
	
	Addi:
	li $v0, 4
	la $a0, opcodeaddi
	syscall
	
	j IType
	
	branchEqual:
	li $v0, 4
	la $a0, opcodebeq
	syscall
	
	j IType
	
	branchNotEqual:
	li $v0, 4
	la $a0, opcodebne
	syscall
	
	j IType
	
	Mul:
	li $v0, 4
	la $a0, functmul
	syscall
	
	j RType
	
	J:
	li $v0, 4
	la $a0, opcodej
	syscall
	
	j JType
	
	Jal:
	li $v0, 4
	la $a0, opcodejal
	syscall
	
	j JType
	
	
	
	
	IType:
	lw $t0, secondCharacter
	lw $t1, thirdCharacter
	
	sll $t0, $t0, 4			#Extracts the rs (bits 7-12) from the 32 bit string
	or  $t0, $t0, $t1
	andi $t0, $t0, 62
	srl $t0, $t0, 1
	sw $t0, rs
	
	lw $t0, thirdCharacter		#Extracts the rt (bits 13-18) from the 32 bit string
	lw $t1, fourthCharacter
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	andi $t0, $t0, 31
	sw $t0, rt
	
	lw $t0, fifthCharacter		#Extracts the immediatte from the 32 bit string
	lw $t1, sixthCharacter
	lw $t2, seventhCharacter
	lw $t3, lastCharacter
	
	sll $t0, $t0, 12
	sll $t1, $t1, 8
	sll $t2, $t2, 4
	or $t0, $t0, $t1
	or $t0, $t0, $t2
	or $t0, $t0, $t3
	sw $t0, immediate
	
	lw $t0, opcodeNum
	beq $t0, 35, DataTransfer
	beq $t0, 43, DataTransfer
	beq $t0, 8, branchOrAddi
	beq $t0, 4, branchOrAddi
	beq $t0, 5, branchOrAddi
	
	DataTransfer:
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	lw $a0, immediate
	syscall
	
	li $v0, 4
	la $a0, paranthese1
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rs
	syscall
	
	li $v0, 4
	la $a0, paranthese2
	syscall
	
	li $v0, 10
	syscall
	
	branchOrAddi: 
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 1
	lw $a0, rs
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	lw $t0, opcodeNum
	blt $t0, 4, skip
	bgt $t0, 5, skip
	
	la $t0, immediate		#Converts the Binary immediatte into 2's compliment form
	lb $t1, 0($t0)
	#srl $t1, $t1, 3
	#bne $t1, 1, skip
	#li $t2, 0
	#lw $t0, immediate
	#nor $t0, $t0, $t2
	#addi $t0, $t0, 1
	sw $t1, immediate
	
	skip:
	li $v0, 1
	lw $a0, immediate
	syscall
	
	li $v0, 10
	syscall
	
	RType:
	
	lw $t0, secondCharacter	
	lw $t1, thirdCharacter
	
	sll $t0, $t0, 4			#Extracts the rs (bits 7-11) from the 32 bit string
	or  $t0, $t0, $t1
	andi $t0, $t0, 62
	srl $t0, $t0, 1
	sw $t0, rs
	
	lw $t0, thirdCharacter		#Extracts the rt (bits 12-16) from the 32 bit string
	lw $t1, fourthCharacter
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	andi $t0, $t0, 31
	sw $t0, rt
	
	lw $t0, fifthCharacter		#Extracts the rd (bits 17-21) from the 
	lw $t1 sixthCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	srl $t0, $t0, 3
	sw $t0, rd
	
	lw $t0, sixthCharacter		#Extracts the rd (bits 17-21) from the 
	lw $t1 seventhCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	srl $t0, $t0, 2
	andi $t0, $t0, 31
	sw $t0, shamt
	
	lw $t0, seventhCharacter		#Extracts the function (bits 27 - 32) of the 32 bit string
	lw $t1, lastCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	andi $t0, $t0, 63
	sw $t0, funct
	
	lw $t0, funct
	beq $t0, 32, Add
	beq $t0, 34, Sub
	beq $t0, 36, And
	beq $t0, 37, Or
	beq $t0, 39, Nor
	beq $t0, 42, Slt
	beq $t0, 26, Div
	beq $t0, 0, Sll
	beq $t0, 2, Srl
	beq $t0, 8, Jr
	
	
	Add:
	li $v0, 4
	la $a0, functadd
	syscall
	
	j ThreeRegisters
	
	
	Sub:
	li $v0, 4
	la $a0, functsub
	syscall
	
	j ThreeRegisters
	
	And:
	li $v0, 4
	la $a0, functand
	syscall
	
	j ThreeRegisters
	
	Or:
	li $v0, 4
	la $a0, functor
	syscall
	
	j ThreeRegisters
	
	Nor:
	li $v0, 4
	la $a0, functnor
	syscall
	
	j ThreeRegisters
	
	Slt:
	li $v0, 4
	la $a0, functslt
	syscall
	
	j ThreeRegisters
	
	Sll:
	li $v0, 4
	la $a0, functsll
	syscall
	
	j logicals
	
	Srl:
	li $v0, 4
	la $a0, functsrl
	syscall
	
	j logicals
	
	Div:
	li $v0, 4
	la $a0, functdiv
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rs
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall 
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rt
	syscall 
	
	li $v0 10
	syscall
	
	Jr:
	li $v0, 4
	la $a0, functjr
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 1
	lw $a0, rs
	syscall
	
	li $v0, 10
	syscall
	
	
	
	ThreeRegisters:
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rd
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall 
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rs
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall 
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rt
	syscall 
	
	li $v0, 10
	
	logicals:
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rd
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall 
	
	li $v0, 4
	la $a0, dollarSign
	syscall 
	
	li $v0, 1
	lw $a0, rt
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall 
	
	li $v0, 1
	lw $a0, shamt
	syscall 
	
	li $v0 10
	syscall
	
	JType:
	
	lw $t0, secondCharacter		#extract the jump addresss in decimal
	lw $t1, thirdCharacter 
	
	sll $t0, $t0, 4
	or $t0, $t0, $t1
	andi $t0, $t0, 63
	
	lw $t2, fourthCharacter
	lw $t3, fifthCharacter
	lw $t4, sixthCharacter
	lw $t5, seventhCharacter
	lw $t6, lastCharacter
	sll $t0, $t0, 22
	sll $t2, $t2, 18
	or $t0, $t0, $t2
	sll $t3, $t3, 14
	or $t0, $t0, $t3
	sll $t4, $t4, 10
	or $t0, $t0, $t4
	sll $t5, $t5, 6
	or $t0, $t0, $t5
	sll $t6, $t6, 2
	or $t0, $t0, $t6
	
	lw $t1, opcodeNum
	beq $t1, 2, notJal
	addi $t0, $t0, 8
	notJal:
	sw $t0, jumpAddress
	
	
						#Convert the address from decimal to hex
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip1
	addi $t2, $t2, 55
	skip1:
	sw $t2, hexDigit1
	
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip2
	addi $t2, $t2, 55
	skip2:
	sw $t2, hexDigit2
	
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip3
	addi $t2, $t2, 55
	skip3:
	sw $t2, hexDigit3
	
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip4
	addi $t2, $t2, 55
	skip4:
	sw $t2, hexDigit4
	
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip5
	addi $t2, $t2, 55
	skip5:
	sw $t2, hexDigit5 
	
	div $t0, $t0, 16
	mflo $t0
	mfhi $t2
	ble $t2, 9, skip6
	addi $t2, $t2, 55
	skip6:
	sw $t2, hexDigit6
	
	li $v0, 4
	la $a0, leading00
	syscall
	
	lw $a0, hexDigit6
	ble $a0, 9, Print1
	jal PrintHexLetter
	j Next1
	Print1:
	
	li $v0, 1
	lw $a0, hexDigit6
	syscall
	Next1:
	
	lw $a0, hexDigit5
	ble $a0, 9, Print2
	jal PrintHexLetter
	j Next2
	Print2:
	
	li $v0, 1
	lw $a0, hexDigit5
	syscall
	Next2:
	
	lw $a0, hexDigit4
	ble $a0, 9, Print3
	jal PrintHexLetter
	j Next3
	Print3:
	
	li $v0, 1
	lw $a0, hexDigit4
	syscall
	Next3:
	
	lw $a0, hexDigit3
	ble $a0, 9, Print4
	jal PrintHexLetter
	j Next4
	Print4:
	
	li $v0, 1
	lw $a0, hexDigit3
	syscall
	Next4:
	
	lw $a0, hexDigit2
	ble $a0, 9, Print5
	jal PrintHexLetter
	j Next5
	Print5:
	
	li $v0, 1
	lw $a0, hexDigit2
	syscall
	Next5:
	
	lw $a0, hexDigit1
	ble $a0, 9, Print6
	jal PrintHexLetter
	j Next6
	Print6:
	
	li $v0, 1
	lw $a0, hexDigit1
	syscall
	Next6:
	
	li $v0, 10
	syscall
	
	PrintHexLetter:
	beq $a0, 65, PrintA
	beq $a0, 66, PrintB
	beq $a0, 67, PrintC
	beq $a0, 68, PrintD
	beq $a0, 69, PrintE
	beq $a0, 70, PrintF
	
	PrintA:
	li $v0, 4
	la $a0, A
	syscall  
	jr $ra
	
	PrintB:
	li $v0, 4
	la $a0, B
	syscall  
	jr $ra
	
	PrintC:
	li $v0, 4
	la $a0, C
	syscall  
	jr $ra
	
	PrintD:
	li $v0, 4
	la $a0, D
	syscall  
	jr $ra
	
	PrintE:
	li $v0, 4
	la $a0, E
	syscall  
	jr $ra
	
	PrintF:
	li $v0, 4
	la $a0, F
	syscall  
	jr $ra
	
	
	
	
	
	
	
	
	
	
