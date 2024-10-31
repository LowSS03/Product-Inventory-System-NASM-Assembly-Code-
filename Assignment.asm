section .data
; (*) COLOUR
%define whiteColour "[0m"
%define redColour "[31m"
%define yellowColour "[33m"
%define greenColour "[32m"
%define cyanColour "[1;96m"
%define alertColour "[1;31m"
%define blueColour "[1;94m"
%define borderColour "[38;2;255;170;180m" 
%define contentColour "[38;2;255;0;128m"
%define promptColour "[38;2;238;75;247m" 
    reset      db 0x1B, whiteColour, 0    ; Reset all formatting
    red        db 0x1B, redColour, 0   ; ANSI escape code for red text
    yellow     db 0x1B, yellowColour, 0   ; ANSI escape code for yellow text
    green      db 0x1B, greenColour, 0   ; ANSI escape code for green text
    blink      db 0x1B, '[5m'     ; Blink effect - Changed from bold to blink                                           

; (*) LOGIN
 loginPanel db 27, borderColour, ".-------------------------------------------------------------------------------------------------.",10, \
                                 "| .---------------------------------------------------------------------------------------------. |",10, \
                                 "| |     ", 27, contentColour, " _____              _   _____               _              _                _       ", 27, borderColour, "    | |",10, \
                                 "| |     ", 27, contentColour, "|  ___| __ ___  ___| |_|_   _| __ __ _  ___| | __         | |    ___   __ _(_)_ __  ", 27, borderColour, "    | |",10, \
                                 "| |     ", 27, contentColour, "| |_ | '__/ _ \/ __| '_ \| || '__/ _` |/ __| |/ /         | |   / _ \ / _` | | '_ \ ", 27, borderColour, "    | |",10, \
                                 "| |     ", 27, contentColour, "|  _|| | |  __/\__ \ | | | || | | (_| | (__|   <          | |__| (_) | (_| | | | | |", 27, borderColour, "    | |",10, \
                                 "| |     ", 27, contentColour, "|_|  |_|  \___||___/_| |_|_||_|  \____|\___|_|\_\         |_____\___/ \__, |_|_| |_|", 27, borderColour, "    | |",10, \
                                 "| |     ", 27, contentColour, "                                                                      |___/         ", 27, borderColour, "    | |",10, \
                                 "| |_____________________________________________________________________________________________| |",10, \
                                 "|_________________________________________________________________________________________________|",10
    loginPanel_len equ $ - loginPanel

    ; Store the encoded versions directly
    presetUsername db "DgplqFvoow", 0    ; Encoded version of "AdminCsllt"
    presetPassword db "FvoowSdvvzrug", 0 ; Encoded version of "CslltPassword"

    inputUsername db  27, promptColour, "👥 Username: ", 27 , whiteColour, 0
    inputUsernameLen equ $ - inputUsername

    inputPassword db 27, promptColour, "🔑 Password: ", 27, whiteColour, 0
    inputPasswordLen equ $ - inputPassword

    loginFail db 27, redColour, "⚠️ Login Failed. Please Try Again.", 27, promptColour, 0
    loginFailLen equ $ - loginFail

    loginSuccessMsg db 27, cyanColour, "🎉 Login SuccessFul", 27, promptColour, 0
    loginSuccessMsgLen equ $ - loginSuccessMsg

    username_fail db 27, redColour, "❌ Invalid Username. Please Try Again.", 27, promptColour, 0
    username_fail_len equ $ - username_fail

    password_fail db 27, redColour, "❌ Invalid Password. Please Try Again.", 27, promptColour, 0
    password_fail_len equ $ - password_fail

    ICANON      equ 0x0002   
    ECHO        equ 0x0008   
    TCGETS      equ 0x5401   
    TCSETS      equ 0x5402   
    STDIN       equ 0   
                  
; (0) MAIN
    mainChoice db 27 , borderColour, ".------------------------------------------------------------------------------------------------------.",10, \
                                     "| .--------------------------------------------------------------------------------------------------. |",10, \
                                     "| | ", 27, contentColour, " _____              _   _____               _      ___                      _                   ", 27, borderColour, " | |",10, \
                                     "| | ", 27, contentColour, "|  ___| __ ___  ___| |_|_   _| __ __ _  ___| | __ |_ _|_ ____   _____ _ __ | |_ ___  _ __ _   _ ", 27, borderColour, " | |",10, \
                                     "| | ", 27, contentColour, "| |_ | '__/ _ \/ __| '_ \| || '__/ _` |/ __| |/ /  | || '_ \ \ / / _ \ '_ \| __/ _ \| '__| | | |", 27, borderColour, " | |",10, \
                                     "| | ", 27, contentColour, "|  _|| | |  __/\__ \ | | | || | | (_| | (__|   <   | || | | \ V /  __/ | | | || (_) | |  | |_| |", 27, borderColour, " | |",10, \
                                     "| | ", 27, contentColour, "|_|  |_|  \___||___/_| |_|_||_|  \____|\___|_|\_\ |___|_| |_|\_/ \___|_| |_|\__\___/|_|   \__, |", 27, borderColour, " | |",10, \
                                     "| | ", 27, contentColour, "                                                                                          |___/ ", 27, borderColour, " | |",10, \
                                     "| |__________________________________________________________________________________________________| |",10, \
                                     "|______________________________________________________________________________________________________|",10, \
                                     "|  ", 27, contentColour, "[1] 📋 Display All                                                                                  ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[2] 🔍 Search Product                                                                               ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[3] 📝 Add Product                                                                                  ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[4] ♻️ Edit Inventory                                                                               ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[5] 🗑️ Delete Product                                                                               ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[6] 📊 Generate CSV Report                                                                          ", 27, borderColour, "|",10, \
                                     "|  ", 27, contentColour, "[0] 🚪 Exit                                                                                         ", 27, borderColour, "|",10, \
                                     "|______________________________________________________________________________________________________|",10, \
                   27, promptColour, "Enter Your Choice ➤ ", 27, whiteColour
    mainChoiceLen equ $ - mainChoice

    InvalidInputMsg db 27, redColour, "⚠️ Error: Invalid Input. Please Enter A Valid Input.", 27, promptColour, 10
    InvalidInputMsgLen equ $ - InvalidInputMsg

; (1) DISPLAY
    displayDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                      "|                                      📋  Display Product  📋                                         |",10,\
                                      "+------------------------------------------------------------------------------------------------------+",10
    displayDividerLen equ $ - displayDivider
    
    EOFMsg db " ", 10, \
              27, whiteColour, "📄 End Of File Reached.", 10, 27 promptColour
    EOFMsgLen equ $ - EOFMsg

    noFileMsg db " ", 10, \
                 27, redColour, "⚠️ Error: Product.txt file does not exist.", 27, promptColour, 10
    noFileLen equ $ - noFileMsg

    noRecordMsg db " ", 10, \
                   27, redColour, "❌ No Record Found.", 27, promptColour, 10
    noRecordLen equ $ - noRecordMsg

    indicator db 27, redColour,"❤️ LOW Stock ", 27, yellowColour, "💛 MEDIUM Stock ", 27, greenColour, "💚 HIGH Stock", 10, 10
    indicatorLen equ $ - indicator

    displayHeader db 27, blueColour, "📦 Product Name, 🔢 Product Amount", 27, promptColour, 10
    displayHeaderLen equ $ - displayHeader


