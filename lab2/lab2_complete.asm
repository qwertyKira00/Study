.586p
;Пропускаем 1Мб памяти, так как там находится данная программа

;Прервания бывают трех видов:
; - Програмнные
; - Внешние(аппаратные)
; - Внутренние(исключения): нарушения, ловушки, аварии

descr struc
    limit   dw 0
    base_l  dw 0
    base_m  db 0
    attr_1  db 0
    attr_2  db 0
    base_h  db 0
descr ends


idescr struc
    offs_l  dw 0
    sel     dw 0
    cntr    db 0
    attr    db 0
    offs_h  dw 0
idescr ends

; СЕЛЕКТОР:
; XXXXXXXX XXXXX YZZ
; XXXXXXXX XXXXX - номер дескриптора сегмента в GDT
; Y - TI (table indicator)
; ZZ - RPL - requested privilege level

stack32 segment  para stack 'STACK'
    stack_start db  100h dup(?)
    stack_size = $-stack_start
stack32 ends

; FLAGS:
; #  7  6     5     4    3              2              1              0
;Атрибуты 1
; 1) P  DPL2  DPL1  S    тип_сегмента3  тип_сегмента2  тип_сегмента1  А
;Атрибуты 2
; 2) G  D     NULL  AVL  limit4         limit3         limit2         limit1

;Бит D(Default, умолчание) определяет действующий по умолчанию размер для операндов и адресов
; (Для сегмента кода) D = 0 => 16-битовые адреса и операнды; D = 1 => 32-битовые
; Атрибут сегмента, действующий по умолчанию, можно изменить на противоположный с помощью
; префиксов замены размера операнда (66h) и замены размера адреса (67h)

data32 segment para 'data'
    gdt_null  descr <>
    ; дескриптор, описывающий сегмент для реального режима (так как в большинстве своем адреса и операнды 16-разрядные, поэтому лучше и описать сегмент как 16-битный)
    gdt_code16 descr <code16_size-1,0,0,98h>
    ; дескриптор для измерения памяти (описывает сегмент размера 4гб и начало которого на 0 байте)
    gdt_data4gb descr <0FFFFh,0,0,92h,0CFh>
    ; дескриптор сегмента кода с 32 битными операциями (там описаны обработчики прерываний в защищенном режиме, код защищенного режима и тп (потому что они используют преимущественно 32 битные операнды))
    gdt_code32 descr <code32_size-1,0,0,98h,40h>
    gdt_data32 descr <data_size-1,0,0,92h,40h>
    gdt_stack32 descr <stack_size-1,0,0,92h,40h>
    gdt_video16 descr <3999,8000h,0Bh,92h> ; 0 + B 0000h + 8000h = 0B8000h

    gdt_size=$-gdt_null
    ; выделяет 6 байт
    pdescr    df 0

;Селекторы (номер/индекс дескриптора в GDT)
    code16s=8
    data4gbs=16
    code32s=24
    data32s=32
    stack32s=40
    video16s=48

;IDT
;Формат шлюзов, входящих в таблицу дескрипторов прерываний
; 7,6                 5           4         3,2         1,0
; Смещение 31...16    Атрибуты    Счетчик   Селектор    Смещение 15...0

;Байт атрибутов:
; 7   6,5   4                 3,2,1,0
; P   DPL   идентификатор(S)  Тип
;Тип:
;4      -   Шлюз вызова 80286
;5      -   Шлюз задачи
;6      -   Шлюз прерываний 80286
;7      -   Шлюз ловушки 80286
;Ch     -   Шлюз вызова 80386, i486, Pentium
;Eh     -   Шлюз прерываний 80386, i486, Pentium
;Fh     -   Шлюз ловушки 80386, i486, Pentium

