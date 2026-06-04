Include Macros.inc
Include Irvine32.inc
BUFFER_SIZE = 100000
BUFFER_SIZE1 = 100000

.data
input_word byte 50 DUP (?) ; to input synonym
ant byte 50 DUP (?) ; to input antonym
length_of_input_word byte ? ; size of input string

Synonyms_of_the_word byte 200 DUP (?)
Antonyms_of_the_word byte 200 DUP (?)

buffer BYTE BUFFER_SIZE DUP (?)
buffer1 BYTE BUFFER_SIZE1 DUP (?)

fileHandle HANDLE ?
fileHandle1 HANDLE ?

synonym_file byte "C:\Users\HP\OneDrive\Desktop\synonyms.txt",0
antonym_file byte "C:\Users\HP\OneDrive\Desktop\antonyms.txt",0

count_spaces byte ?
count_spaces1 byte ?

syn_temp byte 300 dup(?) ; to store synonyms temporarily
ant_temp byte 300 dup(?) ; to store antonyms temporarily



.code
main proc
call crlf 
mWrite "|------------------------------------------------|"
call crlf
mWrite "|     PROGRAM TO FIND THE SYNONYMS & ANTONYMS    |"
call crlf
mWrite "|------------------------------------------------|"
call crlf

menu:
call crlf
call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "| Choose an option:                              |"
call crlf
mWrite "| 1. Find Synonyms                               |"
call crlf
mWrite "| 2. Find Antonyms                               |"
call crlf
mWrite "| 3. Exit                                        |"
call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "Enter your choice (1/2/3): "
call readdec
; Check if the choice is a valid number (1, 2, or 3)
cmp al, 1
je valid_choice
cmp al, 2
je valid_choice
cmp al, 3
je valid_choice

; If invalid input, prompt the user again
mWrite "Invalid choice. Please enter 1, 2, or 3."
call crlf
jmp menu

valid_choice:
; Proceed to find synonym, antonym, or exit based on the valid choice
cmp al, 1
je find_synonym
cmp al, 2
je find_antonym
cmp al, 3
je exit_program

; Handle invalid input
mWrite "Invalid choice. Please enter 1, 2, or 3."
call crlf
jmp menu

find_synonym:
   
    mov eax, 0
    mwrite "Enter a Word to search its synonyms: "

    mov ecx, lengthof input_word
    mov edx, offset input_word
    call readstring

    mov length_of_input_word, al
    movzx ecx, al ; loop chla k check krna hy k hr letter valid hy ya nhi

    call check_for_the_word ; ye function check kr k btayega k hr letter valid hy ya nhi

    cmp eax, 1 ; agr hr letter valid hoga to eax ki value 1 hogi, invalid pr 0
    je valid_input ; jump to valid_input agr koi invalid character na ho input men to

    ; agr koi invalid input hy to
    call crlf
    mwrite "The word you entered includes at least one letter that is not from English alphabets."
    call crlf
    mwrite "Your word should include English alphabets eg: (amazing)"
    call crlf
    call crlf
    mwrite "If you want to find another word Synonyms press 1 else press 0 to search a word's Antonyms: "
    call readdec
    cmp al, 1
    je find_synonym
    jmp find_antonym

valid_input:
    mwrite "The length of your entered word is: "
    mov al, length_of_input_word
    call writedec

    movzx ecx, al ; loop counter
    call convert_the_word_into_lowercase ; saary letters ko lowercase men change kerny k liye, +32 add kr k(in UPPERCASE letters)
    call crlf
    call crlf

    ; Open the file for input.
    mov edx, OFFSET synonym_file
    call OpenInputFile
    mov fileHandle, eax

    ; Check for errors.
    cmp eax, INVALID_HANDLE_VALUE ; error opening file?
    jne valid_file ; no: skip
    mWrite <"Cannot open file", 0dh, 0ah>
    jmp quit ; quit synonym and find for antonym file

valid_file:
    ; Read the file into a buffer.
    mov edx, OFFSET buffer ; buffer 1 BYTE array hy
    mov ecx, BUFFER_SIZE
    call ReadFromFile
    jnc check_buffer_size ; no carry mtlb file se buffer men data sahi chla gya
    mWrite "Error reading file. "
    call WriteWindowsMsg
    jmp close_file

check_buffer_size:
    cmp eax, BUFFER_SIZE ; buffer large enough?
    jb buf_size_ok ; yes
    mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
    jmp quit ; and quit

buf_size_ok:
    mov buffer[eax], 0 ; insert null terminator
    mWrite "File size: "
    call WriteDec ; display file size
    call Crlf

    mov esi, 0
    mov edi, 0
yahan:
mov edi,0
mov count_spaces,0

break_into_strings:
mov dl,count_spaces
cmp dl,2
je bahir
mov al,buffer[esi]
cmp al,' '
jne s1
add count_spaces,1
s1:
mov syn_temp[edi],al
inc esi
inc edi
cmp esi,8558 ; File Size
jl break_into_strings
; Here we check if the word was not found
call crlf
mWrite "Could not find the word in the file: "
call writestring
jmp retry_synonym

bahir:
push esi
dec esi
mov ecx,esi
mov esi,0
check1:
mov al,input_word[esi]
cmp al,syn_temp[esi]
jne out2
mov al,syn_temp[esi+1]
cmp al,' '
je out1
inc esi
loop check1

out1:
add esi,2
mov edi,0
copy1:
mov al,syn_temp[esi]
mov Synonyms_of_the_word[edi],al
mov al,syn_temp[esi+1]
cmp al,' '
je print1
inc esi
inc edi
jmp copy1