; (2) SEARCH
    searchDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                        "|                                       🔍  Search Product  🔍                                         |",10,\
                                        "+------------------------------------------------------------------------------------------------------+",10
    searchDividerLen equ $ - searchDivider

    SearchPrompt db 27, promptColour, "🏷️ Enter product name to search: ", 0, 27, whiteColour
    SearchPromptLen equ $ - SearchPrompt

    ProductFoundMsg db 27, cyanColour, "✅ Product Found: ", 27, promptColour, 0
    ProductFoundMsgLen equ $ - ProductFoundMsg

    NoResultsMsg db 27, redColour, "❌ No Matching Products Found", 27, promptColour, 10, 0
    NoResultsMsgLen equ $ - NoResultsMsg

    EndOfRecordsMsg db " ", 10, \
                       27, whiteColour, "📄 End of Records Found", 10, 27, promptColour
    EndOfRecordsMsgLen equ $ - EndOfRecordsMsg

    space db " "

; (3) ADD
    addDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                     "|                                          📝  Add Product  📝                                         |",10,\
                                     "+------------------------------------------------------------------------------------------------------+",10
    addDividerLen equ $ - addDivider

    ProductNamePrompt db 27, promptColour, "🏷️ Enter Product Name: ", 27, whiteColour
    ProductNamePromptLen equ $ - ProductNamePrompt

    ProductAmountPrompt db 27, promptColour, "💵 Enter Product Amount: ", 27, whiteColour
    ProductAmountPromptLen equ $ - ProductAmountPrompt
    
    SuccessMessage db 27, cyanColour, "✅ Product added successfully.", 27, promptColour, 10, 0
    SuccessMessageLen equ $ - SuccessMessage

    InvalidAmountMsg db 27, redColour, "⚠️ Error: Invalid Input. Please Enter A Valid Amount..", 27, promptColour, 10, 0
    InvalidAmountMsgLen equ $ - InvalidAmountMsg

    ProductExistsMsg db 27, redColour, "⚠️ Product Exist.", 27, promptColour, 10
    ProductExistsMsgLen equ $ - ProductExistsMsg

    ProductFile db "Product.txt", 0
    Newline db 10
    comma db ","
    extraBuffer equ 64
    Buffer db 256 dup(0)

; (4) EDIT
    editDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                      "|                                         ♻️  Edit Product  ♻️                                         |",10,\
                                      "+------------------------------------------------------------------------------------------------------+",10
    editDividerLen equ $ - editDivider

    EditPrompt db 27, promptColour, "[1] ➕ INCREASE Quantity", 10, \
                                     "[2] ➖ DECREASE Quantity", 10, \
                                     "[0] ✖️ Cancel", 10, \
                                     "Select option ➤ ", 27, whiteColour
    EditPromptLen equ $ - EditPrompt

    EditProductPrompt db 27, promptColour, "🏷️ Enter Product Name: ", 0, 27, whiteColour
    EditProductPromptLen equ $ - EditProductPrompt

    editValuePrompt db 27, promptColour, "💵 Enter Value: ", 27, whiteColour
    editValuePromptLen equ $ - editValuePrompt

    editSuccess db 27, cyanColour, "✅ Product Inventory Updated Successfully.", 27, promptColour, 10, 0
    editSuccessLen equ $ - editSuccess

    newInventoryStr db 20 dup(0)
    updatedLine db 1024 dup(0)
    productFound dd 0
    nextLine db 0xA, 0

; (5) DELETE
    deleteDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                        "|                                          🗑️  Delete Product  🗑️                                      |",10,\
                                        "+------------------------------------------------------------------------------------------------------+",10
    deleteDividerLen equ $ - deleteDivider

    DeletePrompt db 27, promptColour, "🏷️ Enter Product Name: ", 0, 27, whiteColour
    DeletePromptLen equ $ - DeletePrompt

    ConfirmPrompt db 27, promptColour, "🧐 Are You Sure You Want To Delete This Product? (Y/N): ", 0, 27, whiteColour
    ConfirmPromptLen equ $ - ConfirmPrompt

    ProductNotFound db 27, redColour, "❌ Product Not Found.", 27, promptColour, 10, 0
    ProductNotFoundLen equ $ - ProductNotFound

    DeleteSuccess db 27, cyanColour, "✅ Product deleted successfully.", 27, promptColour, 10, 0
    DeleteSuccessLen equ $ - DeleteSuccess

    TempFile db "temp.txt", 0
    BufferLen equ $ - Buffer

    ErrorMsg db 27, redColour, "⚠️ Error occurred.", 27, promptColour, 10, 0
    ErrorMsgLen equ $ - ErrorMsg

    InvalidInput db 27, redColour, "⚠️Invalid input. Please enter Y or N only.", 27, promptColour, 10, 0
    InvalidInputLen equ $ - InvalidInput

; (6) REPORT
    generateDivider db 27, promptColour, "+------------------------------------------------------------------------------------------------------+",10,\
                                          "|                                        📊  Generate Report  📊                                       |",10,\
                                          "+------------------------------------------------------------------------------------------------------+",10
    generateDividerLen equ $ - generateDivider

    ReportCreatedMsgCSV db 27, cyanColour, "📁 Report created: Product.csv",  27, promptColour, 10
    ReportCreatedMsgCSVLen equ $ - ReportCreatedMsgCSV

    ReportFileCSV db "Product.csv", 0
    CSVHeader db "Product Name,Amount", 10, 0
    CSVHeaderLen equ $ - CSVHeader

section .bss
; (*) LOGIN
    username resb 32
    password resb 32
    encoded_buffer resb 128
    temp_buffer resb 128
    input_len resb 4
    option resb 2
    termios     resb 60      
    termios_new resb 60      ; New termios structure
    old_termios resb 60 

; (0) MAIN
    Initial resb 2

; (1) DISPLAY
    ReadBuffer resb 1024
    allProduct resb 1024

; (2) SEARCH
    LineLength resd 1
    SearchTerm resb 100
    SearchBuffer resb 1024
    TempBuffer resb 1024
    LowerSearchTerm resb 100
    LowerProductName resb 256
    lineBuffer resb 1024
    charBuffer resb 1
    lineIndex resd 1
    ProductNameBuffer resb 256

; (3) ADD
    ProductName resb 100
    AmountBuffer resb 20
    FileDescriptor resd 1

; (4) EDIT
    EditChoice resb 2
    editValue resb 20
    editValueInt resd 1
    currentInventory resd 1
    newInventory resd 1
    tempDescriptor resb 1
    inputBuffer resb 50
    TempFileDescriptor resb 1

; (5) DELETE
    ProductToDelete resb 100
    Confirmation resb 2

; (6) REPORT
    ReportFileDescriptor resd 1                           ; Buffer for amount

section .text
    global _start

_start:
; (*) LOGIN
username_loop:
    ; Display banner
    mov eax, 4
    mov ebx, 1
    mov ecx, loginPanel
    mov edx, loginPanel_len
    int 0x80
    
    ; Get username
    mov eax, 4
    mov ebx, 1
    mov ecx, inputUsername
    mov edx, inputUsernameLen
    int 0x80

    ; Read username
    mov eax, 3
    mov ebx, 0
    mov ecx, username
    mov edx, 32
    int 0x80
    
    ; Store input length
    mov [input_len], eax

    ; Remove newline and null terminate
    mov ecx, eax
    dec ecx
    cmp byte [username + ecx], 10
    jne skip_newline
    mov byte [username + ecx], 0
    dec ecx
