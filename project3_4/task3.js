//С клавиатуры считывается число N.
//Далее считывается N строк.Необходимо создать массив и сохранять в него строки только с четной длинной.
//Получившийся массив необходимо преобразовать в строку JSON и сохранить в файл.

//Необходимо считать содержимое файла, в котором хранится массив строк в формате JSON.
//Нужно вывести только те строки на экран, в которых содержатся только гласные буквы.

//С клавиатуры считывается строка - название расширения файлов.
//Далее считывается строка - адрес папки.Необходимо перебрать все файлы в папке и вывести содержимое файлов,
//у которых расширение совпадает с введенным расширением.

//Дана вложенная структура файлов и папок.Все файлы имеют раширение "txt".
//Необходимо рекурсивно перебрать вложенную структуру и вывести имена файлов, у которых содержимое не превышает по длине 10 символов.

//С клавиатуры считывается число N. Далее считывается N строк - имена текстовых файлов.
//Необходимо склеить всё содержимое введенных файлов в одну большую строку и сохранить в новый файл.

//Написать код, который позволяет определить максимальный возможный уровень вложенности друг в друга полей в объекте,
//чтобы данный объект можно было преобразовать в строку формата JSON.Ответом является целое число.

//Из файла считывается строка в формате JSON.В этой строке информация об объекте,
//в котором находится большое количество вложенных друг в друга полей.
//Объект представляет из себя дерево.Необходимо рекурсивно обработать дерево и найти максимальную вложенность в дереве.
//Необходимо вывести на экран ветку с максимальной вложенностью.


"use strict";
const readline = require('readline-sync');
const fs = require("fs");

function Task1() {
	const file = "file1.txt";

	const N = readline.question("Enter N: ");
	let array = [];
	let string;

	for (let i = 0; i < N; i++) {
		string = readline.question("Enter string: ");
		if (!(string.length % 2))
			array.push(string);
	}

	const jsonString = JSON.stringify(array, null, 4);
	fs.writeFileSync(file, jsonString);
}

function isVowel(letter) {
	return ['a', 'e', 'i', 'o', 'u'].indexOf(letter.toLowerCase()) !== -1
}

function Task2() {
	const file = "file2.txt";

	const strings = fs.readFileSync(file, "utf-8");
	//С помощью JSON.parse мы получаем объект из строки JSON
	const obj = JSON.parse(strings);

	console.log(strings);
	let count_vowels = 0;

	for (let i = 0; i < obj.length; i++) {
		count_vowels = 0
		for (let j = 0; j < obj[i].length; j++)
			if (isVowel(obj[i][j]))
				count_vowels += 1;
		if (count_vowels === obj[i].length)
			console.log(obj[i]);
	}
}

function Task3() {

	const extension = readline.question("Enter an extension: ");
	const folder = readline.question("Enter the folder's name: ");

	if (!(fs.existsSync(folder))) {
		console.log("\nThe folder does not exist!");
		return;
	}

	let f = fs.readdirSync(folder);
	//console.log(f)

	for (let i = 0; i < f.length; i++) {
		let file = f[i].split('.');
		//console.log(file)
		if (file[1] === extension) {
			let file_text = fs.readFileSync(folder + "/" + f[i], "utf-8");
			console.log(file_text);
		}
	}
}
function Task4() {

	//folder = "nested"
	const folder = readline.question("Enter the folder's name: ");
	Recursion(folder);
}

function Recursion(folder) {

	if (!fs.existsSync(folder)) {
		console.log("\nThe folder does not exist!");
		return;
	}

	let f = fs.readdirSync(folder);
	let file_text;
	//console.log(f)

	for (let i = 0; i < f.length; i++) {
		let file = f[i].split('.');
		if (file[file.length - 1] === "txt") {
			file_text = fs.readFileSync(folder + "/" + f[i], "utf-8");
			if (file_text.length <= 10) {
				console.log("Path: ", folder + "/" + f[i]);
			}
		}
		else {
			//console.log(f[i])
			Recursion(folder + "/" + f[i]);
		}
	}
}

function Task5() {
	const file = "file3.txt";
	fs.writeFileSync(file, "");

	const N = readline.question("Enter N: ");
	//let array = [];
	let f;

	for (let i = 0; i < N; i++) {
		f = readline.question("Enter file name: ");
		if (!fs.existsSync(f)) {
			console.log("\nThe file does not exist!");
			i -= 1;
		}
		else {
			//array.push(f);
			let file_text = fs.readFileSync(f, "utf-8");
			fs.appendFileSync(file, file_text);
		}
	}
}

function Task7() {
	const obj = {};
	obj.x = 17;
	obj.y = -45;
	obj.z = 0;
	obj.data = {};
	obj.data.param1 = 10;
	obj.data.param2 = 20;
	obj.data.extra = {};
	obj.data.extra.param3 = 30;
	obj.data.extra.param4 = 40;

	//С помощью формата JSON.stringify можно представить информацию об объекте в виде строки
	const jsonString = JSON.stringify(obj, null, 4);
	console.log(jsonString);

	//С помощью JSON.parse мы получаем объект из строки JSON
	const obj_copy = JSON.parse(jsonString);
	console.log(obj_copy);

}
//const jsonString = JSON.stringify(swedishFamilyObj, null, 4);
//console.log(jsonString);

function main() {

	const choice = readline.question("Choose the task number: ");
	const functions = [Task1, Task2, Task3, Task4, Task5, Task7];

	if (choice > 7 || choice < 1) {
		console.log("\nWrong option!")
		return;
	}

	functions[choice - 1]();

}

main()