;Первые 32 номера отведены под исключения (причем реально возникающие исключения
;имеют номера 0...17, а номера 18...31 зарезервированы для будущих процессоров)
;Дескрипторы в таблице прерываний должны быть расположены по порядку их векторов.
;Поэтому таблица начинается с 13 одинаковых дескрипторов исключений
;Затем идет дескриптор исключения 13
;А за ним следуют еще 18 одинаковых дескрипторов
                  ;IDT - таблица дескрипторов прерываний
    idt label byte

    idescr_0_12 idescr 13 dup (<0,code32s,0,8Fh,0>)  ; 8Fh(присутствие, DPL = 0, шлюз ловушки 80386 и выше)
    ; просто для более простого обращения (там просто еще есть код ошибки)
    idescr_13 idescr <0,code32s,0,8Fh,0>
    idescr_14_31 idescr 18 dup (<0,code32s,0,8Fh,0>)

;На 32 векторе описан дескриптор аппаратного прерывания от таймера
    int08 idescr <0,code32s,0,10001110b,0>          ;1110 = Eh => Шлюз прерываний
;На 33 векторе описан дескриптор аппаратного прерывания от клавиатуры
    int09 idescr <0,code32s,0,10001110b,0>

    idt_size=$-idt

    ; interruption psevdo descriptor
    ipdescr df 0
    ; дескриптор таблицы прерываний для реального режима (адрес = 0; размер - 3FF + 1 = 400h, то есть 1024 байта, то есть первый килобайт)
    ipdescr16 dw 3FFh, 0, 0

    mask_master db 0
    mask_slave  db 0

    asciimap   db 0, 0, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 45, 61, 0, 0
    db 81, 87, 69, 82, 84, 89, 85, 73, 79, 80, 91, 93, 0, 0, 65, 83
    db 68, 70, 71, 72, 74, 75, 76, 59, 39, 96, 0, 92, 90, 88, 67
    db 86, 66, 78, 77, 44, 46, 47

    flag_enter_pr db 0
    time_08       db 0 ;Счетчик прерываний
    mark_08       dw 1600 ;Позиция для вывода из new_08

    syml_pos      dd 2 * 80 * 5

    mem_pos=30*2
    ; позиция на экране значения кол-ва доступной памяти (имеется ввиду то, что после `Memory:`)
    mem_value_pos=36*2
    mb_pos=45*2
    param=1Ch

    rm_msg      db 27, '[31;42m Now in Real Mode ', 27, '[0m$'
    pm_msg_wait db 27, '[31;42m Press any key to enter protected mode!', 27, '[0m$'
    pm_msg_out  db 27, '[31;42m Now in Real Mode again! ', 27, '[0m$'
    pm_msg_memory db 'Memory: '

    data_size = $-gdt_null
data32 ends

;Сегмент кода для защищенного режима
code32 segment para public 'code' use32
    assume cs:code32, ds:data32, ss:stack32

pm_start:
    mov ax, data32s
    mov ds, ax
    mov ax, video16s
    mov es, ax
    mov ax, stack32s
    mov ss, ax
    mov eax, stack_size
    mov esp, eax

    sti

    mov di, mem_pos
    mov ah, param