skip_newline:
    inc ecx
    mov byte [username + ecx], 0

    ; Clear encoded buffer
    push ecx
    mov ecx, 128
    mov edi, encoded_buffer
    xor eax, eax
    rep stosb
    pop ecx

    ; Caesar cipher encode username
    mov esi, username
    mov edi, encoded_buffer
    call caesar_encode

    ; Compare encoded username with correct username
    mov esi, encoded_buffer
    mov edi, presetUsername
    call string_compare
    
    test eax, eax
    jz username_failed

    ; Username correct, proceed to password
    jmp password_input

username_failed:
    mov eax, 4
    mov ebx, 1
    mov ecx, username_fail
    mov edx, username_fail_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    jmp username_loop

disable_echo:
    push eax
    push ebx
    push ecx
    push edx
    
    ; Get current terminal settings
    mov eax, 54              
    mov ebx, STDIN
    mov ecx, TCGETS
    mov edx, termios
    int 0x80
    
    ; Save original settings
    push ecx
    mov ecx, 60
    mov esi, termios
    mov edi, old_termios
    rep movsb
    pop ecx
    
    ; Copy current settings to new structure
    push ecx
    mov ecx, 60
    mov esi, termios
    mov edi, termios_new
    rep movsb
    pop ecx
    
    ; Modify settings to disable echo and canonical mode
    mov eax, [termios_new + 12]
    and eax, ~(ICANON | ECHO)
    mov [termios_new + 12], eax
    
    ; Apply modified settings
    mov eax, 54              
    mov ebx, STDIN
    mov ecx, TCSETS
    mov edx, termios_new
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

restore_echo:
    push eax
    push ebx
    push ecx
    push edx
    
    ; Restore original settings
    mov eax, 54              
    mov ebx, STDIN
    mov ecx, TCSETS
    mov edx, old_termios
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

password_input:
    ; Display password prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, inputPassword
    mov edx, inputPasswordLen
    int 0x80

    ; Disable echo
    call disable_echo

    ; Clear password buffer
    push ecx
    mov ecx, 32
    mov edi, password
    xor eax, eax
    rep stosb
    pop ecx

    ; Read password character by character
    xor ecx, ecx            ; Character counter
.read_char:
    ; Read single character
    mov eax, 3
    mov ebx, 0
    lea edx, [password + ecx]
    push ecx
    mov ecx, edx
    mov edx, 1
    int 0x80
    pop ecx

    ; Check for return value of read
    cmp eax, 1
    jne .read_char         ; If not 1 byte read, try again

    ; Check for enter key (ASCII 10 or 13)
    cmp byte [password + ecx], 10
    je .done_reading
    cmp byte [password + ecx], 13
    je .done_reading

    ; Check for backspace (ASCII 127 or 8)
    cmp byte [password + ecx], 127
    je .backspace
    cmp byte [password + ecx], 8
    je .backspace

    ; Only accept printable characters (ASCII 32-126)
    cmp byte [password + ecx], 32
    jl .read_char
    cmp byte [password + ecx], 126
    jg .read_char

    ; No asterisk printing - just increment counter
    inc ecx
    cmp ecx, 31            ; Maximum password length
    jl .read_char
    jmp .done_reading

.backspace:
    test ecx, ecx          ; Check if we're at the start
    jz .read_char
    dec ecx
    mov byte [password + ecx], 0    
    jmp .read_char

.done_reading:
    mov byte [password + ecx], 0    ; Null terminate
    mov [input_len], ecx

    ; Restore echo
    call restore_echo

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    ; Clear encoded buffer
    push ecx
    mov ecx, 128
    mov edi, encoded_buffer
    xor eax, eax
    rep stosb
    pop ecx

    ; Caesar cipher encode password
    mov esi, password
    mov edi, encoded_buffer
    call caesar_encode

    ; Compare encoded password with correct password
    mov esi, encoded_buffer
    mov edi, presetPassword
    call string_compare
    
    test eax, eax
    jz password_failed
    jmp login_success

password_failed:
    mov eax, 4
    mov ebx, 1
    mov ecx, password_fail
    mov edx, password_fail_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    jmp username_loop

; Calculate string length (null-terminated)
strlen:
    push ebx
    push ecx
    mov ebx, ecx
    xor eax, eax
strlen_loop:
    cmp byte [ebx], 0
    je strlen_done
    inc eax
    inc ebx
    jmp strlen_loop
strlen_done:
    pop ecx
    pop ebx
    ret

; Caesar cipher encoding function (shift by 3)
caesar_encode:
    push ebx
    push ecx
    push edx

    xor ecx, ecx

.encode_loop:
    mov al, byte [esi + ecx]
    test al, al
    jz .done

    ; Only encode letters
    cmp al, 'A'
    jb .skip_char
    cmp al, 'z'
    ja .skip_char
    cmp al, 'Z'
    jle .is_uppercase
    cmp al, 'a'
    jb .skip_char

    ; Lowercase letter
    add al, 3
    cmp al, 'z'
    jle .store_char
    sub al, 26
    jmp .store_char

.is_uppercase:
    add al, 3
    cmp al, 'Z'
    jle .store_char
    sub al, 26
    jmp .store_char

.skip_char:
.store_char:
    mov byte [edi + ecx], al
    inc ecx
    jmp .encode_loop

.done:
    mov byte [edi + ecx], 0
    
    pop edx
    pop ecx
    pop ebx
    ret

; String comparison function
string_compare:
    push ebx
    push ecx
    push edx

    xor ecx, ecx

.compare_loop:
    mov al, byte [esi + ecx]
    mov dl, byte [edi + ecx]
    
    ; Check if both strings ended
    test al, al
    jz .check_end
    test dl, dl
    jz .not_equal
    
    ; Compare characters
    cmp al, dl
    jne .not_equal
    
    inc ecx
    jmp .compare_loop

.check_end:
    test dl, dl
    jnz .not_equal
    mov eax, 1
    jmp .done

.not_equal:
    xor eax, eax

.done:
    pop edx
    pop ecx
    pop ebx
    ret

login_success:
    mov eax, 4
    mov ebx, 1
    mov ecx, loginSuccessMsg
    mov edx, loginSuccessMsgLen
    int 0x80
    
    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    call _clearRegister
    jmp _InputLoop

; (0) MAIN
call _clearRegister

_InputLoop:
    ; Display the prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, mainChoice
    mov edx, mainChoiceLen
    int 0x80

_Read_Input:
    ; Read user input into larger buffer to check for overflow
    mov eax, 3
    mov ebx, 0
    mov ecx, Initial
    mov edx, 10        ; Read up to 10 characters to check for overflow
    int 0x80
    
    ; Store the number of bytes read in ebx
    mov ebx, eax
    
    ; Check if more than 2 characters were entered (digit + newline)
    cmp ebx, 2
    jg _Invalid_Input
    
    ; Check if exactly 2 characters were entered (digit + newline)
    cmp ebx, 2
    jne _Invalid_Input
    
    ; Check if second character is newline
    mov al, byte [Initial + 1]
    cmp al, 10
    jne _Invalid_Input
    
    ; Check if first character is a digit
    mov al, byte [Initial]
    cmp al, '0'
    jl _Invalid_Input
    cmp al, '9'
    jg _Invalid_Input
    
    ; Convert ASCII to integer
    sub al, '0'
    
    ; Validate the range (0-6)
    cmp al, 6
    jg _Invalid_Input
    
    ; Jump to appropriate handler
    cmp al, 0
    je _exit
    cmp al, 1
    je _displayAll
    cmp al, 2
    je _searchProduct
    cmp al, 3
    je _addProduct
    cmp al, 4
    je _editProduct
    cmp al, 5
    je _deleteProduct
    cmp al, 6
    je _generateReport

