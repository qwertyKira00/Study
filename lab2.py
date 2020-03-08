from tkinter import *
from math import *
import numpy as np
from tkinter import messagebox as mb

rootsize = 700
a = 100
b = 100
flag = 0
init_list = list()
cord_list = list()
mtr_inv_prev = list()
mtr_inv = list()

def func_x(t):
    return a * cos(t) * (1 + cos(t))
    #return a * (cos(t))**3

def func_y(t):
    return a * sin(t) * (1 + cos(t))
    #return b * (sin(t))**3

def paint_point(x, y):
    r = 1  ##Радиус точки 
    offset = rootsize / 2   ##Смещение относительно верхнего левого угла
    canvas.create_oval(x + offset - r, -y + offset - r, x + offset + r,\
        -y + offset + r , width = 0, fill = "black")

def paint_line(cord1, cord2):
    offset = rootsize / 2   ##Смещение относительно верхнего левого угла
    canvas.create_line(cord1[0] + offset, -cord1[1] + offset,\
        cord2[0] + offset, -cord2[1] + offset,\
        width = 2, fill = "black")

#Обратная матрица
def matrix_inverse():

    mtr_inv.clear()
    mtr_inv_prev.clear()
    
#Отрисовка фигуры
def create_figure():
    canvas.delete("all")
    
    for i in np.arange(0, 2 * pi, 0.09):
        try:
            x = func_x(i) 
            y = func_y(i)  
            cord_list.append([x, y, 1])
            init_list.append([x, y, 1])
            #paint_point(x, y)
        except:
            pass
    cord_list.append([cord_list[0][0] + 90, cord_list[0][1] - 150, 1])
    cord_list.append([cord_list[0][0] - 380, cord_list[0][1] - 150, 1])
    cord_list.append([cord_list[0][0] - 100, cord_list[0][1] + 270, 1])

    init_list.append([cord_list[0][0] + 90, cord_list[0][1] - 150, 1])
    init_list.append([cord_list[0][0] - 380, cord_list[0][1] - 150, 1])
    init_list.append([cord_list[0][0] - 100, cord_list[0][1] + 270, 1])

    print(cord_list[len(cord_list) - 3])
    print(cord_list[len(cord_list) - 2])
    print(cord_list[len(cord_list) - 1])

def paint_figure():
    canvas.delete("all")
    
    for i in range(len(cord_list)):
        paint_point(cord_list[i][0], cord_list[i][1])
    for i in range(1, len(cord_list) - 3):
        paint_line(cord_list[i], cord_list[i - 1])
    paint_line(cord_list[0], cord_list[len(cord_list) - 4])

    paint_line(cord_list[len(cord_list) - 3], cord_list[len(cord_list) - 2])
    paint_line(cord_list[len(cord_list) - 2], cord_list[len(cord_list) - 1])
    paint_line(cord_list[len(cord_list) - 1], cord_list[len(cord_list) - 3])

    canvas.create_line(7, 700, 7, 3, width = "2", arrow = LAST)
    canvas.create_text(24, 15, text = '700',
        justify=CENTER, font='Verdana 14', fill = 'black')
    
def paint_init_figure():
    canvas.delete("all")
    
    for i in range(len(cord_list)):
        paint_point(init_list[i][0], init_list[i][1])
    for i in range(1, len(init_list) - 3):
        paint_line(init_list[i], init_list[i - 1])
    paint_line(init_list[0], init_list[len(init_list) - 4])

    for i in range(len(cord_list)):
        cord_list[i] = init_list[i]

    paint_line(init_list[len(init_list) - 3], init_list[len(init_list) - 2])
    paint_line(init_list[len(init_list) - 2], init_list[len(init_list) - 1])
    paint_line(init_list[len(init_list) - 1], init_list[len(init_list) - 3])

    canvas.create_line(7, 700, 7, 3, width = "2", arrow = LAST)
    canvas.create_text(24, 15, text = '700',
        justify=CENTER, font='Verdana 14', fill = 'black')
    canvas.create_line(5, 695, 700, 695, width = "2", arrow = LAST)
    canvas.create_text(680, 680, text = '700',
        justify=CENTER, font='Verdana 14', fill = 'black')

