//Написать скрипт, который принимает на вход число и считает его факториал.
//Скрипт должен получать параметр через process.argv.

//Написать скрипт, который принимает на вход массив чисел и выводит на экран факториал каждого числа из массива.
//Скрипт принимает параметры через process.argv.

//При решении задачи вызывать скрипт вычисления факториала через execSync.

"use strict";

// Запуск:
// npm start 5 6 7 8 9

//В Node js дочерние процессы создаются для выполнения ресурсоемких операций, 
//которые во время выполнения блокируют цикл событий основного процесса.
//Создаваемые дочерние процессы полностью независимы от родительского процесса 
//и имеют свои собственные экземпляры V8 и выделенные мощности процессора и объем памяти.

// импортируем библиотеку для работы с процессами
const execSync = require('child_process').execSync;

// Начиная со второго аргумента
// Идут наши параметры (ранее пути идут)
const MY_ARG = 2
const OPTIONS = { encoding: 'utf8' };

// Функция, для считывания аргументов
// Переданных в командной строке.
function readArgv(array) {
	let i = MY_ARG;

	while (process.argv[i])
		array.push(parseInt(process.argv[i++]));

	return array;
}

// Функция, вызывающая дочерний процесс
// Для каждого элемента из массива array.
// Дочерний процесс в свою очередь
// Считает факториал числа.
function arrayFactorial(array) {
	let cmd;

	for (let i in array) {
		cmd = `node factorial ${array[i]}`
		console.log(execSync(cmd, OPTIONS))
	}
}


function main() {
	let array = [];
	readArgv(array);
	arrayFactorial(array);
}

main();