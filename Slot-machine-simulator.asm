; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt 

  
ConvertDecimal MACRO  decimal, printableDecimal
	mov al,decimal
	xor ah, ah 
	mov cl, 10 
	div cl 
	add ax, 3030h
	mov printableDecimal,ax
	
ENDM ConvertDecimal  
Print MACRO row, column, color 
   push ax
   push bx
   push cx
   push dx   
   
   mov Ah, 02h
   mov Bh, 0h
   mov Dh, row
   mov Dl, column
   INT 10h 
   mov Ah, 09
   mov Al, ' '
   mov Bl, color
   mov Cx, 1h
   INT 10h   
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM Print     

    

 

PrintText Macro row , column , text
   push ax
   push bx
   push cx
   push dx   
   
   mov ah,2
   mov bh,0
   mov dl,column
   mov dh,row
   int 10h
   mov ah, 9
   mov dx, offset text
   int 21h
   
   pop dx
   pop cx
   pop bx
   pop ax
ENDM PrintText
                 

ClearScreen MACRO
        
    mov ax, 0600h  ;al=0 => Clear
    mov bh, 07     ;bh=07 => Normal Attributes              
    mov cx, 0      ;From (cl=column, ch=row)
    mov dl, 80     ;To dl=column
    mov dh, 25     ;To dh=row
    int 10h    
    
    ;Move cursor to the beginning of the screen 
    mov ax, 0
    mov ah, 2
    mov dx, 0
    int 10h   
    
ENDM ClearScreen
;=========================================
.MODEL SMALL
.STACK 64    
.DATA
StartScreen			 db '              ====================================================',0ah,0dh
	db '             ||                                                  ||',0ah,0dh                                        
	db '             ||         >>     Slot machine Game   <<            ||',0ah,0dh
	db '             ||__________________________________________________||',0ah,0dh
	db '             ||               TERMS AND CONDITIONS               ||',0ah,0dh          
	db '             ||                                                  ||',0ah,0dh          
	db '             ||    The states in India are entitled to formulate ||',0ah,0dh
	db '             ||         laws for gambling activities within      ||',0ah,0dh
	db '             ||               their respective states.           ||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||  The Public Gambling Act of 1867 is a central law||',0ah,0dh
	db '             ||       that prohibits running or being in charge  ||',0ah,0dh
	db '             ||             of a public gambling house.          ||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||                    Please                        ||',0ah,0dh
	db '             ||  Agree the Terms and Conditions and start playing||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||                                                  ||',0ah,0dh
	db '             ||            Press Enter to start playing          ||',0ah,0dh 
	db '             ||            Press ESC to Exit                     ||',0ah,0dh
	db '              ====================================================',0ah,0dh
	db '$',0ah,0dh
GameoverScreen	 db '             ___________________',0ah,0dh
	db '             ||                   ||',0ah,0dh                                        
	db '             ||  >> GAMEOVER <<   ||',0ah,0dh
   db '             ||  >> GAMEOVER <<   ||',0ah,0dh
	db '             ||___________________||',0ah,0dh	
	db '$',0ah,0dh
PlayerName	       db      15, ?,  15 dup('$')
AskPlayerName	       db      ' Enter your name: ','$'
question1	       db      'Press ENTER to play Once again','$'
question2          db    'press ESC to EXIT from game','$'
;amount	       db      5, ?,  5 dup('$')
amount db 00h,00h
betvalues db 'Select Option: 1 for Rs300   2 for Rs500  3 for Rs700','$'
AskPlayeramount	       db      ' Enter the Bet Amount Option: ','$'

bettext        db   'Wallet: ','$'
slot2         db 'BMW','$'
slot3   db 'TNT','$'
heading db    ' WELCOME TO SLOT MACHINE !!!','$'
  apple db 'HP','$'
 mango db 'AMD','$'
 pomengrate db 'MI','$'
 banana db 'JBL','$'
 cherry db 'MRF','$'
 blueberry db 'IBM','$'
 orange db 'HTC','$'
 pineapple db 'BMW','$'
 grapes db 'ITC','$'
 TNT db 'TNT','$' 
 msj2   db 13,10,'Number has been converted',13,10,13,10,'$'
 slot db 32 
 ar1 dw 0,0
 choice db 0,0,0
;==================================================

.CODE   
MAIN    PROC FAR  
    mov ax, @DATA
    mov ds, ax  
    
  ClearScreen
  call StartMenu       
  ClearScreen  
  	 	


;clearscreen
  call DrawInterface
 
   hlt
MAIN        ENDP 