_Invalid_Input:
    mov eax, 4
    mov ebx, 1
    mov ecx, InvalidInputMsg
    mov edx, InvalidInputMsgLen
    int 0x80
    call _clearRegister
    jmp _InputLoop

_exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80
    call _clearRegister

; (1) DISPLAY
_displayAll:
    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, displayDivider
    mov edx, displayDividerLen
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, indicator
    mov edx, indicatorLen
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, displayHeader
    mov edx, displayHeaderLen
    int 0x80
    
    ; Call the function to show all products
    call _showAll
    
    ; Jump back to main input loop
    call _clearRegister
    jmp _InputLoop

_showAll:
    ; Open the file
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0          ; Read-only mode
    int 0x80

    ; Check if file exists
    cmp eax, 0
    jl .fileNotFound

    ; Store file descriptor
    mov [FileDescriptor], eax

    ; Initialize a flag to track if any products were found
    xor edi, edi        ; EDI will be our flag, 0 means no products found yet

    ; Initialize line buffer index
    mov dword [lineIndex], 0

.readLoop:
    ; Read a single character
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, charBuffer
    mov edx, 1
    int 0x80

    ; Check for EOF
    cmp eax, 0
    je .endOfFile

    ; Get the character
    mov al, byte [charBuffer]
    
    ; Check if it's a newline
    cmp al, 10
    je .processLine

    ; Add character to line buffer
    mov ecx, [lineIndex]
    mov [lineBuffer + ecx], al
    inc dword [lineIndex]
    jmp .readLoop

.processLine:
    ; Null terminate the line
    mov ecx, [lineIndex]
    mov byte [lineBuffer + ecx], 0
    
    ; Find the comma in the line
    mov esi, lineBuffer
    xor ecx, ecx
    
.findComma:
    mov al, [esi + ecx]
    cmp al, ','
    je .foundComma
    inc ecx
    jmp .findComma

.foundComma:
    ; Parse the amount after the comma
    lea esi, [lineBuffer + ecx + 1]  ; Point to character after comma
    call _parseNumber                 ; Convert string to number in EAX

    ; Compare amount and set appropriate color
    cmp eax, 100
    jl .setRedBlink    ; < 100: Red and blinking
    je .setYellow      ; = 100: Yellow
    jg .setGreen       ; > 100: Green

.setRedBlink:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set red color with blink
    mov eax, 4
    mov ebx, 1
    mov ecx, red
    mov edx, 5
    int 0x80
    ; Add blink effect
    mov eax, 4
    mov ebx, 1
    mov ecx, blink     ; Changed from bold to blink
    mov edx, 4
    int 0x80
    jmp .printLine

.setYellow:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set yellow color
    mov eax, 4
    mov ebx, 1
    mov ecx, yellow
    mov edx, 5
    int 0x80
    jmp .printLine

.setGreen:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set green color
    mov eax, 4
    mov ebx, 1
    mov ecx, green
    mov edx, 5
    int 0x80

.printLine:
    ; Print the line
    mov eax, 4
    mov ebx, 1
    mov ecx, lineBuffer
    mov edx, [lineIndex]
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80

    ; Set the flag indicating we found products
    mov edi, 1

    ; Reset line index for next line
    mov dword [lineIndex], 0
    jmp .readLoop

.endOfFile:
    ; Check if any products were found
    test edi, edi
    jz .noRecords

    ; Display end of file message if products were found
    mov eax, 4
    mov ebx, 1
    mov ecx, EOFMsg
    mov edx, EOFMsgLen
    int 0x80
    jmp .closeFile

.noRecords:
    ; Display no records message
    mov eax, 4
    mov ebx, 1
    mov ecx, noRecordMsg
    mov edx, noRecordLen
    int 0x80
    jmp .closeFile

.fileNotFound:
    ; Display file not found message
    mov eax, 4
    mov ebx, 1
    mov ecx, noFileMsg
    mov edx, noFileLen
    int 0x80
    ret

.closeFile:
    ; Close the file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80
    ret

; Helper function to parse number string to integer
_parseNumber:
    push ebx
    push ecx
    xor eax, eax    ; Initialize result
    xor ecx, ecx    ; Initialize index

.parseLoop:
    mov bl, [esi + ecx]  ; Get current character
    cmp bl, 0           ; Check for null terminator
    je .parseDone
    cmp bl, 10          ; Check for newline
    je .parseDone
    cmp bl, '0'         ; Check if character is a digit
    jl .parseDone
    cmp bl, '9'
    jg .parseDone

    ; Multiply current result by 10
    mov ebx, eax
    shl eax, 3         ; multiply by 8
    shl ebx, 1         ; multiply by 2
    add eax, ebx       ; add together (multiply by 10)

    ; Add new digit
    mov bl, [esi + ecx]
    sub bl, '0'        ; Convert ASCII to number
    add eax, ebx

    inc ecx
    jmp .parseLoop

.parseDone:
    pop ecx
    pop ebx
    ret

; (2) SEARCH
_searchProduct:
    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, searchDivider
    mov edx, searchDividerLen
    int 0x80

    ; Prompt for search term
    mov eax, 4
    mov ebx, 1
    mov ecx, SearchPrompt
    mov edx, SearchPromptLen
    int 0x80

    ; Read search term
    mov eax, 3
    mov ebx, 0
    mov ecx, SearchTerm
    mov edx, 100
    int 0x80

    ; Remove newline from SearchTerm
    mov esi, SearchTerm
    mov edi, SearchTerm
.remove_newline:
    lodsb
    cmp al, 10
    je .end_remove_newline
    stosb
    jmp .remove_newline
.end_remove_newline:
    mov byte [edi], 0  ; Null-terminate

    ; Open the file
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0  ; Read-only
    int 0x80

    ; Check if file exists
    cmp eax, 0
    jl .fileNotFound

    ; Store file descriptor
    mov [FileDescriptor], eax

    ; Initialize match flag
    xor esi, esi  ; ESI will be our flag, 0 means no matches found yet

    ; Initialize line buffer and length
    mov dword [LineLength], 0

    ; Print "Product Found: " header only once
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductFoundMsg
    mov edx, ProductFoundMsgLen
    int 0x80

    ; Print newline after the header
    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

.readLoop:
    ; Read a single character from the file
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, Buffer
    mov edx, 1
    int 0x80

    ; Check if EOF
    cmp eax, 0
    je .endOfFile

    ; Check if it's a newline character
    cmp byte [Buffer], 10
    je .processLine

    ; If not a newline, add to line buffer
    mov al, [Buffer]
    mov ecx, [LineLength]
    mov [lineBuffer + ecx], al
    inc dword [LineLength]
    jmp .readLoop

.processLine:
    ; Null-terminate the line buffer
    mov ecx, [LineLength]
    mov byte [lineBuffer + ecx], 0

    ; Extract product name from the line (up to the comma)
    mov ecx, lineBuffer
    mov edx, ProductNameBuffer
    xor eax, eax  ; Clear EAX to use AL as counter

.extract_name:
    mov bl, [ecx + eax]
    cmp bl, ','
    je .name_extracted
    cmp bl, 0
    je .name_extracted
    mov [edx + eax], bl
    inc eax
    jmp .extract_name

