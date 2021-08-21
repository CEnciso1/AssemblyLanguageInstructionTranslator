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
	intStr: .space 8
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
	index: .word 0
	fileName: .space 1200
	fileNameInput: .space 1200
	fileText: .space 1200
	clear: .asciiz ""
	zero: .asciiz "0"
	nl: .asciiz "\r\n"
	newLine: .asciiz "\n"
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
	promptHexString: .asciiz "Enter 8 digit hexadecimal value:"
	msgEmptyString: .asciiz "The entered string was empty\n"
	msgShortString: .asciiz "The entered string is too short"
	msgLongString: .asciiz "The entered string is too long"
	msgInvalidDigit: .asciiz "The string has an invalid hex digit\n"
	opcodelw: .asciiz "lw "
	opcodesw: .asciiz "sw "
	opcodeaddi: .asciiz "addi "
	opcodebeq: .asciiz "beq "
	opcodebne: .asciiz "bne "
	opcodej: .asciiz "j "
	opcodejal: .asciiz "jal "
	functsrl: .asciiz "srl "
	functadd: .asciiz "add "
	functsub: .asciiz "sub "
	functmul: .asciiz "mul "
	functdiv: .asciiz "div "
	functor: .asciiz "or "
	functand: .asciiz "and "
	functnor: .asciiz "nor "
	functslt: .asciiz "slt " 
	functsll: .asciiz "sll "
	functjr: .asciiz "jr "
	Output: .asciiz "C:/Users/Noah/Desktop/CourseProject_Noah_Fornero/output.asm"
	msgRType: .asciiz "The opcode is for an arithmatic/logical instruction. The opcode is "
	msgInvalidOpcode: .asciiz "ERROR: unrecognized opcode"
	filePrompt: .asciiz "Please input the file directory:\n"
	filePrompt2: .asciiz "Invalid file, Please input a valid file directory:\n"
	OutputName: .asciiz "output.asm"

.text
main:
	li $v0, 4
	la $a0, filePrompt
	syscall