;==================================================
   startMenu Proc
    
	push ax
	push bx
	push cx
	push dx
	push ds 
            
       
          
	PrintText 1,1,StartScreen	

	;hide curser
    mov ah,01h
	  ;If bit 5 of CH is set, that often means "Hide cursor". So CX=2607h is an invisible cursor.
	mov cx,2607h 
	int 10h

	checkforinput:
	mov AH,0            		 
	int 16H 
	cmp al,13              		     ;Enter to Start Game   
	JE StartTheGame
	cmp ah,1H                 		 ;Esc to exit the game
	JE ExitMenu
	JNE checkforinput

	ExitMenu:
	mov ah,4CH
	int 21H
	
	StartTheGame:
	                           
    ClearScreen 		
  ; call date     
	LoopOnName:
	PrintText 8,8,AskPlayerName
	;Receive player name from the user
	mov ah, 0Ah
	mov dx, offset PlayerName         
	int 21h
   
   
   
	cmp PlayerName[1], 0	;Check that input is not empty
	jz LoopOnName

	;Checks on the first letter to ensure that it's either a capital letter or a small letter
	cmp PlayerName[2], 40h
	jbe LoopOnName
	cmp PlayerName[2], 7Bh
	jae LoopOnName
	cmp PlayerName[2], 60h
	jbe	anotherCheck
	ja ExitLoopOnName
	anotherCheck:
	cmp PlayerName[2], 5Ah
	ja	LoopOnName

	ExitLoopOnName: 
noo:	PrintText 13,12,betvalues
	PrintText 16,8,AskPlayeramount 
    
    mov ah, 01h
	;cmp amount         
	int 21h
	sub al,30h
	cmp al,1h
	mov bl,3h
	jz goo
	cmp al,2h
	mov bl,5h
	jz goo
	cmp al,3h
	mov bl,7h
	jz goo
	
	jmp noo
	
	
	  
	
	goo:
	lea si,amount
	;add si,1 
	mov [si],bl
	;call string2number
 ;   call aaaa
    ; mov ax,50               
mov dh, 10
mov dl, 10
mov bh, 0
mov ah, 2
int 10h
lea si,amount
;add si,1 
mov dl,[si]
     ;printtext 10,10,amount[0]
MOV Ah,02h
int 21h

	ClearScreen        
	pop ds
	pop dx
	pop cx
	pop bx
	pop ax 
	RET
StartMenu ENDP     
   
;==================================================
 ;CONVERT STRING TO NUMBER IN BX.
;proc string2number         
;MAKE SI TO POINT TO THE LEAST SIGNIFICANT DIGIT.
;  mov  si, offset amount + 1 ;<================================ YOU CHANGE THIS VARIABLE.
;  mov  cl, [ si ] ;NUMBER OF CHARACTERS ENTERED.                                         
;  mov  ch, 0 ;CLEAR CH, NOW CX==CL.
;  add  si, cx ;NOW SI POINTS TO LEAST SIGNIFICANT DIGIT.
;CONVERT STRING.
 ; mov  bx, 0
;  mov  bp, 1 ;MULTIPLE OF 10 TO MULTIPLY EVERY DIGIT.
;repeat:         
;CONVERT CHARACTER.                    
 ; mov  al, [ si ] ;CHARACTER TO PROCESS.
 ; sub  al, 48 ;CONVERT ASCII CHARACTER TO DIGIT.
 ; mov  ah, 0 ;CLEAR AH, NOW AX==AL.
 ; mul  bp ;AX*BP = DX:AX.
 ; add  bx,ax ;ADD RESULT TO BX. 
;INCREASE MULTIPLE OF 10 (1, 10, 100...).
;  mov  ax, bp
 ; mov  bp, 10
 ; mul  bp ;AX*10 = DX:AX.
 ; mov  bp, ax ;NEW MULTIPLE OF 10.  
;CHECK IF WE HAVE FINISHED.
  ;dec  si ;NEXT DIGIT TO PROCESS.
 ; loop repeat ;COUNTER CX-1, IF NOT ZERO, REPEAT.
  
;proc aaaa
;;  ;lea si,ar1
 ; lea si,amount
 ; mov [si],bx
 ;; printtext 0,0,ar1
 ; ;inc si
 ; mov si,1  
 
  ; mov cx, 9
   ; #wrong position l1:
 ;   lea si, ar1
   ; #redundant mov bl, arr[si]
;l1:
   ; mov dl, [si]
   ; mov ah, 2  ; #not sure if this could be moved in front of the loop, check if syscall clobbers ah
   ; int 21h
   ; inc si
   ; loop l1
 
 
 
 
 
 
  
  
