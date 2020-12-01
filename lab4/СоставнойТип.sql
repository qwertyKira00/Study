-- Аргументы составного типа передаются функции в виде сопоставлений Python.
-- Именами элементов сопоставления являются атрибуты составного типа.
-- Если атрибут в переданной строке имеет значение NULL,
-- он передаётся в сопоставлении значением None.
-- Пример работы с составным типом:
CREATE TABLE employee (
  name text,
  salary integer,
  age integer
);

CREATE FUNCTION overpaid (e employee)
  RETURNS boolean
AS $$
  if e["salary"] > 200000:
    return True
  if (e["age"] < 30) and (e["salary"] > 100000):
    return True
  return False
$$ LANGUAGE plpythonu3;

-- Возвратить составной тип или строку таблицы из функции Python
-- можно несколькими способами. В следующих примерах предполагается,
-- что у нас объявлен тип:
CREATE TYPE named_value AS (
  name   text,
  value  integer
);

-- Результат этого типа можно вернуть как:
-- Последовательность (кортеж или список, но не множество,
-- так как оно не индексируется)
-- В возвращаемых объектах последовательностей должно быть столько элементов,
-- сколько полей в составном типе результата.
-- Элемент с индексом 0 присваивается первому полю составного типа,
-- с индексом 1 — второму и т. д. Например:

CREATE FUNCTION make_pair (name text, value integer)
  RETURNS named_value
AS $$
  return [ name, value ]
  # или в виде кортежа: return ( name, value )
$$ LANGUAGE plpythonu3;

-- Информация взята с источника: http://iocsha.ddns.net/news/94/1266/