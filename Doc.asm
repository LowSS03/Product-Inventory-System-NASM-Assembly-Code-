section .data
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
; (6) REPORT
    ReportFileDescriptor resd 1                           ; Buffer for amount

section .text
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