;  MOV AX,bx
;mov cx,0 
;mov dx,0 
    
;LABEL1: 
;        CMP AX,0 
  ;      JE  PRINT1       
 ;       MOV BX,10         
   ;     DIV BX                   
       ; PUSH DX               
    ;    INC CX               
     ;   XOR DX,DX 
        ;JMP LABEL1 
;print1:    
 ;       CMP CX,0 
  ;      JE  EXIT1
   ;     POP DX
    ;    ADD DX,48
     ;   MOV AH,02H 
     ;   INT 21H 
     ;   DEC CX
      ;  inc si 
       ; JMP print1
        
; EXIT1: 
   
 ; ret     
  ;aaaa endp
;string2number endp  

;==================================================
 
 Gameover Proc 
      
 PrintText 1, 30, PlayerName
 
 PrintText 5 , 10 ,bettext
 ;PrintText 5 , 17  ,amount
 mov dh, 5
mov dl, 17
mov bh, 0
mov ah, 2
int 10h
lea si,amount
;add si,1 
mov dl,[si]
add dl,30h
     ;printtext 10,10,amount[0]
MOV Ah,02h
int 21h
mov dh, 5
mov dl, 18
mov bh, 0
mov ah, 2
int 10h
;mov dl,02h
mov dl,30h
int 21h
mov dh, 5
mov dl, 19
mov bh, 0
mov ah, 2
int 10h
;mov dl,02h
mov dl,30h
int 21h
 PrintText 10,2 , GameOverScreen
    mov ah,4CH
    int 21H
     
    ret
 Gameover ENDP      
 
;==================================================

RANDGEN1:   
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   lea si,choice
   mov [si],dl
   cmp dl,0
   jz zero
    cmp dl,1
   jz one
    cmp dl,2
   jz two
    cmp dl,3
   jz three
    cmp dl,4
   jz four
    cmp dl,5
   jz five
    cmp dl,6
   jz six
    cmp dl,7
   jz seven
    cmp dl,8
   jz eight
    cmp dl,9
   jz nine
   
   
          
 zero:   
    PrintText 11 , 8 ,apple  
   ret       
one:
   PrintText 11 , 8 , banana 
   ret
two:
   PrintText 11 , 8 , cherry
   ret
three:
    PrintText 11 , 8 , blueberry
   ret
four:
  PrintText 11 , 8 , pomengrate
   ret
five:
   PrintText 11 , 8 , orange
   ret
six:
   PrintText 11 , 8 , grapes 
   ret
seven:
  PrintText 11 , 8 , pineapple
   ret
eight:
  PrintText 11 , 8 , mango
   ret
nine:
   PrintText 11 , 8 , TNT
   
   
   ret
 
RANDGEN2:   
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   lea si,choice
   add si,1
   mov [si],dl
   cmp dl,0
   jz zero1
    cmp dl,1
   jz one1
    cmp dl,2
   jz two1
    cmp dl,3
   jz three1
    cmp dl,4
   jz four1
    cmp dl,5
   jz five1
    cmp dl,6
   jz six1
    cmp dl,7
   jz seven1
    cmp dl,8
   jz eight1
    cmp dl,9
   jz nine1
   
          
 zero1:   
    PrintText 11 , 16 ,apple  
   ret       
one1:
   PrintText 11 , 16 , banana 
   ret
two1:
   PrintText 11 , 16, cherry
   ret
three1:
    PrintText 11 ,16 , blueberry
   ret
four1:
  PrintText 11 , 16 , pomengrate
   ret
five1:
   PrintText 11 , 16 , orange
   ret
six1:
   PrintText 11 , 16, grapes 
   ret
seven1:
  PrintText 11 , 16, pineapple
   ret
eight1:
  PrintText 11 , 16 , mango
   ret
nine1:
   PrintText 11 , 16 , TNT
   ret 
 
 
 
 RANDGEN3:   
   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9
   lea si,choice
   add si,2
   mov [si],dl
   cmp dl,0
   jz zero2
    cmp dl,1
   jz one2
    cmp dl,2
   jz two2
    cmp dl,3
   jz three2
    cmp dl,4
   jz four2
    cmp dl,5
   jz five2
    cmp dl,6
   jz six2
    cmp dl,7
   jz seven2
    cmp dl,8
   jz eight2
    cmp dl,9
   jz nine2
   
          
 zero2:   
    PrintText 11 , 23 ,apple  
   ret       