#Отмена действия
def cancel():
    global flag

    if mtr_inv == mtr_inv_prev:
        flag += 1
    print(mtr_inv == mtr_inv_prev)
    if flag > 1:
        return
    
    if (not mtr_inv):
        mb.showerror("Ошибка", "Нельзя отменить")
        return
    
    for i in range(len(cord_list)):
        cord_list[i] = np.dot(mtr_inv, cord_list[i])

    paint_figure()

def moving_scale_turn(dx, dy):
    mtr_move = [[1, 0, 0],
                [0, 1, 0],
                [dx, dy, 1]]

    for i in range(len(cord_list)):
       cord_list[i] = np.dot(mtr_move, cord_list[i])

def turning():
    offset = input_turn_coords.get().strip().split()

    if len(offset) != 2:
        mb.showerror("Ошибка", "Для поворота должны быть введены\
 два числа: координаты центра поворота")
        return
    try:
        s_x = float(offset[0])
        s_y = float(offset[1])
    except:
        return

    turn_angle = input_angle.get().strip().split()

    if len(turn_angle) != 1:
        mb.showerror("Ошибка", "Для поворота должно быть введено\
 одно число: угол поворота")
        return
    try:
        angle = (float(turn_angle[0]) * pi) / 180
    except:
        return
    
    mtr_move1 = [[1, 0, 0],
                [0, 1, 0],
                [s_x, s_y, 1]]

    mtr_move2 = [[1, 0, 0],
                [0, 1, 0],
                [-s_x, -s_y, 1]]

    mtr_turn = [[cos(angle), sin(angle), 0],
        [-sin(angle), cos(angle), 0],
        [0, 0, 1]]
    
    #Inverse 
    global mtr_inv_prev, flag
    matrix_inverse()

    inv = []
    inv = np.dot(mtr_move1, mtr_turn)
    inv = np.dot(inv, mtr_move2)
    inv = np.linalg.inv(inv)
    for i in range(len(inv)):
        mtr_inv.append([])
        for j in range(len(inv[i])):
            mtr_inv[i].append(inv[i][j])
    flag = 0
    mtr_inv_prev = mtr_inv

    #Turn
    moving_scale_turn(s_x, s_y)
    for i in range(len(cord_list)):
        cord_list[i] = np.dot(mtr_turn, cord_list[i])
    moving_scale_turn(-s_x, -s_y)
    
    paint_figure()

def scaling():
    #print("Введите коэффициенты масштабирования kx и ky, соответственно: ")
    offset = input_scale_coords.get().strip().split()

    if len(offset) != 2:
        mb.showerror("Ошибка", "Для масштабирования должны быть введены\
 два числа: координаты центра масштабирования")
        return

    try:
        s_x = float(offset[0])
        s_y = float(offset[1])
    except:
        return

    cof = input_scale_cof.get().strip().split()

    if len(cof) != 2:
        mb.showerror("Ошибка", "Для масштабирования должны быть введены\
 два числа: коэффициенты масштабирования по x и y")
        return
    
    try:
        kx = float(cof[0])
        ky = float(cof[1])
    except:
        return

    mtr_move1 = [[1, 0, 0],
                [0, 1, 0],
                [s_x, s_y, 1]]

    mtr_move2 = [[1, 0, 0],
                [0, 1, 0],
                [-s_x, -s_y, 1]]
    
    mtr_sc = [[kx, 0, 0],
             [0, ky, 0],
             [0, 0, 1]]

 
    #Inverse 
    global mtr_inv_prev, flag
    matrix_inverse()

    inv = []
    inv = np.dot(mtr_move1, mtr_sc)
    inv = np.dot(inv, mtr_move2)
    try:
        inv = np.linalg.inv(inv)
    except np.linalg.LinAlgError:
        mb.showerror("Ошибка", "Коэффициенты масштабирования равны 0")
        return

    for i in range(len(inv)):
        mtr_inv.append([])
        for j in range(len(inv[i])):
            mtr_inv[i].append(inv[i][j])
    flag = 0
    mtr_inv_prev = mtr_inv
    
    #Scale
    moving_scale_turn(s_x, s_y)
    for i in range(len(cord_list)):
        cord_list[i] = np.dot(mtr_sc, cord_list[i])
    moving_scale_turn(-s_x, -s_y)

    
    paint_figure()