.name_extracted:
    mov byte [edx + eax], 0  ; Null-terminate ProductNameBuffer

    ; Compare extracted product name with search term
    mov ecx, SearchTerm
    mov edx, ProductNameBuffer
    call _strncmp  ; Use _strncmp instead of _strcmp

    ; If strings match at the beginning, product found
    test eax, eax
    jz .matchFound

    ; Reset line buffer and length for next line
    mov dword [LineLength], 0
    jmp .readLoop

.matchFound:
    ; Set flag indicating a match was found
    mov esi, 1

    ; Find the comma to parse the amount
    mov edi, lineBuffer
    xor ecx, ecx
.find_comma:
    mov al, [edi + ecx]
    cmp al, ','
    je .found_comma
    inc ecx
    jmp .find_comma

.found_comma:
    ; Parse the amount after the comma
    lea esi, [edi + ecx + 1]  ; Point to character after comma
    call _parseNumber         ; Convert string to number in EAX

    ; Compare amount and set appropriate color
    cmp eax, 100
    jl .setRedBlink    ; < 100: Red and blinking
    je .setYellow      ; = 100: Yellow
    jg .setGreen       ; > 100: Green

.setRedBlink:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set red color with blink
    mov eax, 4
    mov ebx, 1
    mov ecx, red
    mov edx, 5
    int 0x80
    ; Add blink effect
    mov eax, 4
    mov ebx, 1
    mov ecx, blink     ; Changed from bold to blink
    mov edx, 4
    int 0x80
    jmp .printLine

.setYellow:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set yellow color
    mov eax, 4
    mov ebx, 1
    mov ecx, yellow
    mov edx, 5
    int 0x80
    jmp .printLine

.setGreen:
    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80
    ; Set green color
    mov eax, 4
    mov ebx, 1
    mov ecx, green
    mov edx, 5
    int 0x80

.printLine:
    ; Print the matching line
    mov eax, 4
    mov ebx, 1
    mov ecx, lineBuffer
    mov edx, [LineLength]
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, Newline
    mov edx, 1
    int 0x80

    ; Reset color
    mov eax, 4
    mov ebx, 1
    mov ecx, reset
    mov edx, 4
    int 0x80

    ; Reset line buffer and length for next line
    mov dword [LineLength], 0
    jmp .readLoop

.endOfFile:
    ; Close the file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80

    ; Check if any matches were found
    test esi, esi
    jnz .searchDone

    ; No matches found, display message
    mov eax, 4
    mov ebx, 1
    mov ecx, NoResultsMsg
    mov edx, NoResultsMsgLen
    int 0x80

.searchDone:
    jmp .done

.fileNotFound:
    ; Display file not found message
    mov eax, 4
    mov ebx, 1
    mov ecx, noFileMsg
    mov edx, noFileLen
    int 0x80

.done:
    ; Display end of file message if products were found
    mov eax, 4
    mov ebx, 1
    mov ecx, EndOfRecordsMsg
    mov edx, EndOfRecordsMsgLen
    int 0x80
    
    call _clearRegister
    jmp _InputLoop

; String comparison function (case-sensitive, checks if str2 starts with str1)
_strncmp:
    push esi
    push edi
    mov esi, ecx  ; SearchTerm
    mov edi, edx  ; ProductNameBuffer

.compare_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, 0
    je .equal     ; If we've reached the end of SearchTerm, it's a match
    cmp bl, 0
    je .not_equal ; If ProductNameBuffer ends before SearchTerm, not a match
    cmp al, bl
    jne .not_equal
    inc esi
    inc edi
    jmp .compare_loop

.equal:
    xor eax, eax
    jmp .done_compare

.not_equal:
    mov eax, 1

.done_compare:
    pop edi
    pop esi
    ret

; (3) ADD
_addProduct:
    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, addDivider
    mov edx, addDividerLen
    int 0x80

    ; Prompt for product name
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductNamePrompt
    mov edx, ProductNamePromptLen
    int 0x80

    ; Read product name
    mov eax, 3
    mov ebx, 0
    mov ecx, ProductName
    mov edx, extraBuffer
    int 0x80

    ; Remove newline from ProductName
    mov esi, ProductName

.remove_name_newline:
    lodsb
    cmp al, 10
    jne .remove_name_newline
    dec esi
    mov byte [esi], 0

; Check if product already exists
    call _checkProductExists
    cmp eax, 1
    je .product_exists

    ; Continue with normal flow to .prompt_amount
    jmp .prompt_amount

.product_exists:
    ; Display product exists error message
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductExistsMsg
    mov edx, ProductExistsMsgLen
    int 0x80
    
    call _clearRegister
    jmp _InputLoop

.prompt_amount:
    ; Prompt for product amount
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductAmountPrompt
    mov edx, ProductAmountPromptLen
    int 0x80

    ; Read product amount
    mov eax, 3
    mov ebx, 0
    mov ecx, AmountBuffer
    mov edx, extraBuffer
    int 0x80

    ; Validate amount input
    mov esi, AmountBuffer
    xor ecx, ecx  ; Use ECX as a flag to check if any valid digit was found

.validate_input:
    lodsb
    cmp al, 10  ; Check for newline
    je .end_validation
    cmp al, 0   ; Check for null terminator
    je .end_validation
    cmp al, '0'
    jl .invalid_amount
    cmp al, '9'
    jg .invalid_amount
    inc ecx     ; Increment valid digit counter
    jmp .validate_input

.end_validation:
    ; Check if at least one valid digit was found
    test ecx, ecx
    jz .invalid_amount

    ; Valid amount, proceed to save
    jmp .save_product

.invalid_amount:
    ; Display error message for invalid amount
    mov eax, 4
    mov ebx, 1
    mov ecx, InvalidAmountMsg
    mov edx, InvalidAmountMsgLen
    int 0x80
    jmp .prompt_amount  ; Ask for amount again

.save_product:
    ; Open the file for appending
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 2102o  ; O_WRONLY | O_APPEND | O_CREAT
    mov edx, 0666o  ; File permissions
    int 0x80
    mov [FileDescriptor], eax

    ; Calculate length of item_buffer
    mov esi, ProductName
    call _strlen
    mov edx, eax  ; Store length in edx for writing

    ; Write product name to file
    mov eax, 4
    mov ebx, [FileDescriptor]
    mov ecx, ProductName
    int 0x80

    ; Write comma comma
    mov eax, 4
    mov ebx, [FileDescriptor]
    mov ecx, comma
    mov edx, 1
    int 0x80

    ; Calculate length of price_buffer
    mov esi, AmountBuffer
    call _strlen
    mov edx, eax 

    ; Write product amount to file
    mov eax, 4
    mov ebx, [FileDescriptor]
    mov ecx, AmountBuffer
    int 0x80

    ; Close the file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80

    ; Display success message
    mov eax, 4
    mov ebx, 1
    mov ecx, SuccessMessage
    mov edx, SuccessMessageLen
    int 0x80

        ; Clear ProductName buffer
    push eax            ; Save registers we'll use
    push ecx
    push edi
    
    mov eax, 0         ; Zero to fill with
    mov edi, ProductName
    mov ecx, extraBuffer
    rep stosb          ; Fill ProductName with zeros
    
    ; Clear AmountBuffer
    mov edi, AmountBuffer
    mov ecx, extraBuffer
    rep stosb          ; Fill AmountBuffer with zeros
    
    pop edi            ; Restore registers
    pop ecx
    pop eax

    call _clearRegister
    jmp _InputLoop

    ; Helper function to check if product exists
