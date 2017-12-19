# Authors: Dimitris Moraitidis, 3100240
#	   Rafaella G. Gazepidou, 3140262
# Date: 20/12/2017
# A linked list implementation, sorted with the bubble sort algorithm. 


.data
	menuHeader: .asciiz "Choose one of the following options (or '0' to exit) and hit 'Enter':\n"
	menuLine: .asciiz "---------------------------------------------------------------------\n"
	menu1: .asciiz "1. Insert node to the list\n"
	menu2: .asciiz "2. Delete node from the list\n"
	menu3: .asciiz "3. Print list (ascending order)\n"
	menu4: .asciiz "4. Print list (descending order)\n"
	
	messageInsert: .asciiz "\nPlease enter an Integer, which will then be inserted as a node in the list accordingly:\n"
	messageInsertCompleted1: .asciiz "\nInteger "
	messageInsertCompleted2: .asciiz " was successfully inserted in the list!"
	messageInsertCompleted3: .asciiz "\nNumber of added nodes: "
	messageDelete: .asciiz "\nSelect the number of node (shown in ascending order) that you want to delete:\n"
	messagePrintAscending: .asciiz "\nCurrent List in Ascendng order:\n"
	messagePrintDescending: .asciiz "\n \n"
	messageWrongInput: .asciiz "\nWrong Input. Please try again!\n\n"
	messageExit: .asciiz "\nApplication will now terminate! Thanks for using it!\n"
	messageSort: .asciiz "\nList was sorted!\n"
	
	newLine: .asciiz "\n\n"
	emptySpace: .asciiz " "
	swapped: .asciiz "\nSwapped!\n"
	runn: .asciiz "\nRun:\n"
	valueOfS7: .asciiz "\nValue of $s7: \n"
	
	base: .word 0
	
.text

