;По умолчанию команда disassemble выводит инструкции в синтаксисе AT&T, который совпадает с синтаксисом, используемым ассемблером GNU.
;Синтаксис AT&T имеет формат: mnemonic source, destination

;SSE - расширение; усовершенствование FPU
;Регистры SSE называются XMM и наличествуют XMM0-XMM7 для 32-битного Protected Mode и дополнительными XMM8-XMM15 для режима 64-битного Long Mode.
;Все регистры XMM-регистры 128-битные, но максимальный размер данных, над которым можно совершать операции это FP64-числа. 
;Последнее обусловлено предназначением данного расширения – параллельная обработка данных.

;XMM-регистры могут быть разделены на два 64-битных FP64 числа или четыре 32-битные FP32 числа.
;В данном случае SINGLE и DOUBLE обозначают FP32 и FP64 соответственно

hd:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 2f 00 00 	mov    0x2fd9(%rip),%rax        # 3fe8 <__gmon_start__>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	callq  *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	retq   

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 7a 2f 00 00    	pushq  0x2f7a(%rip)        # 3fa0 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	f2 ff 25 7b 2f 00 00 	bnd jmpq *0x2f7b(%rip)        # 3fa8 <_GLOBAL_OFFSET_TABLE_+0x10>
    102d:	0f 1f 00             	nopl   (%rax)
    1030:	f3 0f 1e fa          	endbr64 
    1034:	68 00 00 00 00       	pushq  $0x0
    1039:	f2 e9 e1 ff ff ff    	bnd jmpq 1020 <.plt>
    103f:	90                   	nop
    1040:	f3 0f 1e fa          	endbr64 
    1044:	68 01 00 00 00       	pushq  $0x1
    1049:	f2 e9 d1 ff ff ff    	bnd jmpq 1020 <.plt>
    104f:	90                   	nop
    1050:	f3 0f 1e fa          	endbr64 
    1054:	68 02 00 00 00       	pushq  $0x2
    1059:	f2 e9 c1 ff ff ff    	bnd jmpq 1020 <.plt>
    105f:	90                   	nop
    1060:	f3 0f 1e fa          	endbr64 
    1064:	68 03 00 00 00       	pushq  $0x3
    1069:	f2 e9 b1 ff ff ff    	bnd jmpq 1020 <.plt>
    106f:	90                   	nop
    1070:	f3 0f 1e fa          	endbr64 
    1074:	68 04 00 00 00       	pushq  $0x4
    1079:	f2 e9 a1 ff ff ff    	bnd jmpq 1020 <.plt>
    107f:	90                   	nop

Disassembly of section .plt.got:

0000000000001080 <__cxa_finalize@plt>:
    1080:	f3 0f 1e fa          	endbr64 
    1084:	f2 ff 25 6d 2f 00 00 	bnd jmpq *0x2f6d(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    108b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .plt.sec:

0000000000001090 <puts@plt>:
    1090:	f3 0f 1e fa          	endbr64 
    1094:	f2 ff 25 15 2f 00 00 	bnd jmpq *0x2f15(%rip)        # 3fb0 <puts@GLIBC_2.2.5>
    109b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000010a0 <__stack_chk_fail@plt>:
    10a0:	f3 0f 1e fa          	endbr64 
    10a4:	f2 ff 25 0d 2f 00 00 	bnd jmpq *0x2f0d(%rip)        # 3fb8 <__stack_chk_fail@GLIBC_2.4>
    10ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000010b0 <printf@plt>:
    10b0:	f3 0f 1e fa          	endbr64 
    10b4:	f2 ff 25 05 2f 00 00 	bnd jmpq *0x2f05(%rip)        # 3fc0 <printf@GLIBC_2.2.5>
    10bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000010c0 <__isoc99_scanf@plt>:
    10c0:	f3 0f 1e fa          	endbr64 
    10c4:	f2 ff 25 fd 2e 00 00 	bnd jmpq *0x2efd(%rip)        # 3fc8 <__isoc99_scanf@GLIBC_2.7>
    10cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000000010d0 <sqrt@plt>:
    10d0:	f3 0f 1e fa          	endbr64 
    10d4:	f2 ff 25 f5 2e 00 00 	bnd jmpq *0x2ef5(%rip)        # 3fd0 <sqrt@GLIBC_2.2.5>
    10db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

Disassembly of section .text:

00000000000010e0 <_start>:
    10e0:	f3 0f 1e fa          	endbr64 
    10e4:	31 ed                	xor    %ebp,%ebp
    10e6:	49 89 d1             	mov    %rdx,%r9
    10e9:	5e                   	pop    %rsi
    10ea:	48 89 e2             	mov    %rsp,%rdx
    10ed:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    10f1:	50                   	push   %rax
    10f2:	54                   	push   %rsp
    10f3:	4c 8d 05 a6 03 00 00 	lea    0x3a6(%rip),%r8        # 14a0 <__libc_csu_fini>
    10fa:	48 8d 0d 2f 03 00 00 	lea    0x32f(%rip),%rcx        # 1430 <__libc_csu_init>
    1101:	48 8d 3d 5e 02 00 00 	lea    0x25e(%rip),%rdi        # 1366 <main>
    1108:	ff 15 d2 2e 00 00    	callq  *0x2ed2(%rip)        # 3fe0 <__libc_start_main@GLIBC_2.2.5>
    110e:	f4                   	hlt    
    110f:	90                   	nop

0000000000001110 <deregister_tm_clones>:
    1110:	48 8d 3d f9 2e 00 00 	lea    0x2ef9(%rip),%rdi        # 4010 <__TMC_END__>
    1117:	48 8d 05 f2 2e 00 00 	lea    0x2ef2(%rip),%rax        # 4010 <__TMC_END__>
    111e:	48 39 f8             	cmp    %rdi,%rax
    1121:	74 15                	je     1138 <deregister_tm_clones+0x28>
    1123:	48 8b 05 ae 2e 00 00 	mov    0x2eae(%rip),%rax        # 3fd8 <_ITM_deregisterTMCloneTable>
    112a:	48 85 c0             	test   %rax,%rax
    112d:	74 09                	je     1138 <deregister_tm_clones+0x28>
    112f:	ff e0                	jmpq   *%rax
    1131:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1138:	c3                   	retq   
    1139:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001140 <register_tm_clones>:
    1140:	48 8d 3d c9 2e 00 00 	lea    0x2ec9(%rip),%rdi        # 4010 <__TMC_END__>
    1147:	48 8d 35 c2 2e 00 00 	lea    0x2ec2(%rip),%rsi        # 4010 <__TMC_END__>
    114e:	48 29 fe             	sub    %rdi,%rsi
    1151:	48 89 f0             	mov    %rsi,%rax
    1154:	48 c1 ee 3f          	shr    $0x3f,%rsi
    1158:	48 c1 f8 03          	sar    $0x3,%rax
    115c:	48 01 c6             	add    %rax,%rsi
    115f:	48 d1 fe             	sar    %rsi
    1162:	74 14                	je     1178 <register_tm_clones+0x38>
    1164:	48 8b 05 85 2e 00 00 	mov    0x2e85(%rip),%rax        # 3ff0 <_ITM_registerTMCloneTable>
    116b:	48 85 c0             	test   %rax,%rax
    116e:	74 08                	je     1178 <register_tm_clones+0x38>
    1170:	ff e0                	jmpq   *%rax
    1172:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    1178:	c3                   	retq   
    1179:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000001180 <__do_global_dtors_aux>:
    1180:	f3 0f 1e fa          	endbr64 
    1184:	80 3d 85 2e 00 00 00 	cmpb   $0x0,0x2e85(%rip)        # 4010 <__TMC_END__>
    118b:	75 2b                	jne    11b8 <__do_global_dtors_aux+0x38>
    118d:	55                   	push   %rbp
    118e:	48 83 3d 62 2e 00 00 	cmpq   $0x0,0x2e62(%rip)        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1195:	00 
    1196:	48 89 e5             	mov    %rsp,%rbp
    1199:	74 0c                	je     11a7 <__do_global_dtors_aux+0x27>
    119b:	48 8b 3d 66 2e 00 00 	mov    0x2e66(%rip),%rdi        # 4008 <__dso_handle>
    11a2:	e8 d9 fe ff ff       	callq  1080 <__cxa_finalize@plt>
    11a7:	e8 64 ff ff ff       	callq  1110 <deregister_tm_clones>
    11ac:	c6 05 5d 2e 00 00 01 	movb   $0x1,0x2e5d(%rip)        # 4010 <__TMC_END__>
    11b3:	5d                   	pop    %rbp
    11b4:	c3                   	retq   
    11b5:	0f 1f 00             	nopl   (%rax)
    11b8:	c3                   	retq   
    11b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000011c0 <frame_dummy>:
    11c0:	f3 0f 1e fa          	endbr64 
    11c4:	e9 77 ff ff ff       	jmpq   1140 <register_tm_clones>

00000000000011c9 <solution>:                                            ;Дизассемблирование функции solution
    11c9:	f3 0f 1e fa          	endbr64 
    
    ;%rbp и %rsp — специальные регистры. Регистр %rbp — это указатель базы, который указывает на базу текущего стека, 
    ;а %rsp — указатель стека, который указывает на вершину текущего стека. 
    ;Регистр %rbp всегда имеет большее значение нежели %rsp, потому что стек всегда начинается со старшего адреса памяти и растет в сторону младших адресов. 
    
    11cd:	55                   	push   %rbp
    11ce:	48 89 e5             	mov    %rsp,%rbp
    ;Первые две инструкции называются прологом функции или преамбулой. 
    ;Первым делом записываем старый указатель базы в стек, чтобы сохранить его на будущее. 
    ;Потом копируем значение указателя стека в указатель базы. 
    ;После этого %rbp указывает на базовый сегмент стекового фрейма функции solution.
    
    11d1:	48 83 ec 40          	sub    $0x40,%rsp
    ;Вычитание 0x40 (40 в 16-ричной) из указателя на вершину стека. 
    ;Поскольку стек растет вниз, то вычитание 40 из указателя стека перемещает нас к 
    ;собственно области, где хранится локальная переменная
    
    11d5:	f2 0f 11 45 d8       	movsd  %xmm0,-0x28(%rbp)    ;Копирование пармеметров (a, b, c) в следующие доступные слоты локальных переменных
    11da:	f2 0f 11 4d d0       	movsd  %xmm1,-0x30(%rbp)    ; на 28/30/38 ниже %rbp (указателя на стек)
    11df:	f2 0f 11 55 c8       	movsd  %xmm2,-0x38(%rbp)    ;movsd - MOVE SCALAR(Bottom) DOUBLE. Данные инструкции поддерживают только запись вида XMM-to-MEMORY и MEMORY-to-XMM.
    11e4:	66 0f ef c0          	pxor   %xmm0,%xmm0          
    
    ;UCOMISD - Неупорядоченное скалярное сравнение Double с установкой флагов в EFLAGS
    ;В случае работы со скалярными значениями используется нижний SINGLE или DOUBLE
    ;(т.е. нижние 32 или 64-бита соответственно) XMM-регистров.
    11e8:	66 0f 2e 45 d8       	ucomisd -0x28(%rbp),%xmm0
    11ed:	7a 32                	jp     1221 <solution+0x58> ;solution+88
    11ef:	66 0f ef c0          	pxor   %xmm0,%xmm0
    11f3:	66 0f 2e 45 d8       	ucomisd -0x28(%rbp),%xmm0
    11f8:	75 27                	jne    1221 <solution+0x58>
    11fa:	66 0f ef c0          	pxor   %xmm0,%xmm0
    11fe:	66 0f 2e 45 d0       	ucomisd -0x30(%rbp),%xmm0
    1203:	7a 1c                	jp     1221 <solution+0x58>
    1205:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1209:	66 0f 2e 45 d0       	ucomisd -0x30(%rbp),%xmm0
    120e:	75 11                	jne    1221 <solution+0x58>     ;Если a и b ≠ 0, продолжаем подпрограмму
    1210:	48 8d 3d f9 0d 00 00 	lea    0xdf9(%rip),%rdi        # 2010 <_IO_stdin_used+0x10>
    1217:	e8 74 fe ff ff       	callq  1090 <puts@plt>          ;Иначе выводим сообщение 
    121c:	e9 43 01 00 00       	jmpq   1364 <solution+0x19b>    ;И переходим к завершению подпрограммы
    
    1221:	f2 0f 10 45 d0       	movsd  -0x30(%rbp),%xmm0        ;%xmm0 = b
    1226:	f2 0f 59 c0          	mulsd  %xmm0,%xmm0              ;%xmm0 = b * b
    122a:	f2 0f 10 55 d8       	movsd  -0x28(%rbp),%xmm2        ;%xmm2 = a    
    122f:	f2 0f 10 0d 49 0e 00 	movsd  0xe49(%rip),%xmm1        # 2080 <_IO_stdin_used+0x80>
    1236:	00 
    1237:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1              ;%xmm1 = 4 * a
    123b:	f2 0f 59 4d c8       	mulsd  -0x38(%rbp),%xmm1        ;%xmm1 = 4 * a * c
    1240:	f2 0f 5c c1          	subsd  %xmm1,%xmm0              ;%xmm0 = b * b - 4 * a * c (дискриминант = d)
    1244:	f2 0f 11 45 e0       	movsd  %xmm0,-0x20(%rbp)        ;Кладем вычисленное значение d по адресу %rbp - 20
    1249:	f2 0f 10 45 e0       	movsd  -0x20(%rbp),%xmm0
    124e:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1252:	66 0f 2f c1          	comisd %xmm1,%xmm0              ;Сравнение d с 0
    1256:	0f 86 9d 00 00 00    	jbe    12f9 <solution+0x130>    ;Если d ≤ 0, переходим на 12f9, иначе вычисляем корни
    125c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax         ;Извлекаем d из %rbp - 20 и кладем в %rax
                                                                    ;Первый корень
               ;Для записи из регистра общего назначения в регистр XMM и обратно есть инструкции MOVD и MOVQ
    1260:	66 48 0f 6e c0       	movq   %rax,%xmm0               ;%xmm0 = d
    1265:	e8 66 fe ff ff       	callq  10d0 <sqrt@plt>          ;Извлекаем корень sqrt(d)
    126a:	66 0f 28 c8          	movapd %xmm0,%xmm1              ;%xmm1 = sqrt(d)
    126e:	f2 0f 10 45 d8       	movsd  -0x28(%rbp),%xmm0        ;%xmm0 = a
    1273:	f2 0f 58 c0          	addsd  %xmm0,%xmm0              ;%xmm0 = 2 * a
    1277:	f2 0f 5e c8          	divsd  %xmm0,%xmm1              ;%xmm1 = sqrt(d)/(2 * a)
    127b:	66 0f 28 c1          	movapd %xmm1,%xmm0              ;%xmm0 = %xmm1 = sqrt(d)/(2 * a)
    127f:	f2 0f 5c 45 d0       	subsd  -0x30(%rbp),%xmm0        ;%xmm0 = sqrt(d)/(2 * a) - b
    1284:	f2 0f 11 45 f0       	movsd  %xmm0,-0x10(%rbp)        ;%rbp - 10 =  sqrt(d)/(2 * a) - b
    1289:	f2 0f 10 45 d0       	movsd  -0x30(%rbp),%xmm0        ;%xmm0 = b
    128e:	f3 0f 7e 0d fa 0d 00 	movq   0xdfa(%rip),%xmm1        # 2090 <_IO_stdin_used+0x90>
    1295:	00 
    1296:	66 0f 57 c1          	xorpd  %xmm1,%xmm0              ;%xmm0 = -b
    129a:	f2 0f 11 45 c0       	movsd  %xmm0,-0x40(%rbp)        ;%rbp - 40 = -b
    129f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax         ;Извлекаем d из %rbp - 20 и кладем в %rax
                                                                    ;Аналогичные опреации для второго корня
    12a3:	66 48 0f 6e c0       	movq   %rax,%xmm0               ;%xmm0 = d             
    12a8:	e8 23 fe ff ff       	callq  10d0 <sqrt@plt>          ;Извлекаем корень sqrt(d)
    12ad:	66 0f 28 c8          	movapd %xmm0,%xmm1              ;%xmm1 = sqrt(d)
    12b1:	f2 0f 10 45 d8       	movsd  -0x28(%rbp),%xmm0        ;%xmm0 = a
    12b6:	f2 0f 58 c0          	addsd  %xmm0,%xmm0              ;%xmm0 = 2 * a
    12ba:	f2 0f 5e c8          	divsd  %xmm0,%xmm1              ;%xmm1 = sqrt(d)/(2 * a)
    12be:	66 0f 28 c1          	movapd %xmm1,%xmm0              ;%xmm0 = %xmm1 = sqrt(d)/(2 * a)             
    12c2:	f2 0f 10 5d c0       	movsd  -0x40(%rbp),%xmm3        ;%xmm3 = -b
    12c7:	f2 0f 5c d8          	subsd  %xmm0,%xmm3              ;%xmm3 = -b - sqrt(d)/(2 * a)
    12cb:	66 0f 28 c3          	movapd %xmm3,%xmm0              ;%xmm0 = -b - sqrt(d)/(2 * a)
    12cf:	f2 0f 11 45 f8       	movsd  %xmm0,-0x8(%rbp)         ;Кладем значение корня -b - sqrt(d)/(2 * a) по адресу %rbp - 8
    12d4:	f2 0f 10 45 f8       	movsd  -0x8(%rbp),%xmm0         
    12d9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax         ;%rax = %rbp - 10 = sqrt(d)/(2 * a) - b (первый корень)
    
    12dd:	66 0f 28 c8          	movapd %xmm0,%xmm1              ;%xmm1 = %xmm0 = -b - sqrt(d)/(2 * a) (второй корень)
    12e1:	66 48 0f 6e c0       	movq   %rax,%xmm0               ;%xmm0 =  sqrt(d)/(2 * a) - b (первый корень)
    
    12e6:	48 8d 3d 30 0d 00 00 	lea    0xd30(%rip),%rdi        # 201d <_IO_stdin_used+0x1d>
    12ed:	b8 02 00 00 00       	mov    $0x2,%eax
    12f2:	e8 b9 fd ff ff       	callq  10b0 <printf@plt>        ;Функция printf (выводим корни)
    12f7:	eb 6b                	jmp    1364 <solution+0x19b>    ;И переходим к завершению подпрограммы
    
    12f9:	66 0f ef c0          	pxor   %xmm0,%xmm0              ;Обнуляем %xmm0
    12fd:	66 0f 2e 45 e0       	ucomisd -0x20(%rbp),%xmm0       ;Сравниваем d c 0
    1302:	7a 4e                	jp     1352 <solution+0x189>    
    1304:	66 0f ef c0          	pxor   %xmm0,%xmm0              
    1308:	66 0f 2e 45 e0       	ucomisd -0x20(%rbp),%xmm0
    130d:	75 43                	jne    1352 <solution+0x189>    ;Если d ≠ 0, переходим к выводу сообщения о том, что корней нет; Иначе вычисляем корень
    130f:	f2 0f 10 45 d0       	movsd  -0x30(%rbp),%xmm0        ;%xmm0 = b
    1314:	f3 0f 7e 0d 74 0d 00 	movq   0xd74(%rip),%xmm1        # 2090 <_IO_stdin_used+0x90>
    131b:	00 
    131c:	66 0f 57 c8          	xorpd  %xmm0,%xmm1              ;%xmm1 = -b
    1320:	f2 0f 10 45 d8       	movsd  -0x28(%rbp),%xmm0        ;%xmm0 = a
    1325:	f2 0f 58 c0          	addsd  %xmm0,%xmm0              ;%xmm0 = 2 * a
    1329:	f2 0f 5e c8          	divsd  %xmm0,%xmm1              ;%xmm1 = -b / (2 * a)
    132d:	66 0f 28 c1          	movapd %xmm1,%xmm0              ;%xmm0 = %xmm1 = -b / (2 * a)
    1331:	f2 0f 11 45 e8       	movsd  %xmm0,-0x18(%rbp)        ;%rbp - 18 = -b / (2 * a)
    1336:	48 8b 45 e8          	mov    -0x18(%rbp),%rax         ;Кладем корень -b / (2 * a) в %rax
    133a:	66 48 0f 6e c0       	movq   %rax,%xmm0               ;%xmm0 = -b / (2 * a)
    133f:	48 8d 3d ea 0c 00 00 	lea    0xcea(%rip),%rdi        # 2030 <_IO_stdin_used+0x30>
    1346:	b8 01 00 00 00       	mov    $0x1,%eax
    134b:	e8 60 fd ff ff       	callq  10b0 <printf@plt>        ;Функция printf (выводим корень) 
    1350:	eb 12                	jmp    1364 <solution+0x19b>    ;И переходим к завершению подпрограммы
    1352:	48 8d 3d b7 0c 00 00 	lea    0xcb7(%rip),%rdi        # 2010 <_IO_stdin_used+0x10>
    ;Соглашение о вызовах архитектуры x86 гласит, что возвращаемые функцией значения хранятся в регистре %eax
    1359:	b8 00 00 00 00       	mov    $0x0,%eax                ;Кладем в регистр %eax 0 (предписание вернуть нуль при завершении функции)             
    135e:	e8 4d fd ff ff       	callq  10b0 <printf@plt>        ;Функция printf (сообщение о том, что корней НЕТ) 
    1363:	90                   	nop                             ;Ничего не делает, т.е. ничего не возвращает
    1364:	c9                   	leaveq                          ;Скопировать RBP на RSP и затем восстановить старый RBP из стека.
    1365:	c3                   	retq   

0000000000001366 <main>:
    1366:	f3 0f 1e fa          	endbr64 
    136a:	55                   	push   %rbp
    136b:	48 89 e5             	mov    %rsp,%rbp
    136e:	48 83 ec 20          	sub    $0x20,%rsp
    1372:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    1379:	00 00 
    137b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    137f:	31 c0                	xor    %eax,%eax
    1381:	48 8d 3d b1 0c 00 00 	lea    0xcb1(%rip),%rdi        # 2039 <_IO_stdin_used+0x39>
    1388:	e8 03 fd ff ff       	callq  1090 <puts@plt>
    138d:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
    1391:	48 89 c6             	mov    %rax,%rsi
    1394:	48 8d 3d b3 0c 00 00 	lea    0xcb3(%rip),%rdi        # 204e <_IO_stdin_used+0x4e>
    139b:	b8 00 00 00 00       	mov    $0x0,%eax
    13a0:	e8 1b fd ff ff       	callq  10c0 <__isoc99_scanf@plt>
    13a5:	48 8d 3d a6 0c 00 00 	lea    0xca6(%rip),%rdi        # 2052 <_IO_stdin_used+0x52>
    13ac:	e8 df fc ff ff       	callq  1090 <puts@plt>
    13b1:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
    13b5:	48 89 c6             	mov    %rax,%rsi
    13b8:	48 8d 3d 8f 0c 00 00 	lea    0xc8f(%rip),%rdi        # 204e <_IO_stdin_used+0x4e>
    13bf:	b8 00 00 00 00       	mov    $0x0,%eax
    13c4:	e8 f7 fc ff ff       	callq  10c0 <__isoc99_scanf@plt>
    13c9:	48 8d 3d 97 0c 00 00 	lea    0xc97(%rip),%rdi        # 2067 <_IO_stdin_used+0x67>
    13d0:	e8 bb fc ff ff       	callq  1090 <puts@plt>
    13d5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
    13d9:	48 89 c6             	mov    %rax,%rsi
    13dc:	48 8d 3d 6b 0c 00 00 	lea    0xc6b(%rip),%rdi        # 204e <_IO_stdin_used+0x4e>
    13e3:	b8 00 00 00 00       	mov    $0x0,%eax
    13e8:	e8 d3 fc ff ff       	callq  10c0 <__isoc99_scanf@plt>
    13ed:	f2 0f 10 4d f0       	movsd  -0x10(%rbp),%xmm1
    13f2:	f2 0f 10 45 e8       	movsd  -0x18(%rbp),%xmm0
    13f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13fb:	66 0f 28 d1          	movapd %xmm1,%xmm2
    13ff:	66 0f 28 c8          	movapd %xmm0,%xmm1
    1403:	66 48 0f 6e c0       	movq   %rax,%xmm0
    1408:	e8 bc fd ff ff       	callq  11c9 <solution>
    140d:	b8 00 00 00 00       	mov    $0x0,%eax
    1412:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    1416:	64 48 33 14 25 28 00 	xor    %fs:0x28,%rdx
    141d:	00 00 
    141f:	74 05                	je     1426 <main+0xc0>
    1421:	e8 7a fc ff ff       	callq  10a0 <__stack_chk_fail@plt>
    1426:	c9                   	leaveq 
    1427:	c3                   	retq   
    1428:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    142f:	00 

0000000000001430 <__libc_csu_init>:
    1430:	f3 0f 1e fa          	endbr64 
    1434:	41 57                	push   %r15
    1436:	4c 8d 3d 4b 29 00 00 	lea    0x294b(%rip),%r15        # 3d88 <__frame_dummy_init_array_entry>
    143d:	41 56                	push   %r14
    143f:	49 89 d6             	mov    %rdx,%r14
    1442:	41 55                	push   %r13
    1444:	49 89 f5             	mov    %rsi,%r13
    1447:	41 54                	push   %r12
    1449:	41 89 fc             	mov    %edi,%r12d
    144c:	55                   	push   %rbp
    144d:	48 8d 2d 3c 29 00 00 	lea    0x293c(%rip),%rbp        # 3d90 <__do_global_dtors_aux_fini_array_entry>
    1454:	53                   	push   %rbx
    1455:	4c 29 fd             	sub    %r15,%rbp
    1458:	48 83 ec 08          	sub    $0x8,%rsp
    145c:	e8 9f fb ff ff       	callq  1000 <_init>
    1461:	48 c1 fd 03          	sar    $0x3,%rbp
    1465:	74 1f                	je     1486 <__libc_csu_init+0x56>
    1467:	31 db                	xor    %ebx,%ebx
    1469:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1470:	4c 89 f2             	mov    %r14,%rdx
    1473:	4c 89 ee             	mov    %r13,%rsi
    1476:	44 89 e7             	mov    %r12d,%edi
    1479:	41 ff 14 df          	callq  *(%r15,%rbx,8)
    147d:	48 83 c3 01          	add    $0x1,%rbx
    1481:	48 39 dd             	cmp    %rbx,%rbp
    1484:	75 ea                	jne    1470 <__libc_csu_init+0x40>
    1486:	48 83 c4 08          	add    $0x8,%rsp
    148a:	5b                   	pop    %rbx
    148b:	5d                   	pop    %rbp
    148c:	41 5c                	pop    %r12
    148e:	41 5d                	pop    %r13
    1490:	41 5e                	pop    %r14
    1492:	41 5f                	pop    %r15
    1494:	c3                   	retq   
    1495:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    149c:	00 00 00 00 

00000000000014a0 <__libc_csu_fini>:
    14a0:	f3 0f 1e fa          	endbr64 
    14a4:	c3                   	retq   

Disassembly of section .fini:

00000000000014a8 <_fini>:
    14a8:	f3 0f 1e fa          	endbr64 
    14ac:	48 83 ec 08          	sub    $0x8,%rsp
    14b0:	48 83 c4 08          	add    $0x8,%rsp
    14b4:	c3                   	retq   