def move():

    offset = input_offset.get().strip().split()

    if len(offset) != 2:
        mb.showerror("Ошибка", "Для перемешения должны быть введены два числа:\
 смещение по x и y")
        return
    try:
        dx = float(offset[0])
        dy = float(offset[1])
    except:
        return

    if dx % 10 != 0 or dy % 10 != 0:
        mb.showerror("Ошибка", "Для перемешения должны быть введены целые числа")
        return
    
    mtr_move = [[1, 0, dx],
                [0, 1, dy],
                [0, 0, 1]]

    #Inverse
    global mtr_inv_prev, flag
    matrix_inverse()
    inv = []
    inv = np.linalg.inv(mtr_move)
    for i in range(len(inv)):
        mtr_inv.append([])
        for j in range(len(inv[i])):
            mtr_inv[i].append(inv[i][j])
    flag = 0
    mtr_inv_prev = mtr_inv

    #Move
    for i in range(len(cord_list)):
       cord_list[i] = np.dot(mtr_move, cord_list[i])

    paint_figure()

def create_root():
    global root

    root = Tk()
    root.geometry("1200x705")
    root.title("Лабораторная №2")
    root.resizable(False,False)

    return root

def create_canvas(root):
    global canvas
    
    canvas = Canvas(root, width = rootsize, height = rootsize)
    canvas.place(x = 0, y = 0)
    canvas.create_rectangle(0, 0, 800, 800, outline = "", fill = "white")
    
##    for i in range(70):
##        m = i * 25
##        canvas.create_line(m, 0, m, 700, fill = 'grey')
##        canvas.create_line(0, m , 700, m, fill = 'grey')
        
    #canvas.create_line(349, 700, 349, 3, width = "2", arrow = LAST)
    #canvas.create_line(0, 349, 700, 349, width = "2", arrow = LAST)

    #canvas.create_line(690, 360, 700, 370, width = "2")
    #canvas.create_line(690, 370, 700, 360, width = "2")

    #canvas.create_line(328, 10, 335, 17, width = "2")
    #canvas.create_line(339, 10, 328, 25, width = "2")

def change(b):
    b['bg'] = 'green'
    b['activebackground'] = '#555555'
    b['fg'] = '#ffffff'
    b['activeforeground'] = '#ffffff'

def create_widgets():
    s = StringVar()
    s.trace('w', lambda nm, idx, mode, var=s: key_input(var))

    global cord_list
    cord_list = list()

    Button_create_figure = Button(root, text = "Изобразить фигуру:",
        justify = CENTER, background ='green',
        command = create_figure)
    Button_create_figure.place(x = 701, y = 25, width = 499, height = 50)

    print(cord_list)
    
    label_move_figure = Label(root, text = "Введите смещение по x и y,\
 соответственно (через пробел):", justify = CENTER)
    label_move_figure.place(x = 750, y = 100)

    input_offset = Entry(root, width = 50, justify = CENTER,
        font = ("Calibri", 20), fg = "green", bd = 4, textvariable = s)
    input_offset.place(x = 701, y = 120, width = 499, height = 50)
    
    Button_move_figure = Button(root, text = "Переместить фигуру:",
        command = move, background='green')
    Button_move_figure.place(x = 701, y = 170, width = 499, height = 50)
    
def key_input1(var):
    new = var.get()
    check = False
    if len(new) == 1:
        key_input1.old = ""    
        
    for i in range(len(new)):
        if (not (new[i] in "1234567890-+. ")) or\
           (i > 0 and new[i] in "+-." and new[i-1] in "+-."):
            check = True
            break
        if len(new) == 1 and new[0] == '+':
            break
    if new == "" or new == "-" or not check:
        key_input1.old = new 
    else:
        var.set(key_input1.old)

def key_input2(var):
    new = var.get()
    check = False
    if len(new) == 1:
        key_input2.old = ""
    
    for i in range(len(new)):
        if (not (new[i] in "1234567890-+. ")) or\
           (i > 0 and new[i] in "+-." and new[i-1] in "+-."):
            check = True
            break
        if len(new) == 1 and new[0] == '+':
            break
    if new == "" or new == "-" or not check:
        key_input2.old = new 
    else:
        var.set(key_input2.old)

