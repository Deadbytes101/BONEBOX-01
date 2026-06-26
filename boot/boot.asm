; BONEBOX-01 boot sector
; BIOS only gets us off the floor. The kernel owns the machine after that.

bits 16
org 0x7c00

KERNEL_SEG     equ 0x1000
KERNEL_SECTORS equ 32

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [boot_drive], dl

    mov si, boot_msg
    call bios_puts

    mov ax, KERNEL_SEG
    mov es, ax
    xor bx, bx

    mov ah, 0x02
    mov al, KERNEL_SECTORS
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_fail

    cmp al, KERNEL_SECTORS
    jne disk_fail

    jmp KERNEL_SEG:0x0000

disk_fail:
    mov si, disk_msg
    call bios_puts
.hang:
    hlt
    jmp .hang

bios_puts:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0e
    mov bx, 0x0007
    int 0x10
    jmp bios_puts
.done:
    ret

boot_msg db 'BONEBOX boot', 13, 10, 0
disk_msg db 'disk read failed', 13, 10, 0
boot_drive db 0

times 510 - ($ - $$) db 0
dw 0xaa55