one2:
   PrintText 11 , 23 , banana 
   ret
two2:
   PrintText 11 , 23 , cherry
   ret
three2:
    PrintText 11 , 23 , blueberry
   ret
four2:
  PrintText 11 , 23 , pomengrate
   ret
five2:
   PrintText 11 , 23 , orange
   ret
six2:
   PrintText 11 , 23 , grapes 
   ret
seven2:
  PrintText 11 , 23 , pineapple
   ret
eight2:
  PrintText 11 , 23 , mango
   ret
nine2:
   PrintText 11 , 23 , TNT
   ret  
sec:
call RANDGEN1     
CALL RANDGEN2
CALL RANDGEN3
lea si,amount
sub [si],1
mov al,0h
lea si,choice
mov dl,[si]
mov dh,[si+1]
mov bl,[si+2]

cmp dl,dh
jnz zxc
add al,1
zxc:
cmp dl,bl
jnz zxv
add al,1
zxv:
cmp dh,bl
jnz zxb
add al,1
zxb:
cmp al,0
jz asd
cmp al,3
jz asd3 

lea si,amount
add [si],1


asd3:
lea si,amount
add [si],2
asd:

ret





DrawInterface	Proc
	
	mov ah,00 ;set mode
    mov al,13h ;mode=13(CGA High resolution)
    int 10h
	;clearscreen
	push ax
	push cx
	push dx
	
	;Go to the line beginning
	
	  
	mov al, 0
	mov cx, 40
	DrawLineloop1:
		Print 1, al, 30h
		Print 0, al, 70h
		inc al
	loop DrawLineloop1
	
	mov al,' '
	mov PlayerName[0],al
	mov PlayerName[1],al  
	PrintText 1 , 10 , PlayerName
	PrintText 0 , 7 , heading
	PrintText 1 , 25 ,bettext
mov dh, 1
mov dl, 32
mov bh, 0
mov ah, 2
int 10h
lea si,amount
;add si,1 
mov dl,[si]
add dl,30h
     ;printtext 10,10,amount[0]
MOV Ah,02h
int 21h
mov dh, 1
mov dl, 33
mov bh, 0
mov ah, 2
int 10h
;mov dl,02h
mov dl,30h
int 21h
mov dh, 1
mov dl, 34
mov bh, 0
mov ah, 2
int 10h
;mov dl,02h
mov dl,30h
int 21h

	
	;mov al,amount[0]  
	;mov ah,00h
	;mov
	;PrintText 1 , 32,amount 		 
	 ;box 1 top vert line
mov cx,60
mov dx,85
hseLWV01: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseLWV01

;box 1 bottom vert line
mov cx,95
mov dx,85
hseLWV03: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseLWV03

;box 2 top vert line
mov cx,121
mov dx,85
hseLWV1: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseLWV1        

;box 2 bottom vert line
mov cx,156
mov dx,85
hseLWV3: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseLWV3

;box 3 top vert line
mov cx,180
mov dx,85
hseRWV1: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseRWV1         

;box 3 bottom vert line
mov cx,215
mov dx,85
hseRWV3: mov ah,0ch
mov al,02h
int 10h
inc dx
cmp dx,105
jnz hseRWV3  

; box horz top line 
mov cx,60
mov dx,85
hseWH0: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,95
jnz hseWH0

mov cx,121
mov dx,85
hseWH1: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,156
jnz hseWH1

mov cx,180
mov dx,85
hseWH1b: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,215
jnz hseWH1b   

; box horz bottom line 
mov cx,60
mov dx,105
hseWH03: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,96
jnz hseWH03 

mov cx,121
mov dx,105
hseWH3: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,157
jnz hseWH3 

mov cx,180
mov dx,105
hseWH3b: mov ah,0ch
mov al,02h
int 10h
inc cx
cmp cx,216
jnz hseWH3b
	
  call sec
	;PrintText 11 , 8 , slot1
	;PrintText 11 , 16 , slot1
	;PrintText 11 , 23 , slot3	

PrintText 20 , 8 ,question1
PrintText 22 , 8 ,question2
	checkforinput1:
	mov AH,0            		 
	int 16H 

	cmp al,13    
	;clearscreen          		     ;Enter to Start Game   
	JE DrawInterface

	cmp ah,1H                 		 ;Esc to exit the game
	JE ExitMenu1
	JNE checkforinput1

	ExitMenu1: 
    JE Gameover
	
	
	
	pop dx
	pop cx
	pop ax
	RET
DrawInterface	ENDP

;==================================================
END MAIN    





