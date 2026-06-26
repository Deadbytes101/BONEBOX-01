; BONEBOX-01 first kernel
; 16-bit real mode. No DOS. No BIOS services after boot handoff.

bits 16
org 0x0000

VIDEO_SEG equ 0xb800
COLS      equ 80
ROWS      equ 25
CELLS     equ 2000
ATTR      equ 0x0f
MAX_LINE  equ 63

kernel_start:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xfffe
    sti

    call clear_screen
    mov si, banner
    call puts
    call prompt

shell_loop:
    call read_key
    cmp al, 13
    je shell_enter
    cmp al, 8
    je shell_backspace
    cmp al, 0
    je shell_loop

    mov bl, [line_len]
    cmp bl, MAX_LINE
    jae shell_loop
    xor bh, bh
    mov [line_buf + bx], al
    inc byte [line_len]
    call putc
    jmp shell_loop

shell_enter:
    call newline
    xor bx, bx
    mov bl, [line_len]
    mov byte [line_buf + bx], 0
    call run_command
    mov byte [line_len], 0
    call prompt
    jmp shell_loop

shell_backspace:
    cmp byte [line_len], 0
    je shell_loop
    dec byte [line_len]
    mov al, 8
    call putc
    jmp shell_loop

prompt:
    mov si, prompt_msg
    call puts
    ret

run_command:
    mov si, line_buf
    cmp byte [si], 0
    je .done

    mov di, word_help
    call streq
    cmp ax, 1
    je do_help

    mov di, word_cls
    call streq
    cmp ax, 1
    je do_cls

    mov di, word_mem
    call streq
    cmp ax, 1
    je do_mem

    mov di, word_ports
    call streq
    cmp ax, 1
    je do_ports

    mov di, word_peek
    call streq
    cmp ax, 1
    je do_peek

    mov di, word_beep
    call streq
    cmp ax, 1
    je do_beep

    mov di, word_demo
    call streq
    cmp ax, 1
    je do_demo

    mov di, word_law
    call streq
    cmp ax, 1
    je do_law

    mov di, word_halt
    call streq
    cmp ax, 1
    je do_halt

    mov si, unknown_msg
    call puts
.done:
    ret

streq:
    push si
    push di
.loop:
    lodsb
    mov bl, [di]
    inc di
    cmp al, bl
    jne .no
    test al, al
    jne .loop
    mov ax, 1
    jmp .out
.no:
    xor ax, ax
.out:
    pop di
    pop si
    ret

do_help:
    mov si, help_msg
    call puts
    ret

do_cls:
    call clear_screen
    ret

do_mem:
    mov si, mem_msg
    call puts
    mov si, cs_msg
    call puts
    mov ax, cs
    call put_hex16
    call newline
    ret

do_ports:
    mov si, ports_msg
    call puts
    ret

do_peek:
    mov si, peek_msg
    call puts
    push ax
    push bx
    push cx
    push es
    xor ax, ax
    mov es, ax
    mov bx, 0x7c00
    mov cx, 16
.loop:
    mov al, [es:bx]
    call put_hex8
    mov al, ' '
    call putc
    inc bx
    loop .loop
    pop es
    pop cx
    pop bx
    pop ax
    call newline
    ret

do_beep:
    call pc_beep
    mov si, beep_msg
    call puts
    ret

do_demo:
    push ax
    push bx
    push cx
    push di
    push es
    mov ax, VIDEO_SEG
    mov es, ax
    xor di, di
    xor bx, bx
    mov cx, CELLS
.loop:
    mov al, bl
    and al, 15
    add al, 'A'
    mov ah, bl
    and ah, 15
    or ah, 0x10
    stosw
    inc bx
    loop .loop
    pop es
    pop di
    pop cx
    pop bx
    pop ax
    mov word [cursor_pos], 0
    call update_cursor
    mov si, demo_msg
    call puts
    ret

do_law:
    mov si, law_msg
    call puts
    ret

do_halt:
    mov si, halt_msg
    call puts
    cli
.stop:
    hlt
    jmp .stop

read_key:
.wait:
    in al, 0x64
    test al, 1
    jz .wait
    in al, 0x60
    test al, 0x80
    jnz .wait
    cmp al, 128
    jae .wait
    xor ah, ah
    mov bx, ax
    mov al, [scancode_table + bx]
    test al, al
    jz .wait
    ret

puts:
    lodsb
    test al, al
    jz .done
    call putc
    jmp puts
.done:
    ret

newline:
    mov al, 10
    call putc
    ret

putc:
    cmp al, 10
    je .newline
    cmp al, 13
    je .done
    cmp al, 8
    je .backspace

    push ax
    push bx
    push es
    mov dl, al
    mov bx, [cursor_pos]
    cmp bx, CELLS
    jb .place
    call clear_screen
    xor bx, bx
