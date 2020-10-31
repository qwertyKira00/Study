"use strict";

// импорт библиотеки
const express = require("express");
const fs = require("fs");


// запускаем сервер
const app = express();
const port = 5003;
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
		const type = obj.type;
		const price = obj.price;

		// Открываем файл и парсим.
		const fileName = "cars.json";
		const objInfo = fs.readFileSync(fileName, "utf-8");
		const infoJson = JSON.parse(objInfo);
		let answer = "Model exists!";

		let flag = true;
		// Ищем модель.
		for (let i in infoJson) {
			if (infoJson[i].type === type) {
				// console.log(infoJson[i]);
				flag = false;
				break;
			}
		}

		// Добавляем в файл информацию,
		// Если такой модели еще нет.
		if (flag) {
			infoJson.push({ type, price })
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
		const type = obj.type;

		// Открываем файл и парсим.
		const fileName = "cars.json";
		const objInfo = fs.readFileSync(fileName, "utf-8");
		const infoJson = JSON.parse(objInfo);

		// Ответ пользователю.
		let answer = "Model does not exist!";

		// Ищем модель.
		for (let i in infoJson) {
			if (infoJson[i].type === type) {
				// console.log(infoJson[i]);
				answer = infoJson[i];
				break;
			}
		}

		response.end(JSON.stringify({ answer: JSON.stringify(answer) }));
	});
});