_checkProductExists:
    ; Input: ProductName buffer contains the name to check
    ; Output: EAX = 0 if product doesn't exist, 1 if exists
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; Open the file
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0          ; Read-only mode
    int 0x80

    ; Check if file exists
    cmp eax, 0
    jl .fileError

    ; Store file descriptor
    mov [FileDescriptor], eax

    ; Initialize line buffer
    mov dword [lineIndex], 0
    
.readLoop:
    ; Read a single character
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, charBuffer
    mov edx, 1
    int 0x80

    ; Check for EOF
    cmp eax, 0
    je .productNotFound

    ; Get the character
    mov al, byte [charBuffer]
    
    ; Check if it's a newline
    cmp al, 10
    je .processLine

    ; Check if it's a comma
    cmp al, ','
    je .compareName

    ; Add character to line buffer
    mov ecx, [lineIndex]
    mov [lineBuffer + ecx], al
    inc dword [lineIndex]
    jmp .readLoop

.compareName:
    ; Null terminate the line buffer
    mov ecx, [lineIndex]
    mov byte [lineBuffer + ecx], 0

    ; Compare product names
    mov esi, ProductName
    mov edi, lineBuffer
    call _strcmpAdd
    
    ; If names match (EAX = 0), product exists
    cmp eax, 0
    je .productFound

    ; If no match, continue reading next line
    mov dword [lineIndex], 0
    jmp .readLoop

.processLine:
    ; Reset line buffer for next line
    mov dword [lineIndex], 0
    jmp .readLoop

.productFound:
    ; Close file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80
    
    mov eax, 1          ; Return 1 (product exists)
    jmp .return

