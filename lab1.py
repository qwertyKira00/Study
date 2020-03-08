from tkinter import *
from tkinter import messagebox
from math import atan, degrees, fabs, sqrt, acos, pi

rootsize = 700
coords_1 = list()
coords_2 = list()
result = dict()

## Проверка существование треугольника
def triangle_exist(coor_triangle):
    x1 = coor_triangle[0]
    y1 = coor_triangle[1]
    x2 = coor_triangle[2]
    y2 = coor_triangle[3]
    x3 = coor_triangle[4]
    y3 = coor_triangle[5]
    
    A = sqrt((x2-x1)**2+(y2-y1)**2)
    B = sqrt((x3-x1)**2+(y3-y1)**2)
    C = sqrt((x3-x2)**2+(y3-y2)**2)

    if not (A + B > C and A + C > B and B + C > A):
        return False
    return True

def create_root():
    root = Tk()
    root.geometry("1200x705")
    root.title("Лабораторная №1")
    root.resizable(False,False)

    return root
    
def create_canvas(root):
    canvas = Canvas(root, width = 700, height = 700)
    canvas.place(x = 0, y = 0)
    canvas.create_rectangle(0, 0, 800, 800, outline = "", fill = "white")
    
##    for i in range(70):
##        m = i * 25
##        canvas.create_line(m, 0, m, 700, fill = 'grey')
##        canvas.create_line(0, m , 700, m, fill = 'grey')
        
    canvas.create_line(349, 700, 349, 3, width = "3", arrow = LAST)
    canvas.create_line(0, 349, 700, 349, width = "3", arrow = LAST)

    canvas.create_line(690, 360, 700, 370, width = "3")
    canvas.create_line(690, 370, 700, 360, width = "3")

    canvas.create_line(328, 10, 335, 17, width = "3")
    canvas.create_line(339, 10, 328, 25, width = "3")
    
    return canvas

def key_input(var):
    new = var.get()
    check = False
    
    for i in range(len(new)):
        if (not (new[i] in "1234567890-+. ")) or\
           (i > 0 and new[i] in "+-." and new[i-1] in "+-."):
            check = True
            break
        if len(new) == 1 and new[0] == '+':
            break
    if new == "" or new == "-" or\
       not check:
        key_input.old = new
    else:
        var.set(key_input.old)
key_input.old = ""

def create_widgets(root):
    s = StringVar()
    s.trace('w', lambda nm, idx, mode, var=s: key_input(var))
    
    input_points = Entry(root, width = 50, justify = CENTER,
        font = ("Calibri", 20), fg = "green", bd = 4, textvariable = s)
    input_points.place(x = 701, y = 25, width = 499, height = 50)

    label_for_add_points = Label(root, text = "Введите координаты точки(-ек) \
через пробел (x1 y1 x2 y2...):")
    label_for_add_points.place(x = 750, y = 0)
 
    label_for_added_points = Label(root, text = "Ваши добавленные точки:")
    label_for_added_points.place(x = 860, y = 145)

    label_for_answer = Label(root, text = "Ваш ответ:")
    label_for_answer.place(x = 0, y = 710)

    all_points_1 = Listbox(root)
    all_points_1.place(x = 710, y = 165, width = 240, height = 200)

    all_points_2 = Listbox(root)
    all_points_2.place(x = 951, y = 165, width = 240, height = 200)
    
    add_points_1 = Button(root, text = "Добавить введенную(-ые) точку(-и)\n",\
        command = lambda: command_add(input_points,\
        all_points_1, root, 1))
    add_points_1.place(x = 701, y = 78, width = 495, height = 55)
    
    delete_one_point = Button(root, text = "Удалить выбранную точку",\
        command = lambda: command_delete_one(all_points_1, all_points_2, root))
    delete_one_point.place(x = 701, y = 370, width = 499, height = 50)

    change_one_point = Button(root, text = "Изменить выбранную точку",\
        command = lambda: command_change_one(all_points_1, all_points_2, root))
    change_one_point.place(x = 701, y = 420, width = 499, height = 50)

    delete_all_points = Button(root, text = "Удалить все введенные точки",\
        command = lambda: command_delete_all(all_points_1, all_points_2, root))
    delete_all_points.place(x = 701, y = 470, width = 499, height = 50)

    calculate = Button(root, text ="Найти минимальный угол между\n\
    медианой и биссектрисой треугольника,\nпроведенными из одной вершины",\
        command = lambda: solution(root))
    calculate.place(x = 701, y = 520, width = 300, height = 182)

    #return input_points, add_points_1, all_points_1, delete_one_point, change_one_point,\
        #calculate, label_for_answer

