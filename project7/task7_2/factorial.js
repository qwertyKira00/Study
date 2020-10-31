"use strict";

// Функция, которая вычисляет факториал
// Числа, переданного аргументом командной строки.
function factorial() {
	let num = parseInt(process.argv[2]);
	let result = 1;

	for (let i = 1; i <= num; i++)
		result *= i;

	console.log(result);
}

factorial();