.productNotFound:
    ; Close file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80
    
    mov eax, 0          ; Return 0 (product doesn't exist)
    jmp .return

.fileError:
    mov eax, 0          ; Return 0 if file doesn't exist

.return:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; String comparison function (case-sensitive)
_strcmpAdd:
    ; Input: ESI = first string, EDI = second string
    ; Output: EAX = 0 if strings match, 1 if different
    push esi
    push edi

.compare_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, 0
    je .check_end
    cmp al, bl
    jne .not_equal
    inc esi
    inc edi
    jmp .compare_loop

.check_end:
    cmp bl, 0
    jne .not_equal
    xor eax, eax        ; Strings are equal
    jmp .done

.not_equal:
    mov eax, 1          ; Strings are different

.done:
    pop edi
    pop esi
    ret

; (4) EDIT
_editProduct:
    mov eax, 4
    mov ebx, 1
    mov ecx, displayHeader
    mov edx, displayHeaderLen
    int 0x80

    call _showAll

    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, editDivider
    mov edx, editDividerLen
    int 0x80

    ; Prompt for product name to edit
    mov eax, 4
    mov ebx, 1
    mov ecx, EditProductPrompt
    mov edx, EditProductPromptLen
    int 0x80

    ; Read product name to modify
    mov eax, 3
    mov ebx, 0
    mov ecx, inputBuffer
    mov edx, 100
    int 0x80

    ; Remove newline from input
    mov esi, inputBuffer
.remove_newline1:
    lodsb
    cmp al, 10
    jne .remove_newline1
    dec esi
    mov byte [esi], 0

    ; Open the original file for reading
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0  ; O_RDONLY
    int 0x80

    ; Check if file was opened successfully
    cmp eax, 0
    jl .fileNotFound
    mov [FileDescriptor], eax

    ; Open temp file for writing
    mov eax, 5
    mov ebx, TempFile
    mov ecx, 0x242  ; O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0666o  ; File permissions
    int 0x80
    cmp eax, 0
    jl .errorHandle
    mov [TempFileDescriptor], eax  ; Store temp file descriptor in TempFileDescriptor

    ; Initialize flag to check if product was found
    xor esi, esi  ; ESI will be our flag, 0 means product not found yet

.readLoop:
    ; Read a single character from the original file
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, Buffer
    mov edx, 1
    int 0x80

    ; Check if EOF
    cmp eax, 0
    je .editDone

    ; Check if it's a newline character
    cmp byte [Buffer], 10
    je .processLine

    ; If not a newline, add to line Buffer
    mov al, [Buffer]
    mov ecx, [LineLength]
    mov [lineBuffer + ecx], al
    inc dword [LineLength]
    jmp .readLoop

.processLine:
    ; Null-terminate the line Buffer
    mov ecx, [LineLength]
    mov byte [lineBuffer + ecx], 0

    ; Extract product name from the line (up to the comma)
    mov ecx, lineBuffer
    mov edx, ProductNameBuffer
    xor eax, eax  ; Clear EAX to use AL as counter

.extract_name:
    mov bl, [ecx + eax]
    cmp bl, ','
    je .name_extracted
    cmp bl, 0
    je .name_extracted
    mov [edx + eax], bl
    inc eax
    jmp .extract_name

.name_extracted:
    mov byte [edx + eax], 0  ; Null-terminate ProductNameBuffer

    ; Compare extracted product name with input
    mov ecx, inputBuffer
    mov edx, ProductNameBuffer
    call _strcmp

    ; If strings match, product found
    test eax, eax
    jz .productFound

    ; If no match, write the line to temp file
    mov eax, 4
    mov ebx, [TempFileDescriptor]  ; Write to temp file
    mov ecx, lineBuffer
    mov edx, [LineLength]
    int 0x80

    ; Write the newline character
    mov eax, 4
    mov ebx, [TempFileDescriptor]
    mov ecx, nextLine
    mov edx, 1
    int 0x80

    mov dword [LineLength], 0
    jmp .readLoop

.productFound:
    ; Set flag indicating product was found
    mov esi, 1

.input_loop:
    ; Display options
    mov eax, 4
    mov ebx, 1
    mov ecx, EditPrompt
    mov edx, EditPromptLen
    int 0x80

    ; Read user's choice
    mov eax, 3
    mov ebx, 0
    mov ecx, EditChoice
    mov edx, 2  ; Read up to 2 bytes (1 digit + newline)
    int 0x80

    ; Check if more than one character was entered (excluding newline)
    cmp eax, 2
    jne .invalid_input

    ; Check if the first character is a digit and the second is a newline
    mov al, [EditChoice]
    cmp al, '0'
    jl .invalid_input
    cmp al, '9'
    jg .invalid_input

    mov al, [EditChoice + 1]
    cmp al, 10  ; newline character
    jne .invalid_input

    ; At this point, we have a valid single-digit input
    mov al, [EditChoice]

    ; Check if the input is a valid choice (0, 1, or 2)
    cmp al, '0'
    je .valid_input
    cmp al, '1'
    je .valid_input
    cmp al, '2'
    je .valid_input

.invalid_input:
    ; If we reach here, the input was invalid
    mov eax, 4
    mov ebx, 1
    mov ecx, InvalidInputMsg
    mov edx, InvalidInputMsgLen
    int 0x80
    jmp .input_loop

.valid_input:
    ; Continue with the rest of the function
    cmp al, '0'
    je .editFinish  ; If choice is 0, go back to main menu

    ; Ask for the value to adjust by
    mov eax, 4
    mov ebx, 1
    mov ecx, editValuePrompt
    mov edx, editValuePromptLen
    int 0x80

    ; Read adjustment value
    mov eax, 3
    mov ebx, 0
    mov ecx, editValue
    mov edx, 20
    int 0x80

    ; Initialize validation
    mov esi, editValue
    xor ecx, ecx  ; Use ECX as counter for valid digits

.validate_edit_value:
    lodsb
    cmp al, 10  ; Check for newline
    je .check_validation
    cmp al, 0   ; Check for null terminator
    je .check_validation
    cmp al, '0'
    jl .invalid_edit_value
    cmp al, '9'
    jg .invalid_edit_value
    inc ecx     ; Increment valid digit counter
    jmp .validate_edit_value

.check_validation:
    ; Check if at least one valid digit was found
    test ecx, ecx
    jz .invalid_edit_value

    ; Remove newline from input
    mov esi, editValue
.remove_newline2:
    lodsb
    cmp al, 10
    jne .remove_newline2
    dec esi
    mov byte [esi], 0

    ; Find the inventory in the line (after the comma)
    mov esi, lineBuffer
    xor ecx, ecx
    jmp .find_comma

.invalid_edit_value:
    ; Display error message for invalid value
    mov eax, 4
    mov ebx, 1
    mov ecx, InvalidAmountMsg
    mov edx, InvalidAmountMsgLen
    int 0x80

    ; Ask for value again
    jmp .valid_input

.find_comma:
    lodsb
    inc ecx
    cmp al, ','
    jne .find_comma

    ; Convert inventory string to integer
    push esi
    call atoi
    add esp, 4
    mov [currentInventory], eax

    ; Convert adjustment value to integer
    push editValue
    call atoi
    add esp, 4
    mov [editValueInt], eax

    mov al, [EditChoice]

    cmp al, '1'
    je .increaseQuantity
    cmp al, '2'
    je .decreaseQuantity

.increaseQuantity:
    mov eax, [currentInventory]
    add eax, [editValueInt]
    jmp .updateQuantity

.decreaseQuantity:
    mov eax, [currentInventory]
    sub eax, [editValueInt]
    jmp .updateQuantity

.updateQuantity:
    ; Convert result back to string
    push eax
    push newInventoryStr
    call itoa
    add esp, 8

    mov esi, lineBuffer
    mov edi, updatedLine
    xor ecx, ecx

.copy_Product:
    lodsb
    stosb
    inc ecx
    cmp al, ','
    jne .copy_Product

    ; Copy the new inventory
    mov esi, newInventoryStr
    
.copy_Inventory:
    lodsb
    test al, al
    jz .new_inventory
    stosb
    inc ecx
    jmp .copy_Inventory

.new_inventory:
    ; Add newline
    mov byte [edi], 10  ; ASCII for newline
    inc ecx

    mov esi, updatedLine
    call _strlen
    mov edx, eax

    ; Write the updated line to temp file
    mov eax, 4
    mov ebx, [TempFileDescriptor]
    mov ecx, updatedLine
    int 0x80

    mov dword [LineLength], 0
    jmp .readLoop

.editDone:
    ; Close both files
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80

    mov eax, 6
    mov ebx, [TempFileDescriptor]
    int 0x80

    ; Check if product was found
    test esi, esi
    je .productNotFound

    ; Rename temp file to original file
    mov eax, 38  ; sys_rename
    mov ebx, TempFile
    mov ecx, ProductFile
    int 0x80

    ; Print success message
    mov eax, 4
    mov ebx, 1
    mov ecx, editSuccess
    mov edx, editSuccessLen
    int 0x80

    jmp .editFinish

.productNotFound:
    ; Display product not found message
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductNotFound
    mov edx, ProductNotFoundLen
    int 0x80

    mov eax, 10  ; sys_unlink
    mov ebx, TempFile
    int 0x80

    jmp .editFinish

.fileNotFound:
    mov eax, 4
    mov ebx, 1
    mov ecx, noFileMsg
    mov edx, noFileLen
    int 0x80

    jmp .editFinish

.errorHandle:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, ErrorMsg
    mov edx, ErrorMsgLen
    int 0x80

.editFinish:
    call _clearRegister
    jmp _InputLoop

; (5) DELETE
_deleteProduct:
    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, deleteDivider
    mov edx, deleteDividerLen
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, displayHeader
    mov edx, displayHeaderLen
    int 0x80

    call _showAll

    ; Prompt for product name to delete
    mov eax, 4
    mov ebx, 1
    mov ecx, DeletePrompt
    mov edx, DeletePromptLen
    int 0x80

    ; Read product name to delete
    mov eax, 3
    mov ebx, 0
    mov ecx, ProductToDelete
    mov edx, 100
    int 0x80

    ; Remove newline from ProductToDelete
    mov esi, ProductToDelete

.remove_newline:
    lodsb
    cmp al, 10
    jne .remove_newline
    dec esi
    mov byte [esi], 0

    ; Open the original file for reading
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0  ; O_RDONLY
    int 0x80

    ; Check if file was opened successfully
    cmp eax, 0
    jl .fileNotFound
    mov [FileDescriptor], eax

    ; Open temp file for writing
    mov eax, 5
    mov ebx, TempFile
    mov ecx, 0x242  ; O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0666o  ; File permissions
    int 0x80
    cmp eax, 0
    jl .errorHandle
    mov edi, eax  ; Store temp file descriptor in EDI

    ; Initialize flag to check if product was found
    xor esi, esi  ; ESI will be our flag, 0 means product not found yet

.readLoop:
    ; Read a single character from the original file
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, Buffer
    mov edx, 1
    int 0x80

    ; Check if EOF
    cmp eax, 0
    je .endOfFile

    ; Check if it's a newline character
    cmp byte [Buffer], 10
    je .processLine

    ; If not a newline, add to line buffer
    mov al, [Buffer]
    mov ecx, [LineLength]
    mov [lineBuffer + ecx], al
    inc dword [LineLength]
    jmp .readLoop

.processLine:
    ; Null-terminate the line buffer
    mov ecx, [LineLength]
    mov byte [lineBuffer + ecx], 0

    ; Extract product name from the line (up to the comma)
    mov ecx, lineBuffer
    mov edx, ProductNameBuffer
    xor eax, eax  ; Clear EAX to use AL as counter

.extract_name:
    mov bl, [ecx + eax]
    cmp bl, ','
    je .name_extracted
    cmp bl, 0
    je .name_extracted
    mov [edx + eax], bl
    inc eax
    jmp .extract_name

.name_extracted:
    mov byte [edx + eax], 0  ; Null-terminate ProductNameBuffer

    ; Compare extracted product name with input
    mov ecx, ProductToDelete
    mov edx, ProductNameBuffer
    call _strcmp

    ; If strings match, product found
    test eax, eax
    jz .productFound

    ; If no match, write the line to temp file
    mov eax, 4
    mov ebx, edi  ; Write to temp file
    mov ecx, lineBuffer
    mov edx, [LineLength]
    int 0x80

    ; Write the newline character
    mov eax, 4
    mov ebx, edi
    mov ecx, Newline
    mov edx, 1
    int 0x80

    ; Reset line buffer and length
    mov dword [LineLength], 0
    jmp .readLoop

.productFound:
    ; Set flag indicating product was found
    mov esi, 1

.confirmationLoop:
    ; Ask for confirmation
    mov eax, 4
    mov ebx, 1
    mov ecx, ConfirmPrompt
    mov edx, ConfirmPromptLen
    int 0x80

    ; Read confirmation
    mov eax, 3
    mov ebx, 0
    mov ecx, Confirmation
    mov edx, 2
    int 0x80

    ; Check confirmation (case-insensitive)
    mov al, [Confirmation]
    or al, 0x20  ; Convert to lowercase
    
    ; Check if input is 'y'
    cmp al, 'y'
    je .processConfirmation
    
    ; Check if input is 'n'
    cmp al, 'n'
    je .processConfirmation
    
    ; If we get here, input is invalid
    mov eax, 4
    mov ebx, 1
    mov ecx, InvalidInput
    mov edx, InvalidInputLen
    int 0x80
    
    jmp .confirmationLoop  ; Loop back for new input

.processConfirmation:
    ; Now check if it was 'y' to proceed with deletion
    cmp al, 'y'
    jne .cancelDelete

    ; If confirmed, skip writing this line (effectively deleting it)
    mov dword [LineLength], 0
    jmp .readLoop

.cancelDelete:
    ; If not confirmed, return to main menu without showing any message
    call _clearRegister
    jmp _InputLoop

.endOfFile:
    ; Close both files
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80

    mov eax, 6
    mov ebx, edi
    int 0x80

    ; Check if product was found
    test esi, esi
    jz .productNotFound

    ; Rename temp file to original file
    mov eax, 38  ; sys_rename
    mov ebx, TempFile
    mov ecx, ProductFile
    int 0x80
    cmp eax, 0
    jl .errorHandle

    ; Display success message
    mov eax, 4
    mov ebx, 1
    mov ecx, DeleteSuccess
    mov edx, DeleteSuccessLen
    int 0x80

    call _clearRegister
    jmp .deleteEnd

.productNotFound:
    ; Display product not found message
    mov eax, 4
    mov ebx, 1
    mov ecx, ProductNotFound
    mov edx, ProductNotFoundLen
    int 0x80

    jmp .deleteEnd

.fileNotFound:
    mov eax, 4
    mov ebx, 1
    mov ecx, noFileMsg
    mov edx, noFileLen
    int 0x80

    jmp .deleteEnd

.errorHandle:
    ; Display error message
    mov eax, 4
    mov ebx, 1
    mov ecx, ErrorMsg
    mov edx, ErrorMsgLen
    int 0x80

.deleteEnd:
    call _clearRegister
    jmp _InputLoop

; String comparison function (case-sensitive)
_strcmp:
    push esi
    push edi
    mov esi, ecx
    mov edi, edx

.compare_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, 0
    je .check_end
    cmp bl, 0
    je .not_equal
    cmp al, bl
    jne .not_equal
    inc esi
    inc edi
    jmp .compare_loop

.check_end:
    cmp bl, 0
    je .equal
    jmp .not_equal

.equal:
    xor eax, eax
    jmp .done_compare

.not_equal:
    mov eax, 1

.done_compare:
    pop edi
    pop esi
    ret

; (6) REPORT
_generateReport:
    ; Display the section header
    mov eax, 4
    mov ebx, 1
    mov ecx, generateDivider
    mov edx, generateDividerLen
    int 0x80

    ; Open the product database file for reading
    mov eax, 5
    mov ebx, ProductFile
    mov ecx, 0  ; O_RDONLY
    int 0x80
    
    ; Check if file exists
    cmp eax, 0
    jl .fileNotFound
    
    mov [FileDescriptor], eax

    ; Open the report file for writing (we'll change the extension to .csv)
    mov eax, 5
    mov ebx, ReportFileCSV  ; This should be defined in the .data section as "product_report.csv", 0
    mov ecx, 0x242  ; O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0666o  ; File permissions
    int 0x80
    mov [ReportFileDescriptor], eax

    ; Write CSV header
    mov eax, 4
    mov ebx, [ReportFileDescriptor]
    mov ecx, CSVHeader  ; This should be defined in the .data section as "Product Name,Amount", 10, 0
    mov edx, CSVHeaderLen  ; Length of the CSV header
    int 0x80

.readLoop:
    ; Read a line from the product file
    mov eax, 3
    mov ebx, [FileDescriptor]
    mov ecx, lineBuffer
    mov edx, 1024
    int 0x80

    ; Check if EOF
    cmp eax, 0
    je .endOfFile

    ; Write the line as-is to the CSV file (it's already in CSV format)
    mov edx, eax  ; Length of the read line
    mov eax, 4
    mov ebx, [ReportFileDescriptor]
    mov ecx, lineBuffer
    int 0x80

    jmp .readLoop

.endOfFile:
    ; Close product file
    mov eax, 6
    mov ebx, [FileDescriptor]
    int 0x80

    ; Close report file
    mov eax, 6
    mov ebx, [ReportFileDescriptor]
    int 0x80

    ; Display success message
    mov eax, 4
    mov ebx, 1
    mov ecx, ReportCreatedMsgCSV  ; This should be defined in the .data section
    mov edx, ReportCreatedMsgCSVLen
    int 0x80

    call _clearRegister   
    jmp _InputLoop  ; Return to main menu

.fileNotFound:
    ; If the file does not exist
    mov eax, 4
    mov ebx, 1
    mov ecx, noFileMsg
    mov edx, noFileLen
    int 0x80

    call _clearRegister
    jmp _InputLoop  ; Return to main menu


; Helper Function
; ASCII to Int
atoi:
    push ebx
    push ecx
    push edx
    push esi
    
    mov esi, [esp + 20]  ; Get the string address
    xor eax, eax         ; Initialize result to 0
    xor ecx, ecx         ; Initialize sign flag to positive
    
    ; Check for sign
    mov bl, [esi]
    cmp bl, '-'
    jne .loop
    inc esi              ; Move past the minus sign
    mov ecx, 1           ; Set sign flag to negative
    
.loop:
    movzx ebx, byte [esi]  ; Get the next character
    test bl, bl
    jz .done             ; If null terminator, we're done
    
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .done
    
    sub bl, '0'          ; Convert ASCII to number
    imul eax, 10         ; Multiply current result by 10
    add eax, ebx         ; Add new digit
    
    inc esi              ; Move to next character
    jmp .loop
    
.done:
    test ecx, ecx
    jz .positive
    neg eax              ; If negative, negate the result
    
.positive:
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret

; Int to ASCII
itoa:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi

    mov eax, [ebp + 12]  ; Get the integer value
    mov edi, [ebp + 8]   ; Get the buffer address
    mov esi, edi         ; Save the start of the buffer
    mov ebx, 10          ; Divisor

    ; Check if the number is negative
    test eax, eax
    jns .convert
    neg eax
    mov byte [edi], '-'
    inc edi

.convert:
    xor edx, edx         ; Clear EDX for division
    div ebx              ; Divide EAX by 10, quotient in EAX, remainder in EDX
    add dl, '0'          ; Convert remainder to ASCII
    mov [edi], dl        ; Store the digit
    inc edi              ; Move to next position in buffer
    test eax, eax        ; Check if quotient is zero
    jnz .convert         ; If not, continue converting

    mov byte [edi], 0    ; Null-terminate the string

    ; Now reverse the string (excluding the minus sign if present)
    dec edi              ; Move EDI to the last character
    cmp byte [esi], '-'
    jne .reverse
    inc esi              ; Skip the minus sign if present

.reverse:
    cmp esi, edi
    jae .done

    mov al, [esi]
    mov ah, [edi]
    mov [esi], ah
    mov [edi], al

    inc esi
    dec edi
    jmp .reverse

.done:
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret

_strlen:
    xor eax, eax

.loop:
    cmp byte [esi + eax], 0
    je .done
    inc eax
    jmp .loop

.done:
    ret

_clearRegister:
    xor eax, eax        ; Clear EAX
    xor ebx, ebx        ; Clear EBX
    xor ecx, ecx        ; Clear ECX
    xor edx, edx        ; Clear EDX
    xor esi, esi        ; Clear ESI
    xor edi, edi        ; Clear EDI
    xor ebp, ebp        ; Clear EBP (optional)
    ret