def new_input_x_y(var):
    new = var.get()
    check = False
    FindDot = False
    for i in range(len(new)):
        if (not (new[i] in "1234567890-+.")) or\
           (i > 0 and new[i] in "+-." and new[i-1] in "+-.") or\
           (FindDot and new[i] == '.'):
            check = True
            break
        if len(new) == 1 and new[0] == '+':
            break
        if new[i] == '.':
            FindDot = True
        if new[i] in '+-':
            FindDot = False
    if new == "" or new == "-" or\
       not check:
        key_input.old = new
    else:
        var.set(key_input.old)

def command_delete_one(listbox_1, listbox_2, root):
    cur_el = listbox_1.curselection()
    
    if len(cur_el) != 0:
        listbox_1.delete(cur_el[0])
        coords_1.pop(cur_el[0] * 2)
        coords_1.pop(cur_el[0] * 2)
        add_in_listbox_canvas(listbox_1, root, 1)
        return

    cur_el = listbox_2.curselection()
    
    if len(cur_el) != 0:
        listbox_2.delete(cur_el[0])
        coords_2.pop(cur_el[0] * 2)
        coords_2.pop(cur_el[0] * 2)
        add_in_listbox_canvas(listbox_2, root, 2)
        return

    messagebox.showerror("Ошибка", "Вы ничего не выбрали")

def command_change_one(listbox_1, listbox_2, root):
    global coords_2
    global coords_1
    
    cur_el = listbox_1.curselection()
    listbox = listbox_1
    h = 1
    coords = coords_1
    
    if len(cur_el) == 0:
        cur_el = listbox_2.curselection()
        listbox = listbox_2
        coords = coords_2
        h = 2
        
        if len(cur_el) == 0:
            messagebox.showerror("Ошибка", "Вы ничего не выбрали")
            return
        
    old_x = coords[cur_el[0] * 2]
    old_y = coords[cur_el[0] * 2 + 1]
    
    new_root = Tk()
    new_root.geometry("270x150")
    title = "Изменение точки № " + str(cur_el[0] + 1)
    new_root.title(title)
    new_root.resizable(False,False)

    s1 = StringVar(new_root)
    s2 = StringVar(new_root)
    s1.trace('w', lambda nm, idx, mode, var=s1: new_input_x_y(var))
    s2.trace('w', lambda nm, idx, mode, var=s2: new_input_x_y(var))
    
    info_label = Label(new_root, text = "           Новый x        \
              Новый y")
    info_label.place(x = 0, y = 0)
    
    new_x = Entry(new_root, justify = CENTER,
        font = ("Calibri", 20), fg = "green", bd = 4, textvariable = s1)
    new_x.place(x = 10, y = 25, width = 120, height = 50)

    new_y = Entry(new_root, justify = CENTER,
        font = ("Calibri", 20), fg = "green", bd = 4, textvariable = s2)
    new_y.place(x = 140, y = 25, width = 120, height = 50)

    change_coords = Button(new_root, text = "Изменить координаты",\
        command = lambda: command_add_new_coords(new_x, new_y, listbox, root,\
        cur_el[0] * 2, new_root, old_x, old_y, h))
    change_coords.place(x = 10, y = 90, width = 250, height = 50)