out2:
pop esi
jmp yahan

retry_synonym:
mWrite "Enter a new word to search for its synonyms or press 0 to exit: "
call readdec
cmp al, 0
je quit
jmp find_synonym




    print1:
        call crlf
       call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "|       SYNONYMS OF THE WORD ARE:                |"
        mov Synonyms_of_the_word[edi], 0
        mov edx, offset Synonyms_of_the_word
        call crlf
       mWrite "|    " 
       call writestring 
       mWrite "                                     |"
        pop esi

    close_file:
        mov eax, fileHandle
        call CloseFile
        jmp f1

quit:
    ;close_file:
    mov eax, fileHandle
    call CloseFile
f1:
    jmp menu




; *********** to find antonym logic, (same as synonym)


find_antonym:
call crlf
call crlf
mov esi,0
mov edi,0
mov ecx,0
mov eax,0
call crlf
mWrite "Enter a word to search its antonyms: "

mov ecx,lengthof ant
mov edx,offset ant
call readstring
mwrite "Length of your entered word is: "
call writedec
call crlf
call crlf

; Open the file for input.
mov edx,OFFSET antonym_file
call OpenInputFile
mov fileHandle1,eax

; Check for errors.
cmp eax,INVALID_HANDLE_VALUE ; error opening file?
jne file_ok1 ; no: skip
mWrite <"Cannot open file",0dh,0ah>
jmp exit_program ; and quit

file_ok1:
; Read the file into a buffer.
mov edx,OFFSET buffer1
mov ecx,BUFFER_SIZE1
call ReadFromFile
jnc check_buffer_size1 ; error reading?
mWrite "Error reading file. " ; yes: show error message
call WriteWindowsMsg
jmp close_file1

check_buffer_size1:
cmp eax,BUFFER_SIZE1 ; buffer large enough?
jb buf_size_ok1 ; yes
mWrite <"Error: Buffer too small for the file",0dh,0ah>
jmp exit_program ; and quit

buf_size_ok1:
mov buffer1[eax],0 ; insert null terminator
mWrite "File size: "
call WriteDec ; display file size
call Crlf

mov esi,0
mov edi,0
yahan1:
mov edi,0
mov count_spaces1,0

break_into_strings1:
mov dl,count_spaces1
cmp dl,2
je bahir1
mov al,buffer1[esi]
cmp al,' '
jne s11
add count_spaces1,1
s11:
mov ant_temp[edi],al
inc esi
inc edi
cmp esi,4000 ; File Size
jl break_into_strings1
; Here we check if the word was not found
call crlf
mWrite "Could not find the word in the file: "
call writestring
jmp retry_antonym

bahir1:
push esi
dec esi
mov ecx,esi
mov esi,0
check11:
mov al,ant[esi]
cmp al,ant_temp[esi]
jne out21
mov al,ant_temp[esi+1]
cmp al,' '
je out11
inc esi
loop check11

out11:
add esi,2
mov edi,0
copy11:
mov al,ant_temp[esi]
mov Antonyms_of_the_word[edi],al
mov al,ant_temp[esi+1]
cmp al,' '
je print11
inc esi
inc edi
jmp copy11

out21:
pop esi
jmp yahan1

retry_antonym:
mWrite "Enter a new word to search for its antonyms or press 0 to exit: "
call readdec
cmp al, 0
je quit
jmp find_antonym

print11:
 
        call crlf
       call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "|       ANTONYMS OF THE WORD ARE:                |"
        mov Antonyms_of_the_word[edi], 0
        mov edx, offset Antonyms_of_the_word
        call crlf
       mWrite "|    " 
       call writestring 
       mWrite "                                     |"
pop esi

close_file1:
mov eax,fileHandle1
call CloseFile
jmp menu

exit_program:
call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "|     THANK YOU FOR USING THIS PROGRAM!         |"
call crlf
mWrite "|------------------------------------------------|"
call crlf
mWrite "|   COAL PROJECT BY IBAD ZAMIL AND OWAIS        |"
call crlf
mWrite "|------------------------------------------------|"
call crlf
exit


check_for_the_word proc

push ebp
mov ebp,esp
mov esi,0

check_letter:
; [65,90] and [97,122] valid

cmp input_word[esi],'A' ; ascii 65  
jl ENDD ; agr ascii 65 se kam ho, yani invalid to endd krdy
cmp input_word[esi],'z' ; ascii 122  
jg ENDD ; agr ascii 122 se zyada ho, yani invalid to endd krdy
cmp input_word[esi],'Z' ; ascii 90
jg l2 ; x
jmp l3
l2:
cmp input_word[esi],'a' ; ascii 97  
jl ENDD ; agr ascii 97 se kam ho, yani invalid to endd krdy
l3:
inc esi
loop check_letter
pop ebp
mov eax,1 ; at the end agr saary character valid hen to eax 1 krdy
ret

ENDD:

pop ebp
mov eax,0 ; agr koi 1 character bhi invalid hy to eax 0 krdy and return from function
ret
check_for_the_word endp

convert_the_word_into_lowercase proc

push ebp
mov ebp,esp
mov esi,0

convert1:
cmp input_word[esi],'Z' ; ascii 90
jle c1 ; agr uppercase character ho to add 32
inc esi
loop convert1

pop ebp
ret
c1:
mov al,input_word[esi]
add al,32
mov input_word[esi],al ; add 32 and replace
inc esi
loop convert1

pop ebp
ret
convert_the_word_into_lowercase endp
main endp
end main