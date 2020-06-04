//По умолчанию команда disassemble выводит инструкции в синтаксисе AT&T, который совпадает с синтаксисом, используемым ассемблером GNU.
//Синтаксис AT&T имеет формат: mnemonic source, destination

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
    10f3:	4c 8d 05 86 03 00 00 	lea    0x386(%rip),%r8        # 1480 <__libc_csu_fini>
    10fa:	48 8d 0d 0f 03 00 00 	lea    0x30f(%rip),%rcx        # 1410 <__libc_csu_init>
    1101:	48 8d 3d c1 00 00 00 	lea    0xc1(%rip),%rdi        # 11c9 <main>
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

00000000000011c9 <main>:                                            //Дизассемблирование функции main
    11c9:	f3 0f 1e fa          	endbr64
    //%rbp и %rsp — специальные регистры. Регистр %rbp — это указатель базы, который указывает на базу текущего стека, 
    //а %rsp — указатель стека, который указывает на вершину текущего стека. 
    //Регистр %rbp всегда имеет большее значение нежели %rsp, потому что стек всегда начинается со старшего адреса памяти и растет в сторону младших адресов. 
    
    11cd:	55                   	push   %rbp                     
    11ce:	48 89 e5             	mov    %rsp,%rbp
    
    //Первые две инструкции называются прологом функции или преамбулой. 
    //Первым делом записываем старый указатель базы в стек, чтобы сохранить его на будущее. 
    //Потом копируем значение указателя стека в указатель базы. 
    //После этого %rbp указывает на базовый сегмент стекового фрейма функции main.

    11d1:	48 83 ec 50          	sub    $0x50,%rsp
    11d5:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    11dc:	00 00 
    11de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    11e2:	31 c0                	xor    %eax,%eax
    11e4:	48 8d 3d 25 0e 00 00 	lea    0xe25(%rip),%rdi        # 2010 <_IO_stdin_used+0x10>
    11eb:	e8 a0 fe ff ff       	callq  1090 <puts@plt>
    11f0:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
    11f4:	48 89 c6             	mov    %rax,%rsi
    11f7:	48 8d 3d 27 0e 00 00 	lea    0xe27(%rip),%rdi        # 2025 <_IO_stdin_used+0x25>
    11fe:	b8 00 00 00 00       	mov    $0x0,%eax
    1203:	e8 b8 fe ff ff       	callq  10c0 <__isoc99_scanf@plt>
    1208:	48 8d 3d 1a 0e 00 00 	lea    0xe1a(%rip),%rdi        # 2029 <_IO_stdin_used+0x29>
    120f:	e8 7c fe ff ff       	callq  1090 <puts@plt>
    1214:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
    1218:	48 89 c6             	mov    %rax,%rsi
    121b:	48 8d 3d 03 0e 00 00 	lea    0xe03(%rip),%rdi        # 2025 <_IO_stdin_used+0x25>
    1222:	b8 00 00 00 00       	mov    $0x0,%eax
    1227:	e8 94 fe ff ff       	callq  10c0 <__isoc99_scanf@plt>
    122c:	48 8d 3d 0b 0e 00 00 	lea    0xe0b(%rip),%rdi        # 203e <_IO_stdin_used+0x3e>
    1233:	e8 58 fe ff ff       	callq  1090 <puts@plt>
    1238:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
    123c:	48 89 c6             	mov    %rax,%rsi
    123f:	48 8d 3d df 0d 00 00 	lea    0xddf(%rip),%rdi        # 2025 <_IO_stdin_used+0x25>
    1246:	b8 00 00 00 00       	mov    $0x0,%eax
    124b:	e8 70 fe ff ff       	callq  10c0 <__isoc99_scanf@plt>
    1250:	f2 0f 10 45 c0       	movsd  -0x40(%rbp),%xmm0
    1255:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1259:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
    125d:	7a 39                	jp     1298 <main+0xcf>
    125f:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1263:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
    1267:	75 2f                	jne    1298 <main+0xcf>
    1269:	f2 0f 10 45 c8       	movsd  -0x38(%rbp),%xmm0
    126e:	66 0f ef c9          	pxor   %xmm1,%xmm1
    1272:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
    1276:	7a 20                	jp     1298 <main+0xcf>
    1278:	66 0f ef c9          	pxor   %xmm1,%xmm1
    127c:	66 0f 2e c1          	ucomisd %xmm1,%xmm0
    1280:	75 16                	jne    1298 <main+0xcf>
    1282:	48 8d 3d ca 0d 00 00 	lea    0xdca(%rip),%rdi        # 2053 <_IO_stdin_used+0x53>
    1289:	e8 02 fe ff ff       	callq  1090 <puts@plt>
    128e:	b8 00 00 00 00       	mov    $0x0,%eax
    1293:	e9 5e 01 00 00       	jmpq   13f6 <main+0x22d>
    1298:	f2 0f 10 4d c8       	movsd  -0x38(%rbp),%xmm1
    129d:	f2 0f 10 45 c8       	movsd  -0x38(%rbp),%xmm0
    12a2:	f2 0f 59 c1          	mulsd  %xmm1,%xmm0
    12a6:	f2 0f 10 55 c0       	movsd  -0x40(%rbp),%xmm2
    12ab:	f2 0f 10 0d cd 0d 00 	movsd  0xdcd(%rip),%xmm1        # 2080 <_IO_stdin_used+0x80>
    12b2:	00 
    12b3:	f2 0f 59 d1          	mulsd  %xmm1,%xmm2
    12b7:	f2 0f 10 4d d0       	movsd  -0x30(%rbp),%xmm1
    12bc:	f2 0f 59 ca          	mulsd  %xmm2,%xmm1
    12c0:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    12c4:	f2 0f 11 45 d8       	movsd  %xmm0,-0x28(%rbp)
    12c9:	f2 0f 10 45 d8       	movsd  -0x28(%rbp),%xmm0
    12ce:	66 0f ef c9          	pxor   %xmm1,%xmm1
    12d2:	66 0f 2f c1          	comisd %xmm1,%xmm0
    12d6:	0f 86 a6 00 00 00    	jbe    1382 <main+0x1b9>
    12dc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    12e0:	66 48 0f 6e c0       	movq   %rax,%xmm0
    12e5:	e8 e6 fd ff ff       	callq  10d0 <sqrt@plt>
    12ea:	66 0f 28 c8          	movapd %xmm0,%xmm1
    12ee:	f2 0f 10 45 c0       	movsd  -0x40(%rbp),%xmm0
    12f3:	f2 0f 58 c0          	addsd  %xmm0,%xmm0
    12f7:	f2 0f 5e c8          	divsd  %xmm0,%xmm1
    12fb:	66 0f 28 c1          	movapd %xmm1,%xmm0
    12ff:	f2 0f 10 4d c8       	movsd  -0x38(%rbp),%xmm1
    1304:	f2 0f 5c c1          	subsd  %xmm1,%xmm0
    1308:	f2 0f 11 45 e8       	movsd  %xmm0,-0x18(%rbp)
    130d:	f2 0f 10 45 c8       	movsd  -0x38(%rbp),%xmm0
    1312:	f3 0f 7e 0d 76 0d 00 	movq   0xd76(%rip),%xmm1        # 2090 <_IO_stdin_used+0x90>
    1319:	00 
    131a:	66 0f 57 c1          	xorpd  %xmm1,%xmm0
    131e:	f2 0f 11 45 b8       	movsd  %xmm0,-0x48(%rbp)
    1323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
    1327:	66 48 0f 6e c0       	movq   %rax,%xmm0
    132c:	e8 9f fd ff ff       	callq  10d0 <sqrt@plt>
    1331:	66 0f 28 c8          	movapd %xmm0,%xmm1
    1335:	f2 0f 10 45 c0       	movsd  -0x40(%rbp),%xmm0
    133a:	f2 0f 58 c0          	addsd  %xmm0,%xmm0
    133e:	f2 0f 5e c8          	divsd  %xmm0,%xmm1
    1342:	66 0f 28 c1          	movapd %xmm1,%xmm0
    1346:	f2 0f 10 5d b8       	movsd  -0x48(%rbp),%xmm3
    134b:	f2 0f 5c d8          	subsd  %xmm0,%xmm3
    134f:	66 0f 28 c3          	movapd %xmm3,%xmm0
    1353:	f2 0f 11 45 f0       	movsd  %xmm0,-0x10(%rbp)
    1358:	f2 0f 10 45 f0       	movsd  -0x10(%rbp),%xmm0
    135d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
    1361:	66 0f 28 c8          	movapd %xmm0,%xmm1
    1365:	66 48 0f 6e c0       	movq   %rax,%xmm0
    136a:	48 8d 3d ef 0c 00 00 	lea    0xcef(%rip),%rdi        # 2060 <_IO_stdin_used+0x60>
    1371:	b8 02 00 00 00       	mov    $0x2,%eax
    1376:	e8 35 fd ff ff       	callq  10b0 <printf@plt>
    137b:	b8 00 00 00 00       	mov    $0x0,%eax
    1380:	eb 74                	jmp    13f6 <main+0x22d>
    1382:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1386:	66 0f 2e 45 d8       	ucomisd -0x28(%rbp),%xmm0
    138b:	7a 53                	jp     13e0 <main+0x217>
    138d:	66 0f ef c0          	pxor   %xmm0,%xmm0
    1391:	66 0f 2e 45 d8       	ucomisd -0x28(%rbp),%xmm0
    1396:	75 48                	jne    13e0 <main+0x217>
    1398:	f2 0f 10 45 c8       	movsd  -0x38(%rbp),%xmm0
    139d:	f3 0f 7e 0d eb 0c 00 	movq   0xceb(%rip),%xmm1        # 2090 <_IO_stdin_used+0x90>
    13a4:	00 
    13a5:	66 0f 57 c8          	xorpd  %xmm0,%xmm1
    13a9:	f2 0f 10 45 c0       	movsd  -0x40(%rbp),%xmm0
    13ae:	f2 0f 58 c0          	addsd  %xmm0,%xmm0
    13b2:	f2 0f 5e c8          	divsd  %xmm0,%xmm1
    13b6:	66 0f 28 c1          	movapd %xmm1,%xmm0
    13ba:	f2 0f 11 45 e0       	movsd  %xmm0,-0x20(%rbp)
    13bf:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
    13c3:	66 48 0f 6e c0       	movq   %rax,%xmm0
    13c8:	48 8d 3d a4 0c 00 00 	lea    0xca4(%rip),%rdi        # 2073 <_IO_stdin_used+0x73>
    13cf:	b8 01 00 00 00       	mov    $0x1,%eax
    13d4:	e8 d7 fc ff ff       	callq  10b0 <printf@plt>
    13d9:	b8 00 00 00 00       	mov    $0x0,%eax
    13de:	eb 16                	jmp    13f6 <main+0x22d>
    13e0:	48 8d 3d 6c 0c 00 00 	lea    0xc6c(%rip),%rdi        # 2053 <_IO_stdin_used+0x53>
    13e7:	b8 00 00 00 00       	mov    $0x0,%eax
    13ec:	e8 bf fc ff ff       	callq  10b0 <printf@plt>
    13f1:	b8 00 00 00 00       	mov    $0x0,%eax
    13f6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
    13fa:	64 48 33 14 25 28 00 	xor    %fs:0x28,%rdx
    1401:	00 00 
    1403:	74 05                	je     140a <main+0x241>
    1405:	e8 96 fc ff ff       	callq  10a0 <__stack_chk_fail@plt>
    140a:	c9                   	leaveq 
    140b:	c3                   	retq   
    140c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001410 <__libc_csu_init>:
    1410:	f3 0f 1e fa          	endbr64 
    1414:	41 57                	push   %r15
    1416:	4c 8d 3d 6b 29 00 00 	lea    0x296b(%rip),%r15        # 3d88 <__frame_dummy_init_array_entry>
    141d:	41 56                	push   %r14
    141f:	49 89 d6             	mov    %rdx,%r14
    1422:	41 55                	push   %r13
    1424:	49 89 f5             	mov    %rsi,%r13
    1427:	41 54                	push   %r12
    1429:	41 89 fc             	mov    %edi,%r12d
    142c:	55                   	push   %rbp
    142d:	48 8d 2d 5c 29 00 00 	lea    0x295c(%rip),%rbp        # 3d90 <__do_global_dtors_aux_fini_array_entry>
    1434:	53                   	push   %rbx
    1435:	4c 29 fd             	sub    %r15,%rbp
    1438:	48 83 ec 08          	sub    $0x8,%rsp
    143c:	e8 bf fb ff ff       	callq  1000 <_init>
    1441:	48 c1 fd 03          	sar    $0x3,%rbp
    1445:	74 1f                	je     1466 <__libc_csu_init+0x56>
    1447:	31 db                	xor    %ebx,%ebx
    1449:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    1450:	4c 89 f2             	mov    %r14,%rdx
    1453:	4c 89 ee             	mov    %r13,%rsi
    1456:	44 89 e7             	mov    %r12d,%edi
    1459:	41 ff 14 df          	callq  *(%r15,%rbx,8)
    145d:	48 83 c3 01          	add    $0x1,%rbx
    1461:	48 39 dd             	cmp    %rbx,%rbp
    1464:	75 ea                	jne    1450 <__libc_csu_init+0x40>
    1466:	48 83 c4 08          	add    $0x8,%rsp
    146a:	5b                   	pop    %rbx
    146b:	5d                   	pop    %rbp
    146c:	41 5c                	pop    %r12
    146e:	41 5d                	pop    %r13
    1470:	41 5e                	pop    %r14
    1472:	41 5f                	pop    %r15
    1474:	c3                   	retq   
    1475:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    147c:	00 00 00 00 

0000000000001480 <__libc_csu_fini>:
    1480:	f3 0f 1e fa          	endbr64 
    1484:	c3                   	retq   

Disassembly of section .fini:

0000000000001488 <_fini>:
    1488:	f3 0f 1e fa          	endbr64 
    148c:	48 83 ec 08          	sub    $0x8,%rsp
    1490:	48 83 c4 08          	add    $0x8,%rsp
    1494:	c3                   	retq 