def command_add_new_coords(x, y, listbox, root, ind, new_root, old_x, old_y, h):
    global coords_1
    global coords_2
    
    new_x = x.get().strip().split()
    new_y = y.get().strip().split()
    text = ""
    
    if len(new_x) == 0:
        text += "Не введен новый x!\n"

    if len(new_y) == 0:
        text += "Не введен новый y!"

    if text != "":
        messagebox.showerror("Ошибка", text)
        return
    
    try:
        new_x = float(new_x[0])
    except:
        text += "Некорректный новый x!\n"

    try:
        new_y = float(new_y[0])
    except:
        text += "Некорректный новый y!\n"

    if text != "":
        messagebox.showerror("Ошибка", text)
        return
    coords = list()

    if h == 1:
        coords = coords_1
    else:
        coords = coords_2
        
    size = len(coords)
    if len(coords) <= ind:
        messagebox.showerror("Ошибка", "Изменено количество точек")
        new_root.destroy()
        return

    if coords[ind] != old_x or coords[ind + 1] != old_y:
        messagebox.showerror("Ошибка", "Выбранная точка уже была изменена")
        new_root.destroy()
        return
            
    for i in range(0, size, 2):
        if new_x == coords[i] and new_y == coords[i + 1]:
            messagebox.showerror("Ошибка", "Уже есть такая точка!")
            return
    coords[ind] = new_x
    coords[ind + 1] = new_y

    if h == 1:
        coords_1 = coords
    else:
        coords_2 = coords
        
    new_root.destroy()
    add_in_listbox_canvas(listbox, root, h)
    
def command_add(entry, listbox, root, h):
    global coords_1
    #global coords_2
    
    coord = entry.get().strip().split()
    size = len(coord)
    coords = list()
    
    if size == 0:
        messagebox.showerror("Ошибка", "Вы ничего не ввели!")
        return

    for i in range(size):
        try:
            coord[i] = float(coord[i])
        except:
            messagebox.showerror("Ошибка", "Координаты введены с ошибкой!")
            return
        
    if size % 2 != 0:
        messagebox.showerror("Ошибка", "Вы ввели нечетное количество координат!")
        return

    coords = coords_1
    
    size_coords = len(coords)
    size_coord = len(coord)
    
    for j in range(0, size_coord, 2):
        check = True
        for i in range(0, len(coords), 2):
            if coords[i] == coord[j] and coords[i + 1] == coord[j + 1]:
                text = "Точка x = " + str(coords[i]) + " y = " + str(coords[i + 1])\
                       + " уже есть в списке"
                messagebox.showwarning("Предупреждение", text)
                check = False
                break;

        if check:
            coords.append(coord[j])
            coords.append(coord[j + 1])

    if (len(coords) > size_coords):
        coords_1 = coords
        
        entry.delete(0, END)
        add_in_listbox_canvas(listbox, root, h)

    #print(coords_1)
        
def add_in_listbox_canvas(listbox, root, h):
    global canvas
    global result

    scale = 1
    last_scale = 1
    
    canvas.delete("all")
    canvas = create_canvas(root)
    result = dict()
    
    listbox.delete(0, END)

    if h == 1:
        coords = coords_1
    else:
        coords = coords_2
        
    size = len(coords)
    k = 1
    
    if size == 0:
        return

    all_coords = coords_1 + coords_2
    size_coords = len(all_coords)
    max_coord = all_coords[0]

    for i in range(size_coords):
        if fabs(all_coords[i]) > fabs(max_coord):
            max_coord = all_coords[i]

    if max_coord != 0:
        scale = 320 / fabs(max_coord)
    size_1 = len(coords_1)
    size_2 = len(coords_2)

    for i in range(0, size_1, 2):
        canvas.create_oval(349 + scale * coords_1[i] - 3, 349 - scale * coords_1[i + 1] - 3,\
            349 + scale * coords_1[i] + 3, (349 - scale * coords_1[i + 1] + 3), fill = "orange")
        canvas.create_text(349 + scale * coords_1[i] - 3 - 30, 349 - scale * coords_1[i + 1] - 3 + 25,
            text = '(' + str(coords_1[i]) + ',' + str(coords_1[i + 1]) + ')', fill = 'blue')
    
    #for i in range(0, size_2, 2):
        #canvas.create_oval(349 + scale * coords_2[i] - 3, 349 - scale * coords_2[i + 1] - 3,\
            #349 + scale * coords_2[i] + 3, (349 - scale * coords_2[i + 1] + 3), fill = "yellow")
        
    for i in range(0, size, 2):
        listbox.insert(END, "№ " + str(k) + " x = " + '{:.5g}'.format(coords[i]) +\
            " y = " + '{:.5g}'.format(coords[i + 1]))
        k += 1
        
        