main2:
	li $v0, 8
	la $a0, fileNameInput
	li $a1, 1200
	syscall
	xor $a2, $a2, $a2
	removeNewLine:	#removes \n from the input so that it can be read from
        lbu $a3, fileNameInput($a2)
        sb $a3, Output($a2)  
        addiu $a2, $a2, 1
        beq $a3, 47, slashFound
        bnez $a3, removeNewLine      
        beq $a1, $a2, done   
        subiu $a2, $a2, 2 
        sb $0, fileNameInput($a2)
        
        slashFound: #used to get last index of / to edit directory for output
        bne $a3, 47, done
        move $s5, $a2
        j removeNewLine   
	done:
	li $s3, 0
	changeOutput: #changes output to have the same directory as the input 
	lbu $a3, OutputName($s3)
        sb $a3, Output($s5)  
        addiu $s3, $s3, 1
        addiu $s5, $s5, 1
        bnez $a3, changeOutput     
        beq $a1, $a2, done2   
        subiu $s5, $s5, 1
        sb $0, Output($s5)
	done2:

	li $v0, 13 
	la $a0, fileNameInput
	li $a1, 0
	la $a2, 0
	syscall
	move $s0, $v0 

	
	li $v0, 14 		
	move $a0, $s0
	la $a1, fileText
	la $a2, 1200
	syscall
	
	la $t1, fileText
	lb $s0, 0($t1)
	beq $s0, 0, emptyFile	#checks to see if file contains anything
	
	li $v0, 16
	move $a0, $s0
	syscall
	
	li $v0, 13		
	la $a0, Output
	li $a1, 1            
	li $a2, 0
	syscall
	move $t7, $v0
	la $t1, fileText		
	li $t9, 0
	start:
	lb $s0, 0($t1)
	lb $s1, 1($t1)
	lb $s2, 2($t1)
	lb $s3, 3($t1)
	lb $s4, 4($t1)
	lb $s5, 5($t1)
	lb $s6, 6($t1)
	lb $s7, 7($t1)
	beq $s7, 0, Exit2
	addi $t1, $t1, 10
	
	sw $s0, firstCharacter
	sw $s1, secondCharacter
	sw $s2, thirdCharacter
	sw $s3, fourthCharacter
	sw $s4, fifthCharacter
	sw $s5, sixthCharacter
	sw $s6, seventhCharacter
	sw $s7, lastCharacter
	
	li $t8, 10			
	lw $t0, firstCharacter
	
	beq $t8, $t0, Label	#Checks if the entered string was empty
	j Exit
	Label:
	li $v0, 4
	la $a0, filePrompt2
	syscall
	j main2
	
	Exit:
	
	la $s0, fileText
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
	
	emptyFile:
	li $v0, 4
	la $a0, msgEmptyString
	syscall
	j start
	Invalid:
	li $v0, 4
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
	lw $t8, secondCharacter
	
	
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
	
	slt $t3, $t8, $t2
	beq $t3, 1, Digit2
	subi $t8, $t8, 55
	sw $t8, secondCharacter
	j converted2
	Digit2:
	subi $t8, $t8, 48
	sw $t8, secondCharacter
	j converted2

	
	converted2:
	lw $t0, thirdCharacter
	lw $t8, fourthCharacter
	
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
	slt $t3, $t8, $t2
	beq $t3, 1, Digit4
	subi $t8, $t8, 55
	sw $t8, fourthCharacter
	j converted4
	Digit4:
	subi $t8, $t8, 48
	sw $t8, fourthCharacter
	j converted4
	
	converted4:
	lw $t0, fifthCharacter
	lw $t8, sixthCharacter
	
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
	slt $t3, $t8, $t2
	beq $t3, 1, Digit6
	subi $t8, $t8, 55
	sw $t8, sixthCharacter
	j converted6
	Digit6:
	subi $t8, $t8, 48
	sw $t8, sixthCharacter
	j converted6
	
	converted6:
	lw $t0, seventhCharacter
	lw $t8, lastCharacter
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
	slt $t3, $t8, $t2
	beq $t3, 1, Digit8
	subi $t8, $t8, 55
	sw $t8, lastCharacter
	j converted8
	Digit8:
	subi $t8, $t8, 48
	sw $t8, lastCharacter
	j converted8
	
	converted8:

	lw $t0, firstCharacter
	lw $t8, secondCharacter
	
	
	sll $t0, $t0, 4			#Extracts the opcode from the first 8 bits
	or $t0, $t0, $t8
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
	li $v0, 15 			
	move $a0, $t7
	la $a1, msgInvalidOpcode
	la $a2, 27
	syscall
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	li $v0, 4
	la $a0, newLine
	syscall 
	j start
	
					#Ouputs instruction name
	loadWord:
	li $v0, 4
	la $a0, opcodelw
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodelw
	la $a2, 3
	syscall
	
	
	j IType
	
	storeWord:
	li $v0, 4
	la $a0, opcodesw
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodesw
	la $a2, 3
	syscall
	
	j IType
	
	Addi:
	li $v0, 4
	la $a0, opcodeaddi
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodeaddi
	la $a2, 5
	syscall
	
	j IType
	
	branchEqual:
	li $v0, 4
	la $a0, opcodebeq
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodebeq
	la $a2, 4
	syscall
	
	j IType
	
	branchNotEqual:
	li $v0, 4
	la $a0, opcodebne
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodebne
	la $a2, 4
	syscall
	
	j IType
	
	Mul:
	li $v0, 4
	la $a0, functmul
	syscall 
	li $v0, 15 			
	move $a0, $t7
	la $a1, functmul
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	J:
	li $v0, 4
	la $a0, opcodej
	syscall 
	li $v0, 15 
	move $a0, $t7
	la $a1, opcodej
	la $a2, 2
	syscall
	
	j JType
	
	Jal:
	li $v0, 4
	la $a0, opcodejal
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, opcodejal
	la $a2, 4
	syscall
	
	j JType
	
	
	
	
	IType:
	lw $t0, secondCharacter
	lw $t8, thirdCharacter
	
	sll $t0, $t0, 4			#Extracts the rs (bits 7-12) from the 32 bit string
	or  $t0, $t0, $t8
	andi $t0, $t0, 62
	srl $t0, $t0, 1
	sw $t0, rs
	
	lw $t0, thirdCharacter		#Extracts the rt (bits 13-18) from the 32 bit string
	lw $t8, fourthCharacter
	sll $t0, $t0, 4
	or $t0, $t0, $t8
	andi $t0, $t0, 31
	sw $t0, rt
	
	lw $t0, fifthCharacter		#Extracts the immediatte from the 32 bit string
	lw $t8, sixthCharacter
	lw $t2, seventhCharacter
	lw $t3, lastCharacter
	
	sll $t0, $t0, 12
	sll $t8, $t8, 8
	sll $t2, $t2, 4
	or $t0, $t0, $t8
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
	li $v0, 15		
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $s4, 0
	lw $a0, rt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, intStr
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $s4, 0
	lw $a0, immediate
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, intStr
	syscall
	
	li $v0, 4
	la $a0, paranthese1
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, paranthese1
	la $a2, 1
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $s4, 0
	lw $a0, rs
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, intStr
	syscall
	
	li $v0, 4
	la $a0, paranthese2
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, paranthese2
	la $a2, 1
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
        li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	branchOrAddi:
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	li $v0, 1
	lw $a0, rs
	syscall
	li $s4, 0
	lw $a0, rs
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	
	li $s4, 0
	lw $a0, rt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	lw $t0, opcodeNum
	blt $t0, 4, skip
	bgt $t0, 5, skip
	
	la $t0, immediate		#Converts the Binary immediatte into 2's compliment form
	lb $t8, 0($t0)
	
	sw $t8, immediate
	li $v0, 1
	lw $a0, immediate
	syscall
	li $s4, 0
	lw $a0, immediate
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	skip:
	li $v0, 1
	lw $a0, immediate
	syscall
	li $s4, 0
	lw $a0, immediate
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	RType:
	
	lw $t0, secondCharacter	
	lw $t8, thirdCharacter
	
	sll $t0, $t0, 4			#Extracts the rs (bits 7-11) from the 32 bit string
	or  $t0, $t0, $t8
	andi $t0, $t0, 62
	srl $t0, $t0, 1
	sw $t0, rs
	
	lw $t0, thirdCharacter		#Extracts the rt (bits 12-16) from the 32 bit string
	lw $t8, fourthCharacter
	sll $t0, $t0, 4
	or $t0, $t0, $t8
	andi $t0, $t0, 31
	sw $t0, rt
	
	lw $t0, fifthCharacter		#Extracts the rd (bits 17-21) from the 
	lw $t8 sixthCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t8
	srl $t0, $t0, 3
	sw $t0, rd
	
	lw $t0, sixthCharacter		#Extracts the rd (bits 17-21) from the 
	lw $t8 seventhCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t8
	srl $t0, $t0, 2
	andi $t0, $t0, 31
	sw $t0, shamt
	
	lw $t0, seventhCharacter		#Extracts the function (bits 27 - 32) of the 32 bit string
	lw $t8, lastCharacter
	
	sll $t0, $t0, 4
	or $t0, $t0, $t8
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
	li $v0, 15 			
	move $a0, $t7
	la $a1, functadd
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	
	Sub:
	li $v0, 4
	la $a0, functsub
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functsub
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	And:
	li $v0, 4
	la $a0, functand
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functand
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	Or:
	li $v0, 4
	la $a0, functor
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functor
	la $a2, 3
	syscall
	
	j ThreeRegisters
	
	Nor:
	li $v0, 4
	la $a0, functnor
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functnor
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	Slt:
	li $v0, 4
	la $a0, functslt
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functslt
	la $a2, 4
	syscall
	
	j ThreeRegisters
	
	Sll:
	li $v0, 4
	la $a0, functsll
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functsll
	la $a2, 4
	syscall
	
	j logicals
	
	Srl:
	li $v0, 4
	la $a0, functsrl
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functsrl
	la $a2, 4
	syscall
	
	j logicals
	
	Div:
	li $v0, 4
	la $a0, functdiv
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, functdiv
	la $a2, 4
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rs
	syscall
	
	li $s4, 0
	lw $a0, rs
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall 
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $s4, 0
	lw $a0, rt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	Jr:
	li $v0, 4
	la $a0, functjr
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, functjr
	la $a2, 3
	syscall
	li $v0, 4
	la $a0, dollarSign
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	li $v0, 1
	lw $a0, rs
	syscall
	li $s4, 0
	lw $a0, rs
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	
	
	ThreeRegisters:
	li $v0, 4
	la $a0, dollarSign
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rd
	syscall
	
	li $s4, 0
	lw $a0, rd
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall 
	
	li $v0, 1
	lw $a0, rs
	syscall
	
	li $s4, 0
	lw $a0, rs
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $s4, 0
	lw $a0, rt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	 
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	logicals:
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rd
	syscall
	
	li $s4, 0
	lw $a0, rd
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, dollarSign
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, dollarSign
	la $a2, 1
	syscall
	
	li $v0, 1
	lw $a0, rt
	syscall
	
	li $s4, 0
	lw $a0, rt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 15 			
	move $a0, $t7
	la $a1, space
	la $a2, 2
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	lw $a0, shamt
	syscall
	
	li $s4, 0
	lw $a0, shamt
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
	JType:
	
	lw $t0, secondCharacter		#extract the jump addresss in decimal
	lw $t8, thirdCharacter 
	
	sll $t0, $t0, 4
	or $t0, $t0, $t8
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
	
	lw $t8, opcodeNum
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
	li $v0, 15 			
	move $a0, $t7
	la $a1, leading00
	la $a2, 2
	syscall
	
	lw $a0, hexDigit6
	ble $a0, 9, Print1
	jal PrintHexLetter
	j Next1
	Print1:
	li $v0, 1
	lw $a0, hexDigit6
	syscall
	li $s4, 0
	lw $a0, hexDigit6
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
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
	li $s4, 0
	lw $a0, hexDigit5
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
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
	li $s4, 0
	lw $a0, hexDigit4
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
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
	li $s4, 0
	lw $a0, hexDigit3
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
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
	li $s4, 0
	lw $a0, hexDigit2
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
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
	li $s4, 0
	lw $a0, hexDigit1
	la $a1, intStr
	jal convertInt
	li $v0, 15 			
	move $a0, $t7
	la $a1, intStr
	move $a2, $s4
	syscall
	Next6:
	
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 15
	move $a0, $t7
	la $a1, nl
	li $a2, 2
	syscall
	j start
	
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
	li $v0, 15 			
	move $a0, $t7
	la $a1, A
	la $a2, 1
	syscall  
	jr $ra
	
	PrintB:
	li $v0, 4
	la $a0, B
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, B
	la $a2, 1
	syscall  
	jr $ra
	
	PrintC:
	li $v0, 4
	la $a0, C
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, C
	la $a2, 1
	syscall  
	jr $ra
	
	PrintD:
	li $v0, 4
	la $a0, D
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, D
	la $a2, 1
	syscall 
	jr $ra
	
	PrintE:
	li $v0, 4
	la $a0, E
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, E
	la $a2, 1
	syscall  
	jr $ra
	
	PrintF:
	li $v0, 4
	la $a0, F
	syscall
	li $v0, 15 			
	move $a0, $t7
	la $a1, F
	la $a2, 1
	syscall 
	jr $ra
	
	convertInt:	#converts int to string so that it can be written to a file
 	beq $a0, 0, store0 
	addi $sp, $sp, -4         
	sw   $t0, ($sp)           
	blt $a0, 0, NegativeNum
	j    next0                

	NegativeNum:
	li   $t0, '-'
	add $s4, $s4, 1
	sb   $t0, ($a1)          
	addi $a1, $a1, 1          
	li   $t0, -1
	mul  $a0, $a0, $t0        

	next0:
	li   $t0, -1
	addi $sp, $sp, -4        
	sw   $t0, ($sp)           

	pushAll: 
	blez $a0, next1          
	li   $t0, 10             
	div  $a0, $t0             
	mfhi $t0                  
	mflo $a0                    
	addi $sp, $sp, -4         
	sw   $t0, ($sp)          
	j    pushAll         

	next1:
	lw   $t0, ($sp)           
	addi $sp, $sp, 4          
	bltz $t0, NegativeDigit       
	j    popAll           

	NegativeDigit:
	li   $t0, '0'
	sb   $t0, ($a1)           
	addi $a1, $a1, 1         
	j    next2                

	popAll:	
	bltz $t0, next2          
	addi $t0, $t0, '0'        
	sb   $t0, ($a1)           
	addi $a1, $a1, 1          
	lw   $t0, ($sp)            
	addi $sp, $sp, 4
	add $s4, $s4, 1          
	j    popAll           

	next2:
	sb  $zero, ($a1)
	lw   $t0, ($sp)           
	addi $sp, $sp, 4          
	jr  $ra
	
	
			
	store0: #edge case where zero doesn't work with the subroutine so this was added
	li $t0, '0'
	sb $t0, intStr
	add $s4, $s4, 1
	jr $ra
	
	Exit2:
	
	li $v0, 16
	move $a0, $t7
	syscall
	li $v0, 10
	syscall
	
	
