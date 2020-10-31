
"use strict";

// импорт библиотеки
const express = require("express");
const fs = require("fs");


// запускаем сервер
const app = express();
const port = 5002;
app.listen(port);
console.log("Server on port " + port);

// заголовки для ответа
app.use(function (req, res, next) {
	res.header("Cache-Control", "no-cache, no-store, must-revalidate");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	res.header("Access-Control-Allow-Origin", "*");
	next();
});

// Загрузка тела.
function loadBody(request, callback) {
	let body = [];
	request.on('data', (chunk) => {
		body.push(chunk);
	}).on('end', () => {
		body = Buffer.concat(body).toString();
		callback(body);
	});
}

// Приём запроса.
app.post("/insert/record", function (request, response) {
	loadBody(request, function (body) {
		// Получаем данные.
		const obj = JSON.parse(body);
		const stock_name = obj.stock_name;
		const car_array_str = obj.car_array;

		// Открываем файл и парсим.
		const fileName = "storage.json";
		const objInfo = fs.readFileSync(fileName, "utf-8");
		const infoJson = JSON.parse(objInfo);
		let answer = "Storage exists!";

		let flag = true;
		// Ищем склад.
		for (let i in infoJson) {
			if (infoJson[i].stock_name === stock_name) {
				// console.log(infoJson[i]);
				flag = false;
				break;
			}
		}

		// Добавляем в файл информацию,
		// Если такой модели еще нет.
		if (flag) {
			let car_array = car_array_str.split(" ");
			infoJson.push({ stock_name, car_array })
			fs.writeFileSync(fileName, JSON.stringify(infoJson, null, 4));
			answer = "Model added";
		}

		response.end(JSON.stringify({ answer: answer }));
	});
});

// Приём запроса.
app.post("/select/record", function (request, response) {
	loadBody(request, function (body) {
		// Получаем данные.
		const obj = JSON.parse(body);
		const name_stock_find = obj.name_stock_find;

		// Открываем файл и парсим.
		const fileName = "storage.json";
		const objInfo = fs.readFileSync(fileName, "utf-8");
		const infoJson = JSON.parse(objInfo);

		// Ответ пользователю.
		let answer = "Model does not exist!";

		// Ищем модель.
		for (let i in infoJson) {
			if (infoJson[i].stock_name === name_stock_find) {
				// console.log(infoJson[i]);
				answer = infoJson[i];
				break;
			}
		}

		response.end(JSON.stringify({ answer: JSON.stringify(answer) }));
	});
});