.place:
    mov ax, VIDEO_SEG
    mov es, ax
    mov bx, [cursor_pos]
    shl bx, 1
    mov al, dl
    mov ah, ATTR
    mov [es:bx], ax
    inc word [cursor_pos]
    call clamp_cursor
    call update_cursor
    pop es
    pop bx
    pop ax
.done:
    ret

.newline:
    push ax
    push bx
    push dx
    mov ax, [cursor_pos]
    xor dx, dx
    mov bx, COLS
    div bx
    inc ax
    cmp ax, ROWS
    jb .set_row
    call clear_screen
    jmp .nl_out
.set_row:
    mov bx, COLS
    mul bx
    mov [cursor_pos], ax
    call update_cursor
.nl_out:
    pop dx
    pop bx
    pop ax
    ret

.backspace:
    push ax
    push bx
    push es
    cmp word [cursor_pos], 0
    je .bs_out
    dec word [cursor_pos]
    mov ax, VIDEO_SEG
    mov es, ax
    mov bx, [cursor_pos]
    shl bx, 1
    mov word [es:bx], 0x0f20
    call update_cursor
.bs_out:
    pop es
    pop bx
    pop ax
    ret

clear_screen:
    push ax
    push cx
    push di
    push es
    mov ax, VIDEO_SEG
    mov es, ax
    xor di, di
    mov ax, 0x0f20
    mov cx, CELLS
    rep stosw
    mov word [cursor_pos], 0
    call update_cursor
    pop es
    pop di
    pop cx
    pop ax
    ret

clamp_cursor:
    cmp word [cursor_pos], CELLS
    jb .done
    call clear_screen
.done:
    ret

update_cursor:
    push ax
    push bx
    push dx
    mov bx, [cursor_pos]
    mov dx, 0x03d4
    mov al, 0x0f
    out dx, al
    inc dx
    mov al, bl
    out dx, al
    dec dx
    mov al, 0x0e
    out dx, al
    inc dx
    mov al, bh
    out dx, al
    pop dx
    pop bx
    pop ax
    ret

put_hex16:
    push ax
    push bx
    mov bx, ax
    mov al, bh
    call put_hex8
    mov al, bl
    call put_hex8
    pop bx
    pop ax
    ret

put_hex8:
    push ax
    mov ah, al
    shr al, 4
    call put_nibble
    mov al, ah
    and al, 0x0f
    call put_nibble
    pop ax
    ret

put_nibble:
    push bx
    xor bx, bx
    mov bl, al
    mov al, [hex_digits + bx]
    call putc
    pop bx
    ret

pc_beep:
    push ax
    push bx
    push cx
    mov al, 0xb6
    out 0x43, al
    mov ax, 2711
    out 0x42, al
    mov al, ah
    out 0x42, al
    in al, 0x61
    or al, 3
    out 0x61, al
    mov bx, 8
.outer:
    mov cx, 0xffff
.inner:
    loop .inner
    dec bx
    jnz .outer
    in al, 0x61
    and al, 0xfc
    out 0x61, al
    pop cx
    pop bx
    pop ax
    ret

banner db 'BONEBOX-01', 10
       db 'direct screen. direct keys. no host OS.', 10
       db 'type help', 10, 10, 0
prompt_msg db 'bone> ', 0
unknown_msg db 'unknown command', 10, 0
help_msg db 'help cls mem ports peek beep demo law halt', 10, 0
mem_msg db 'boot 0000:7c00  kernel 1000:0000  vga b800:0000', 10, 0
cs_msg db 'cs=', 0
ports_msg db 'ports: 60/64 keyboard, 3d4/3d5 cursor, 40/42/43 PIT, 61 speaker', 10, 0
peek_msg db '0000:7c00 ', 0
beep_msg db 'speaker touched', 10, 0
demo_msg db 'b800 wrote back', 10, 0
law_msg db 'law: no hidden machine; screen is memory; sound is voltage', 10, 0
halt_msg db 'halt', 10, 0

word_help db 'help', 0
word_cls db 'cls', 0
word_mem db 'mem', 0
word_ports db 'ports', 0
word_peek db 'peek', 0
word_beep db 'beep', 0
word_demo db 'demo', 0
word_law db 'law', 0
word_halt db 'halt', 0

hex_digits db '0123456789ABCDEF'

scancode_table:
    db 0, 27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 8, 0
    db 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13, 0, 'a', 's'
    db 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', 39, 96, 0, 92, 'z', 'x', 'c', 'v'
    db 'b', 'n', 'm', ',', '.', '/', 0, '*', 0, ' ', 0, 0, 0, 0, 0, 0
    times 128 - ($ - scancode_table) db 0

cursor_pos dw 0
line_len db 0
line_buf times 64 db 0