def command_delete_all(listbox_1, listbox_2, root):
    global canvas
    global coords_1
    global coords_2
    global result
    
    if len(coords_1) == 0 and len(coords_2) == 0:
        messagebox.showerror("Ошибка", "Нет введенных точек!")
        return
    
    canvas.delete("all")
    canvas = create_canvas(root)
    listbox_1.delete(0, END)
    listbox_2.delete(0, END)
    
    coords_1 = list()
    coords_2 = list()
    result = dict()

def find_angle(cur_triangle):
    global canvas

    Ax = cur_triangle[0]
    Ay = cur_triangle[1]
    Bx = cur_triangle[2]
    By = cur_triangle[3]
    Cx = cur_triangle[4]
    Cy = cur_triangle[5]

    AB = sqrt((Bx-Ax)**2+(By-Ay)**2)
    BC = sqrt((Cx-Bx)**2+(Cy-By)**2)
    AC = sqrt((Cx-Ax)**2+(Cy-Ay)**2)
    
    A_xm = (Bx + Cx) / 2
    A_ym = (By + Cy) / 2
    k = fabs(AB) / fabs(AC)
    A_xb = (Bx + k * Cx) / (1 + k)
    A_yb = (By + k * Cy) / (1 + k)

    try:
        angle1 = acos(((A_xm - Ax) * (A_xb - Ax) + (A_ym - Ay) * (A_yb - Ay)) /
        (sqrt((A_xm - Ax)**2 + (A_ym - Ay)**2) * sqrt((A_xb - Ax)**2 + (A_yb - Ay)**2)))
    except:
        angle1 = 0

    B_xm = (Ax + Cx) / 2
    B_ym = (Ay + Cy) / 2
    k = fabs(AB) / fabs(BC)
    B_xb = (Ax + k * Cx) / (1 + k)
    B_yb = (Ay + k * Cy) / (1 + k)

    try:
        angle2 = acos(((B_xm - Bx) * (B_xb - Bx) + (B_ym - By) * (B_yb - By)) /
        (sqrt((B_xm - Bx)**2 + (B_ym - By)**2) * sqrt((B_xb - Bx)**2 + (B_yb - By)**2)))
    except:
        angle2 = 0

    C_xm = (Ax + Bx) / 2
    C_ym = (Ay + By) / 2
    k = fabs(AC) / fabs(BC)
    C_xb = (Ax + k * Bx) / (1 + k)
    C_yb = (Ay + k * By) / (1 + k)

    try:
        angle3 = acos(((C_xm - Cx) * (C_xb - Cx) + (C_ym - Cy) * (C_yb - Cy)) /
        (sqrt((C_xm - Cx)**2 + (C_ym - Cy)**2) * sqrt((C_xb - Cx)**2 + (C_yb - Cy)**2)))
    except:
        angle3 = 0

    #print(angle1, A_xm, A_ym, A_xb, A_yb)
    #print(angle2, B_xm, B_ym, B_xb, B_yb)
    #print(angle3, C_xm, C_ym, C_xb, C_yb)
    #print('+++')
    
    if angle1 <= angle2 and angle1 <= angle3:
        #print(angle1, A_xm, A_ym, A_xb, A_yb)
        return angle1, A_xm, A_ym, A_xb, A_yb, Ax, Ay
    elif angle2 <= angle1 and angle2 <= angle3:
        #print(angle2, B_xm, B_ym, B_xb, B_yb)
        return angle2, B_xm, B_ym, B_xb, B_yb, Bx, By
    else:
        #print(angle3, C_xm, C_ym, C_xb, C_yb)
        return angle3, C_xm, C_ym, C_xb, C_yb, Cx, Cy