main:
	#li $v0, 1
	#la $a0, base
	#syscall

	addi $s0, $zero, 0                    #counts the nodes added to the list
	addi $s7, $zero, 0                    #pointer of allocated space
	
	printMenu:
		li $v0, 4
		la $a0, menuHeader
		syscall
		
		li $v0, 4
		la $a0, menuLine
		syscall
		
		li $v0, 4
		la $a0, menu1
		syscall
		
		li $v0, 4
		la $a0, menu2
		syscall
		
		li $v0, 4
		la $a0, menu3
		syscall
		
		li $v0, 4
		la $a0, menu4
		syscall
	
	getInputFromUser:
		li $v0, 5
		syscall
		move $t0, $v0                        #t0 contains user's choice
		
		beqz $t0, exit                       #if choice is '0' then exit application
		
		beq $t0, 1, caseInsert
		beq $t0, 2, caseDelete
		beq $t0, 3, casePrintAscending
		beq $t0, 4, casePrintDescending
		j caseWrongInput                     #if no valid option is detected,
						     #then print appropriate message and reprint the menu

	caseInsert:
		li $v0, 4
		la $a0, messageInsert
		syscall
		
		bnez $s0, nextNode
		
		firstNode:
			li $a0, 8
			li $v0, 9                            #allocate 8 bytes for int value and pointer
			syscall      
			                       
			sw $v0, base     		     #base = address of first allocated byte
			move $t5, $v0
		
			#li $v0, 1
			#move $a0, $t5
			#syscall
			
			#li $v0, 1
			#la $a0, base
			#syscall
			
			li $v0, 5                            #get Integer inputted by user, stored in base(0)
			syscall
			sw $v0, base($s7)  
		
			addi $s7, $s7, 4
			sw $zero, base($s7)
			
			j printResult
			
		nextNode:
			li $v0, 5                            #get Integer inputted by user, stored in base(+8)
			syscall
			addi $s7, $s7, 4
			sw $v0, base($s7) 
			
			addi $s7, $s7, 4
			sw $zero, base($s7)
			
			j printResult
		
		printResult:
			li $v0, 4
			la $a0, messageInsertCompleted1
			syscall
			
			li $v0, 1
			addi $s7, $s7, -4
			lw $a0, base($s7)
			syscall
			
			li $v0, 4
			la $a0, messageInsertCompleted2
			syscall
			
			addi $s7, $s7, 4
			addi $s0, $s0, 1
			
			li $v0, 4
			la $a0, messageInsertCompleted3
			syscall
			
			li $v0, 1
			move $a0, $s0
			syscall
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			#li $v0, 4
			#la $a0, valueOfS7
			#syscall
			#li $v0, 1
			#move $a0, $s7
			#syscall
			
			bgt $s0, 1, sort
			j printMenu
		
	caseDelete:
		j casePrintAscending
		continueWithDeletion:
		move $s6, $s7                         #save current position of base pointer
		addi $s5, $zero, 1                    #counter for list nodes
		
		li $v0, 4
		la $a0, messageDelete
		syscall
		
		li $v0, 5                             #get user's choice of the to-be-delted node
		syscall				      #1 = first node in ascending order, 2 = 2nd ... etc
		move $t0, $v0
		
		addi $s7, $zero, 8
		beq $t0, 1, if_1st
		if_1st:
			beq $s5, $s0, end_of_1st_if 
			
			lw $t1, base($s7)
			addi $s7, $s7, -8
			sw $t1, base($s7)
			addi $s7, $s7, 16
			addi $s5, $s5, 1
			j if_1st
			end_of_1st_if:
				addi $s0, $s0, -1
				move $s7, $s6                    #restore pointer value
				
				la $t1, base
				addi $t1, $t1, 8
				sw $t1, base
				
				li $v0, 1
				move $a0, $t1
				syscall
				
				
				li $v0, 1
				la $a0, base
				syscall
				
				j printMenu
		if_last:
		
		if_any_other:
			
		
		
		j printMenu
		
	casePrintAscending:
		li $v0, 4
		la $a0, messagePrintAscending
		syscall
		
		move $s6, $s7                         #save current position of base pointer
		addi $s5, $zero, 0                    #counter for list nodes
		addi $s7, $zero, 0
		printLoop:
			beq $s5, $s0, exitPrintLoop
			li $v0, 1
			lw $a0, base($s7)
			syscall
			
			li $v0, 4
			la $a0, emptySpace
			syscall
			
			addi $s7, $s7, 8
			addi $s5, $s5, 1
			j printLoop
			
		exitPrintLoop:
			
			li $v0, 4
			la $a0, newLine
			syscall
			
			move $s7, $s6                      #restore value of base pointer
			beq $t0, 2, continueWithDeletion
			j printMenu
		
		
	casePrintDescending:
		li $v0, 4
		la $a0, messagePrintDescending
		syscall
		
		
		j printMenu
	
	caseWrongInput:
		li $v0, 4
		la $a0, messageWrongInput
		syscall
		
		j printMenu
	
	
	
	
	sort:
		move $s6, $s7                  #save current position of base pointer
		nextRun:
		
		#li $v0, 4
		#la $a0, runn
		#syscall 
		
		addi $s7, $zero, 0             #set pointer value to the beginning of the index
		
		addi $s5, $zero, 1             #counter for list nodes
		addi $s4, $zero, 0             #counter for swaps performed for each run
		
		loop:
			beq $s5, $s0, exitLoop
			lw $t1, base($s7)
			addi $s7, $s7, 8
			lw $t2, base($s7)
			
			addi $s5, $s5, 1
			
			beqz $t2, notSwap
			bge $t1, $t2, swap
			
			notSwap:
				#addi $s7, $s7, 8
				j loop
			swap:
				addi $s4, $s4, 1        #increment swap counter by one
				
				addi $s7, $s7, -8
				sw $t2, base($s7)
				addi $s7, $s7, 8
				sw $t1, base($s7)
				
				#li $v0, 4
				#la $a0, swapped
				#syscall

				
				#addi $s7, $s7, 8
				j loop	
				
		exitLoop:
			beqz $s4, sortResult
			addi $s4, $zero, 0
			j nextRun
	
		sortResult:
			li $v0, 4
			la $a0, messageSort
			syscall
			
			move $s7, $s6                      #restore value of base pointer
			j printMenu
			
				
	
	exit:
		li $v0, 4
		la $a0, messageExit
		syscall
		li $v0, 10
		syscall