def click(event):
    canvas.delete('coord')
    offset = rootsize / 2
    if (event.x > 700):
        canvas.delete('coord')
        return
    canvas.create_text(event.x - 30, event.y,
        text = '(' + str(event.x - offset) + ' ' + str(-event.y + offset) + ')',
        justify=CENTER, font='Verdana 14', fill = 'blue', tag = 'coord')

root = Tk()
root.geometry("1200x700")
root.title("Лабораторная №2")
root.resizable(False,False)

canvas = Canvas(root, width = rootsize, height = rootsize)
canvas.place(x = 0, y = 0)

#Widgets

create_figure()

Button_create_figure = Button(root, text = "Изобразить фигуру:",
    justify = CENTER, background ='green',
    command = paint_init_figure)
Button_create_figure.place(x = 701, y = 25, width = 499, height = 50)

#print(cord_list)

#Moving   
label_move_figure = Label(root, text = "Введите смещение по x и y,\
 соответственно (через пробел):", justify = CENTER)
label_move_figure.place(x = 750, y = 100)

s1 = StringVar()
s1.trace('w', lambda nm, idx, mode, var=s1: key_input2(var))

input_offset = Entry(root, width = 50, justify = CENTER, textvariable = s1,
    font = ("Calibri", 20), fg = "green", bd = 4)
input_offset.place(x = 701, y = 120, width = 499, height = 50)

Button_move_figure = Button(root, text = "Переместить фигуру:",
    command = move, background ='green')
Button_move_figure.place(x = 701, y = 170, width = 499, height = 50)

#Scaling
label_scale_figure = Label(root, text = "Введите координаты центра масштабирования\
 (через пробел):", justify = CENTER)
label_scale_figure.place(x = 750, y = 245)

s2 = StringVar()
s2.trace('w', lambda nm, idx, mode, var=s2: key_input2(var))

input_scale_coords = Entry(root, width = 50, justify = CENTER, textvariable = s2,
    font = ("Calibri", 20), fg = "green", bd = 4)
input_scale_coords.place(x = 701, y = 265, width = 499, height = 50)


label_scale_cof = Label(root, text = "Введите коэффициенты масштабирования kx,ky\
 (через пробел):", justify = CENTER)
label_scale_cof.place(x = 750, y = 315)

s3 = StringVar()
s3.trace('w', lambda nm, idx, mode, var=s3: key_input2(var))

input_scale_cof = Entry(root, width = 50, justify = CENTER, textvariable = s3,
    font = ("Calibri", 20), fg = "green", bd = 4)
input_scale_cof.place(x = 701, y = 335, width = 499, height = 50)


Button_move_figure = Button(root, text = "Масштабировать фигуру:",
    command = scaling, background ='green')
Button_move_figure.place(x = 701, y = 385, width = 499, height = 50)

#Turning
label_turn_figure = Label(root, text = "Введите координаты центра поворота\
 (через пробел):", justify = CENTER)
label_turn_figure.place(x = 750, y = 455)

s4 = StringVar()
s4.trace('w', lambda nm, idx, mode, var=s4: key_input2(var))

input_turn_coords = Entry(root, width = 50, justify = CENTER, textvariable = s4,
    font = ("Calibri", 20), fg = "green", bd = 4)
input_turn_coords.place(x = 701, y = 475, width = 499, height = 50)

label_turn_figure = Label(root, text = "                 Введите угол поворота:", justify = CENTER)
label_turn_figure.place(x = 750, y = 525)

s5 = StringVar()
s5.trace('w', lambda nm, idx, mode, var=s5: key_input1(var))

input_angle = Entry(root, width = 50, justify = CENTER, textvariable = s5,
    font = ("Calibri", 20), fg = "green", bd = 4)
input_angle.place(x = 701, y = 545, width = 499, height = 50)

Button_move_figure = Button(root, text = "Повернуть фигуру:",
    command = turning, background ='green')
Button_move_figure.place(x = 701, y = 595, width = 499, height = 50)

Button_move_figure = Button(root, text = "Отменить (на один шаг назад):",
    command = cancel, background ='green')
Button_move_figure.place(x = 701, y = 645, width = 499, height = 30)

    
root.bind('<Escape>', lambda x: root.destroy())
root.bind('<1>', click)

mainloop()
