"use strict";
const fs = require("fs");
//Фреймворк Express сам использует модуль http, но вместе с тем предоставляет ряд готовых абстракций,
//которые упрощают создание сервера и серверной логики, в частности, обработка отправленных форм, работа с куками, CORS и т.д.

// подключение express
const express = require("express");

//В отличие от GET - запросов данные POST - запросов передаются не в строке запроса, а в его теле.
//Распространенным примеров подобных запросов является отправка данных формы на сервер.
//Для отправки POST - запросов предназначен метод post.
//Его объявление и использование в целом аналогично методу get.Он принимает следующие параметры:
//url: обязательный параметр, содержащий адрес ресурса, к которому будет обращаться запрос
//data: необязательный параметр, содержащий простой объект javascript или строку, которые будут отправлены на сервер вместе с запросом
//success(data, textStatus, jqXHR): необязательный параметр - функция обратного вызова, которая будет выполняться при успешном выполнении запроса.Она может принимать три параметра: data - данные, полученные с сервера, textStatus - - статус запроса и jqXHR - специальный объект jQuery, который представляет расширенный вариант объекта XMLHttpRequest.
//dataType: необязательный параметр, содержащий тип данных в виде строки, например, "xml" или "json"
//На выходе метод post возвращает объект jqXHR.


function Main() {
	// создаем объект приложения
	const app = express();
	//Настройка порта
	const port = 5000;
	app.listen(port);
	console.log("My server on port " + port);

	// отправка статических файлов
	const way = __dirname + "/static";
	app.use(express.static(way));

	// заголовки в ответ клиенту
	app.use(function (req, res, next) {
		res.header("Cache-Control", "no-cache, no-store, must-revalidate");
		res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
		res.header("Access-Control-Allow-Origin", "*");
		next();
	});

	app.get("/find", function (request, response) {
		const mail = request.query.mail;

		//Открытие файла contacts.json
		const file = fs.readFileSync("contacts.json", "utf-8");
		const fileContent = JSON.parse(file);
		let result = "Не найдено";

		//Проверка на наличие
		for (let i in fileContent) {
			if (mail == fileContent[i].mail) {
				result = fileContent[i];
				break;
			}
		}

		response.end(JSON.stringify({
			result: JSON.stringify(result)
		}));
	});

	app.get("/get_info", (_request, response) => {
		const fileContent = fs.readFileSync("static/" + "get_info.html", "utf-8");
		response.end(fileContent);
	});


	//В этом коде идёт описание функции загрузки тела POST запроса
	function loadBody(request, callback) {
		let body = [];
		request.on('data', (chunk) => {
			body.push(chunk);
		}).on('end', () => {
			body = Buffer.concat(body).toString();
			callback(body);
		});
	}

	// it is post
	app.post("/save/info", function (request, response) {
		loadBody(request, function (body) {

			const obj = JSON.parse(body);
			const mail = obj["mail"];
			const lastname = obj["lastname"];
			const number = obj["number"];

			const file = fs.readFileSync("contacts.json", "utf-8");
			const fileContent = JSON.parse(file);
			let unique = true;
			let message = "";

			// Проверка на уникальность.
			for (let i in fileContent) {
				if (mail == fileContent[i].mail) {
					unique = false;
					message = "Почта уже зарегистрирована"
					break;
				}
				if (number == fileContent[i].number) {
					unique = false;
					message = "Номер уже зарегистрирован"
					break;
				}
			}

			if (unique) {
				fileContent.push({ mail, lastname, number })
				fs.writeFileSync("contacts.json", JSON.stringify(fileContent, null, 4));
				message = "Прльзователь добавлен"
			}

			// Ответ запроса.
			response.end(JSON.stringify({
				result: message
			}));
		});
	});
}


Main();