; Вывод сообщения "Memory: "

    xor ecx, ecx
    xor esi, esi
    mov ecx, 8

    print_pm_msg_memory:
        mov al, pm_msg_memory[esi]
        stosw   ; al (символ) с параметром (ah) перемещается в область памяти es:di
        inc esi
        loop print_pm_msg_memory

    call count_memory

    ; Цикл, пока не будет введен Enter (флаг flag_enter_pr выставляется в функции-обработчике нажатия с клавиатуры при нажатии Enter'a)
    proccess:
        test flag_enter_pr, 1 ; если flag = 1, то выход
        jz  proccess

    ; Выход из защищенного режима
    ;Запрет маскируемых прерываний
    cli

    db  0EAh ; jmp
    dd  offset return_rm ; offset
    dw  code16s ; selector


    except_1 proc
        iret
    except_1 endp

;
    except_13 proc uses eax
        pop eax
        iret
    except_13 endp


    new_int08 proc uses eax ebx
        mov edi, 160 + 60    ;Смещение(позиция) курсора в видеопамяти
        mov al, 21h     ;Символ "!" (байт символа)
        mov ah, 75h     ;Цвет       (байт атрибута)
        shl ah, 1
        stosw           ;al (символ) с параметром (ah) перемещается в область памяти es:di

        mov al, 20h         ;EOI ведомого контроллера
        out 20h, al

;Поскольку в защищенном режиме аппаратное прерывание смещает стек не на три слова,
;как в реальном режиме, а на 6, обработчики прерываний должны заканчиваться
;"длинной" командой iret, которая снимет со стека три двойных слова.
        iretd   ;double - 32-битный iret
    new_int08 endp

    ; uses - сохраняет контекст (push + pop)
    new_int09 proc uses eax ebx edx
;Порт 60h при чтении содержит скан-код последней нажатой клавиши.
        in  al, 60h ; Считывание порта клавиатуры
        cmp al, 1Ch ; Сравнение с Enter'ом
;Переход, если не равно
        jne print_value
;Если Enter, устанавливаем флаг
        or flag_enter_pr, 1
        jmp allow_handle_keyboard

    print_value:
        ; Это условие проверяет, отпущена ли была клавиша (если в al лежит 80h, то клавиша была отпущена)
        cmp al, 80h
;Переход, если больше
        ja allow_handle_keyboard

        xor ah, ah

        xor ebx, ebx
        mov bx, ax

        mov dh, param
        mov dl, asciimap[ebx]
        mov ebx, syml_pos
        mov es:[ebx], dx

        add ebx, 2
        mov syml_pos, ebx

    allow_handle_keyboard:
        ; в рудакове есть пояснение к этим строкам, см. 56 строка в коде статьи "Обработка аппаратных прерываний в защищенном режиме"
        in  al, 61h
        or  al, 80h
        out 61h, al
        and al, 7Fh
        out 61h, al

        ; используется только в аппаратных прерываниях для корректного завершения (разрешаем обработку прерываний с меньшим приоритетом)!!
        mov al, 20h
        out 20h, al

        iretd
    new_int09 endp

    ; В защищенном режиме определить объем доступной физической памяти следующим образом – первый мегабайт пропустить
    ; начиная со второго мегабайта сохранить байт или слово памяти,
    ; записать в этот байт или слово сигнатуру, прочитать сигнатуру и
    ; сравнить с сигнатурой в программе, если сигнатуры совпали,
    ; то это – память. Вывести на экран полученное количество байтов доступной памяти.

    count_memory proc uses ds eax ebx
        mov ax, data4gbs
        mov ds, ax ; На данном этапе в сегментный регистр помещается селектор data4gbs, а в теневой регистр помещается дескриптор gdt_data4gb

        mov ebx,  100001h ; Пропускаем первый МБ, так как в нем располагается программа
        ; (16^5 + 1 = (2^4)^5 + 1 = 2^20 + 1 = 1Мб + 1)
        mov dl,   0AEh    ; Это некоторое значение, с помощью которого мы будем проверять запись

        mov ecx, 0FFEFFFFEh
        ; 0FFEFFFFEh +  100001h = FFFFFFFF = 4Гб

        count:
            mov dh, ds:[ebx] ; ds:[ebx] - линейный адрес вида: 0 + ebx (ebx - счетчик)

            mov ds:[ebx], dl
            cmp ds:[ebx], dl

; Если содержимое ячейки ds:[ebx] не равно dl (0AEh), значит, запись не удалась,
; значит, произошел выход за пределы доступного сегмента (доступной памяти)
; Если не равно, выводим количество памяти на экран
            jne print_memory_counter

            mov ds:[ebx], dh
            inc ebx
        loop count

    print_memory_counter:
        mov eax, ebx
; EAX = количество байт
        xor edx, edx

        mov ebx, 100000h ; 2^20, то есть количество байт в Мб
        div ebx ; делим eax / ebx. Теперь eax содержит количество Мб

        ; change place
        mov ebx, mem_value_pos
        ; функция, которая печатает eax (в котором лежит найденное количествово Мб)
        call print_eax

        ; печать надписи Mb
        mov ah, param
        mov ebx, mb_pos
        mov al, 'M'
        mov es:[ebx], ax

        mov ebx, mb_pos + 2
        mov al, 'b'
        mov es:[ebx], ax
        ret
    count_memory endp

; FFFF FFFF - 4 байта
; FF - 1 байт

;USES - список регистров, значения которых изменяет процедура.
;Ассемблер помещает в начало процедуры набор команд PUSH,
;а перед командой RET - набор команд POP,
;так что значения перечисленных регистров будут восстановлены.

    print_eax proc uses ecx ebx edx

        add ebx, 10h ; сдвигаем ebx на 8 позиций (будем печатать 8 символов)
        mov ecx, 8
        mov dh, param

        print_symbol:
            mov dl, al
            and dl, 0Fh ; AND с 0000 1111 --> остаются последние 4 бита

;Инструкция JL выполняет короткий переход, если первый операнд МЕНЬШЕ второго операнда
            cmp dl, 10
            jl add_zero_sym
            add dl, 'A' - 10
            jmp not_zero_sum

        add_zero_sym:
            add dl, '0'
        not_zero_sum:
            mov es:[ebx], dx
            ror eax, 4 ; убираем последнюю 16ричную цифру eax
            sub ebx, 2 ; переходим к левой ячейки видеопамяти
        loop print_symbol

        ret
    print_eax endp

    code32_size = $-pm_start
code32 ends

;Сегмент кода для реального режима
code16 segment para public 'CODE' use16
assume cs:code16, ds:data32, ss: stack32
start:
    mov ax, data32
    mov ds, ax

    mov ah, 09h
    lea dx, rm_msg
    int 21h

    xor dx, dx
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ah, 09h
    lea dx, pm_msg_wait
    int 21h
    xor dx, dx
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ; Ожидание нажатия кнопки
    mov ah, 10h
    int 16h

    ; Очистка экрана
    mov ax, 3
    int 10h


    xor eax, eax

    ; Записываем линейные адреса в дескрипторы сегментов
    mov ax, code16
    shl eax, 4
    mov word ptr gdt_code16.base_l, ax
    shr eax, 16
    mov byte ptr gdt_code16.base_m, al
    mov byte ptr gdt_code16.base_h, ah

    ; Записываем линейные адреса в дескрипторы сегментов
    mov ax, code32
    shl eax, 4
    mov word ptr gdt_code32.base_l, ax
    shr eax, 16
    mov byte ptr gdt_code32.base_m, al
    mov byte ptr gdt_code32.base_h, ah

    ; Записываем линейные адреса в дескрипторы сегментов
    mov ax, data32
    shl eax, 4
    mov word ptr gdt_data32.base_l, ax
    shr eax, 16
    mov byte ptr gdt_data32.base_m, al
    mov byte ptr gdt_data32.base_h, ah

    ; Записываем линейные адреса в дескрипторы сегментов
    mov ax, stack32
    shl eax, 4
    mov word ptr gdt_stack32.base_l, ax
    shr eax, 16
    mov byte ptr gdt_stack32.base_m, al
    mov byte ptr gdt_stack32.base_h, ah

    ; Получаем адрес сегмента, где лежит глобальная таблица дескрипторов
    mov ax, data32
    ;Сдвиг на полбайта, чтобы получить базовый линейный адрес
    shl eax, 4
    ; Начальный адрес сегмента + смещение gdt_null = линейный адрес GDT
    add eax, offset gdt_null

    ;GDTR - 4-байтный регистр
    ;GDTR - 6-байтный регистр, хранящий 32-разрядный адрес и 16-разрядный размер(по Зубкову, стр 477)
    mov word ptr  pdescr, gdt_size-1
    mov dword ptr pdescr+2, eax
    ; fword - 6 байт
    ; LGDT - привилегированная команда (означает, что нет защиты на данном уровне привилегий)
    lgdt fword ptr pdescr

    mov ax, code32
    mov es, ax

; Загрузка смещений обработчиков прерываний в шлюзы
    lea eax, es:except_1
    mov idescr_0_12.offs_l, ax
    shr eax, 16
    mov idescr_0_12.offs_h, ax

; Обрабатывается отдельно
    lea eax, es:except_13
    mov idescr_13.offs_l, ax
    shr eax, 16
    mov idescr_13.offs_h, ax

    lea eax, es:except_1
    mov idescr_14_31.offs_l, ax
    shr eax, 16
    mov idescr_14_31.offs_h, ax

;Загрузка смещений обработчиков аппаратных прерываний
;от таймера и клавиатуры
    lea eax, es:new_int08
    mov int08.offs_l, ax
    shr eax, 16
    mov int08.offs_h, ax

    lea eax, es:new_int09
    mov int09.offs_l, ax
    shr eax, 16
    mov int09.offs_h, ax

;Загрузка в ax линейного адреса data32
    mov ax, data32
;Сдвиг на полбайта влево, чтобы получить линейный базовый адрес
    shl eax, 4
;Добавление смещения таблицы дескрипторов прерываний IDT
    add eax, offset idt
;Результат: линейный адрес IDT

    mov  word ptr  ipdescr, idt_size-1
    mov  dword ptr ipdescr + 2, eax

    ; сохранение масок (см. сем)
    in  al, 21h
    mov mask_master, al
    in  al, 0A1h
    mov mask_slave, al

    ; перепрограммирование ведущего контроллера (см. сем)
    mov al, 11h
    out 20h, al
    mov al, 32 ; это новый базовый вектор
    out 21h, al
    mov al, 4
    out 21h, al
    mov al, 1
    out 21h, al

;Маска прерывания представляет двоичный код,
;разряды которого поставлены в соответствие источникам запроса прерываний.
    ; Маска для ведущего контроллера
    mov al, 0FCh ; 1111 1100 - разрешаем только IRQ0 И IRQ1
    out 21h, al

    ; Маска для ведомого контроллера (запрещаем прерывания)
    mov al, 0FFh ; 1111 1111 - Запрет на все прерывания
    out 0A1h, al

    ; Открытие линии А20 (если не откроем, то будут битые адреса, будет пропадать 20ый бит)
    in  al, 92h
    or  al, 2
    out 92h, al

    ; Запрет аппаратных прерываний перед изменением IDTR
    ; для предотвращения сбоев при прерываниях (например, при прерывании от таймера, которое происходит 18,2 раза в секунду,
    ; произошло бы отключение процессора (стр 317), так как в реальном режиме процессор
    ; обрабатывал бы все прерывания через новую таблицу IDT, которая предусмотрена для
    ; защищенного режима)

    ;Запрет маскируемых прерываний
    cli
    ; Загружаем адрес и размер IDT в IDTR
    lidt fword ptr ipdescr

    ; Установка бита защищенного режим в управляющем регистре cr0
    ; Теперь в защищенном режиме
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    ;Префикс замены размера операнда позволяет изменить
    ;рязрядность операндов команды, перед которой он был выставлен
    ;В данном случае префикс 66h изменит операнд

    db  66h
    db  0EAh                ;FAR jump на pm_start
    dd  offset pm_start
    dw  code32s


return_rm:
    ; возвращаем флаг pe
    mov eax, cr0
    and al, 0FEh
    mov cr0, eax

    db  0EAh
    dw  offset go
    dw  code16

go:
    ; обновляем все сегментные регистры
    mov ax, data32
    mov ds, ax
    mov ax, code32
    mov es, ax
    mov ax, stack32
    mov ss, ax
    mov ax, stack_size
    mov sp, ax

    ; возвращаем базовый вектор контроллера прерываний
    mov al, 11h
    out 20h, al
    mov al, 8
    out 21h, al
    mov al, 4
    out 21h, al
    mov al, 1
    out 21h, al

    ; восстанавливаем маски контроллеров прерываний
    mov al, mask_master
    out 21h, al
    mov al, mask_slave
    out 0A1h, al

    ; восстанавливаем вектор прерываний (на 1ый кб)
    lidt    fword ptr ipdescr16

    ; закрытие линии A20 (если не закроем, то сможем адресовать еще 64кб памяти (HMA, см. сем))
    in  al, 70h
    and al, 7Fh
    out 70h, al

    sti

    ; Очистка экрана
    mov ax, 3
    int 10h

    mov ah, 09h
    lea dx, pm_msg_out
    int 21h
    xor dx, dx
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ax, 4C00h
    int 21h

    code16_size = $-start
code16 ends

end start



; ПОМЕНЯТЬ КОЛ-ВО ПАМЯТИ В DOSBOX'E:
; файл .dosbox/какой-то-там.conf и в нем установить memsize=<нужный размер в мегабайтах>