def solution(root):
    global canvas, coords_1

    triangle = list()
    cur_triangle = list()
    size = len(coords_1)
    
    for i in range(0, size, 2):
        for j in range(i + 2, size, 2):
            for k in range(j + 2, size, 2):
                cur_triangle.append(coords_1[i])
                cur_triangle.append(coords_1[i + 1])
                cur_triangle.append(coords_1[j])
                cur_triangle.append(coords_1[j + 1])
                cur_triangle.append(coords_1[k])
                cur_triangle.append(coords_1[k + 1])

                if triangle_exist(cur_triangle):
                    triangle.append(cur_triangle)
                cur_triangle = list()

    count_triangle = len(triangle)
    #print("count", count_triangle)

    if count_triangle < 1:
        messagebox.showerror("Ошибка",\
        "Из введенных коррдинат не получается один и более существующих \
треугольников!")
        return

    res = list()
    for i in range(count_triangle):
        angle, Mx, My, Bx, By, X, Y = find_angle(triangle[i])
        res.append([])
        res[i].append(angle)
        res[i].append(Mx)
        res[i].append(My)
        res[i].append(Bx)
        res[i].append(By)
        res[i].append(X)
        res[i].append(Y)

    min_angle = res[0][0]
    index = 0
    for i in range(1, len(res)):
        if res[i][0] < min_angle:
            min_angle = res[i][0]
            index = i

    #print(res)
    #print(min_angle)
    paint_res(root, res[index], triangle[index], min_angle)

def paint_res(root, res, triangle, min_angle):
    global canvas

    canvas.delete("all")
    canvas = create_canvas(root)

    #print(triangle)

    max_coord = triangle[0]
    for i in range (6):
        if fabs(triangle[i]) > max_coord:
            max_coord = fabs(triangle[i])
    if max_coord != 0:
        scale = 320 / fabs(max_coord)

    for i in range (0, 6, 2):
        canvas.create_oval(349 + scale * triangle[i] - 3, 349 - scale * triangle[i + 1] - 3,\
            349 + scale * triangle[i] + 3, 349 - scale * triangle[i + 1] + 3, fill = 'orange')
        canvas.create_text(349 + scale * triangle[i] - 3 - 30, 349 - scale * triangle[i + 1] - 3 + 25,
            text = '(' + str(triangle[i]) + ',' + str(triangle[i + 1]) + ')', fill = 'blue')

    canvas.create_line(349 + scale * triangle[0] - 1, 349 - scale * triangle[1] - 1,\
        349 + scale * triangle[2] + 1, 349 - scale * triangle[3] + 1, fill = 'black')

    canvas.create_line(349 + scale * triangle[0] - 1, 349 - scale * triangle[1] - 1,\
        349 + scale * triangle[4] + 1, 349 - scale * triangle[5] + 1, fill = 'black')

    canvas.create_line(349 + scale * triangle[2] - 1, 349 - scale * triangle[3] - 1,\
        349 + scale * triangle[4] + 1, 349 - scale * triangle[5] + 1, fill = 'black')
    
    #Медиана
    canvas.create_oval(349 + scale * res[1] - 3, 349 - scale * res[2] - 3,\
            349 + scale * res[1] + 3, 349 - scale * res[2] + 3, fill = 'pink')
    canvas.create_line(349 + scale * res[1] - 1, 349 - scale * res[2] - 1,\
        349 + scale * res[5] + 1, 349 - scale * res[6] + 1, fill = 'pink')

    #Биссектриса
    canvas.create_oval(349 + scale * res[3] - 3, 349 - scale * res[4] - 3,\
            349 + scale * res[3] + 3, 349 - scale * res[4] + 3, fill = 'green')
    canvas.create_line(349 + scale * res[3] - 1, 349 - scale * res[4] - 1,\
        349 + scale * res[5] + 1, 349 - scale * res[6] + 1, fill = 'green')

    
    angle = Label(root, text = 'Угол равен:\n' + str((min_angle * 180) / pi) + 'º', justify = CENTER)
    angle.place(x = 1001, y = 550, width = 200, height = 182)

def main():
    root = create_root()
    
    global canvas
    canvas = create_canvas(root)
    create_widgets(root)
    root.bind('<Escape>', lambda x: root.destroy())
    
    mainloop();

main();
