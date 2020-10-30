//Реализовать программу, в которой происходят следующие действия:
//Происходит вывод целых чисел от 1 до 10 с задержками в 2 секунды.
//После этого происходит вывод от 11 до 20 с задержками в 1 секунду.
//Потом опять происходит вывод чисел от 1 до 10 с задержками в 2 секунды.
//После этого происходит вывод от 11 до 20 с задержками в 1 секунду.
//Это должно происходить циклически.
//Функция setTimeout позволяет выполнить блок кода через заданный промежуток времени

//Task #2.2

"use strict";

function firstSet() {

	let n = 0;
	let interval = setInterval(() => {
		n++;
		let message = "number: " + n;
		console.log(message);
		if (n === 10) {
			clearInterval(interval);
			secondSet();
		}
	}, 500);
}

function secondSet() {

	let n = 10;
	let interval = setInterval(() => {
		n++;
		let message = "number: " + n;
		console.log(message);
		if (n === 20) {
			clearInterval(interval);
			firstSet();
		}
	}, 1000);
}

firstSet();