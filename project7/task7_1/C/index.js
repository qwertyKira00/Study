"use strict";

// импорт библиотек
const express = require("express");
const request = require("request");
const fs = require("fs");

const ENCODING = "utf-8"

// запускаем сервер
const app = express();
const port = 5000;
app.listen(port);
console.log(`Server on port ${port}`);

// Отправка статических файлов.
const way = __dirname + "/static";
app.use(express.static(way));

// заголовки в ответ клиенту
app.use(function (req, res, next) {
	res.header("Cache-Control", "no-cache, no-store, must-revalidate");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	res.header("Access-Control-Allow-Origin", "*");
	next();
});

// функция для отправки POST запроса на другой сервер
function sendPost(url, body, callback) {
	// задаём заголовки
	const headers = {};
	headers["Cache-Control"] = "no-cache, no-store, must-revalidate";
	headers["Connection"] = "close";
	// отправляем запрос
	request.post({
		url: url,
		body: body,
		headers: headers,
	}, function (error, response, body) {
		if (error) {
			callback(null);
		} else {
			callback(body);
		}
	});
}

app.get("/", (_request, response) => {
	const fileContent = fs.readFileSync("static/" + "index.html", ENCODING);
	response.end(fileContent);
});

// принимаем GET запрос и отправляем POST запрос на другой сервер
app.get("/set_info_car/", (request, response) => {
	const type = request.query.field_type_car;
	const price = request.query.field_price_car;

	//Формируем запрос на сервер A
	sendPost("http://localhost:5003/insert/record", JSON.stringify(
		{ type, price }
	), function (answerString) {
		const answerObject = JSON.parse(answerString);
		const answer = answerObject.answer;
		response.end("Answer: " + answer);

		// Либо ту же страницу возвращать.
		// 	const fileContent = fs.readFileSync("static/" + "index.html", ENCODING);
		// response.end(fileContent);
	});
});

app.get("/get_info_car/", (request, response) => {
	const type = request.query.field_type_car_find;

	sendPost("http://localhost:5003/select/record", JSON.stringify(
		{ type }
	), function (answerString) {
		const answerObject = JSON.parse(answerString);
		const answer = answerObject.answer;
		response.end("Answer: " + answer);
	});
});

// принимаем GET запрос и отправляем POST запрос на другой сервер
app.get("/set_info_stock/", (request, response) => {
	const stock_name = request.query.field_stock_name;
	const car_array = request.query.field_car_array;

	sendPost("http://localhost:5002/insert/record", JSON.stringify(
		{ stock_name, car_array }
	), function (answerString) {
		const answerObject = JSON.parse(answerString);
		const answer = answerObject.answer;
		response.end("Answer: " + answer);
	});
});

app.get("/get_info_stock/", (request, response) => {
	const name_stock_find = request.query.field_name_stock_find;

	sendPost("http://localhost:5002/select/record", JSON.stringify(
		{ name_stock_find }
	), function (answerString) {
		const answerObject = JSON.parse(answerString);
		const answer = answerObject.answer;
		response.end("Answer: " + answer);
	});
});