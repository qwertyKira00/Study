.586P			;Разрешение трансляции всех команд Pentium

; описание структуры дескриптора сегмента
descr struct
  limit dw 0
  base_1 dw 0
  base_m db 0
  attr_1 db 0
  attr_2 db 0
  base_h db 0
descr ENDs

;сегмент данных

;где в коде можно понять, что мы находимся на 0 уровне привилегий?
Если DPL = 0 и мы можем работать с дексриптором, то мы на 0 кольце защиты
data SEGMENT use 16

  ; FLAGS
  ;    7    6    5 4             3             2             1 0
  ; 1) P DPL1 DPL2 S тип_сегмента1 тип_сегмента2 тип_сегмента3 А
  ; 2) G D NULL AVL limit4 limit3 limit2 limit1

  ;G - бит гранулярности (1 - память в страницах по 4 КБ)
  ;DPL - descriptor priviliege level - уровень привилгий дескриптора (уровень привилегий, требуемый для доступа к дескриптору)
  ; тип_сегмента1:
    ;для кода: 0 - чтение запрещено (разрешено только выполнение кода), 1 - чтение разрешено
    ;для данных: 0 - модифицировать запрещено, 1 - модифицировать разрешено
  ;тип_сегмента2:
    ;для кода: 0 - подчиненный, 1 - обычный (?)
    ;для данных: 0 - сегмент данных, 1 - сегмент стека
  ;тип_сегмента3:
    ;для кода: 0 - данные или стек, 1 - код
  A - бит обращения (в начале 0)
  G - бит гранулярности (1 - память в страницах по 4 КБб 0 - в байтах)
  gdt_null descr <0, 0, 0, 0, 0, 0>
  gdt_data descr <data_size-1, 0, 0, 92h, 0, 0> : 1001 0010
  gdt_code descr <code-size-1, 0, 0, 98h, 0, 0> : 1001 1000
  gdt_stack descr <255, 0, 0, 92h, 0, 0>
  gdt_screen descr <3999, 8000h, 0Bh, 92h, 0, 0>
  ;Бит гранулярности = 1, память в страницах, limit = 5F
  ;gdt_data32 descr<0FFFFh, 0, 0, 11010010b, 11001111b, 0>
  gdt_size = $ - gdt_null

  pdescr df 0

  sym db 1
  attr db 1Eh
  msg db 27, '[31;42m    Вернулись в реальный режим!    ', 27, '[0m$' ;(20)

  ;Измеряем размер сегмента (текущая позиция - начальная позиция)
  data_size = $ - gdt_null
data ENDs

text SEGMENT 'code' use16

    assume CS:text, DS:data

main proc
    XOR EAX, EAX
    MOV AX, data
    MOV DS, AX
    SHL EAX, 4                ;Получаем линейный адрес
    MOV EBP, EAX
    MOV BX, offset gdt_data
    MOV [BX].base_1, AX       ;Заполняем дескрипторы линеынйм адресом
    MOV EAX, 16
    MOV [BX].base_m, AL

    XOR EAX, EAX
    MOV AX, CS
    SHL EAX, 4
    MOV BX, offset gdt_code
    MOV [BX].base_1, AX
    MOV EAX, 16
    MOV [BX].base_m, AL

	XOR EAX, EAX
	MOV AX, SS
	SHL EAX, 4
	MOV BX, offset gdt_stack
    MOV [BX].base_1, AX
    MOV EAX, 16
    MOV [BX].base_m, AL

    MOV dword ptr pdescr + 2, EBP         ;
    MOV word ptr pdescr, gdt_size - 1     ;
    ;Загрузить регистр глобальной таблицы дескрипторов GDTR до использвоания в защ.режиме
    lgdt pdescr                           ;

    MOV AX, 40h
    MOV ES, AX
    MOV word ptr ES:[67h], offset return
    MOV ES:[69h], CS
    MOV AL, 0Fh
    OUT 70h, AL
    MOV AL, 0Ah
    OUT 71h, AL
    CLI

    ; сам переход в защищенный режим (мы не можем напрямую обращаться к CR0)
    MOV EAX, CR0
    OR EAX, 1
    MOV CR0, EAX

    ; искусственно сконструированная команда дальнего перехода для смены CS:IP
    db 0EAh
    dw offset continue
    dw 16
    ;JMP 16:offset continue

    ; СЕЛЕКТОР:
    ; XXXXX YZZ
    ; XXXXXXXX XXXXX - номер дескриптора сегмента в GDT
    ; Y - TI (table indicator)
    ; ZZ - RPL - requested privilege level
continue:
    ; Заносим в DS селектор сегмента данных
    MOV AX, 8
    MOV DS, AX

    MOV AX, 24
    MOV SS, AX

    MOV AX, 32
    MOV ES, AX

    MOV DI, 1920
    MOV CX, 80
    MOV AX, word ptr sym

scrn:
	STOSW
    INC AL
    LOOP scrn

    MOV AL, 0FEh
    OUT 64h, AL
	HLT

return:
    MOV AX, data
    MOV DS, AX
    MOV AX, stk
    MOV SS, AX
    MOV SP, 256
    STI

    MOV AH, 09h
    MOV DX, offset msg
    INT 21h
    MOV AX, 4C00h
    INT 21h
    main ENDp
    code_size = $ - main
    text ENDs

    stk SEGMENT stack use16
    db 256 dup('^')
    stk ENDs
    END main
