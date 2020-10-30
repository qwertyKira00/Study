//URL: http://localhost:5015/me/page

"use strict";
const path = require("path");
const fs = require("fs");
//Фреймворк Express сам использует модуль http, но вместе с тем предоставляет ряд готовых абстракций,
//которые упрощают создание сервера и серверной логики, в частности, обработка отправленных форм, работа с куками, CORS и т.д.

// подключение express
const express = require("express");

function CreatePage(app, path, file) {
	app.get(path, function (request, response) {
		//const file = request.query.p;
		//console.log(nameString);
		if (fs.existsSync(file)) {
			const contentFile = fs.readFileSync(file, "utf8");
			response.end(contentFile);
		} else {
			const contentFile = fs.readFileSync("bad.html", "utf8");
			response.end(contentFile);
		}
	});
}

function Task1(app) {
	CreatePage(app, "/compare", "compare.html")

	app.get("/compare/numbers", function (request, response) {
		const a = request.query.a;
		const b = request.query.b;
		const c = request.query.c;
		const aInt = parseInt(a);
		const bInt = parseInt(b);
		const cInt = parseInt(c);

		if (!aInt || !bInt || !cInt) {
			response.end("Input error!");
			return;
		}

		let maxInt = cInt;
		if (aInt >= bInt && aInt >= cInt)
			maxInt = aInt;
		else if (bInt >= aInt && bInt >= cInt)
			maxInt = bInt;

		const answerJSON = JSON.stringify({ result: maxInt });
		response.end(answerJSON);
	});
}

function Task2(app) {
	CreatePage(app, "/array", "array.html")

	app.get("/array/objects", (request, response) => {
		const index = request.query.index;
		const indexInt = parseInt(index);

		if (!indexInt) {
			response.end("Input error!");
			return;
		}

		const array = JSON.parse(fs.readFileSync("string.json"));

		if (indexInt < 0 || indexInt > array.length) {
			response.end("Input index error!");
			return;
		}

		response.end("Index = " + indexInt + "\nElement = " + array[indexInt - 1]);
	});
}

function Task3(app) {
	CreatePage(app, "/markup", "markup.html")

	app.get("/markup/generate", (request, response) => {
		const field_names = request.query.fields;
		const address = request.query.address;
		const fields = field_names.split(' ');

		const pathBegin = "start.txt";
		const pathEnd = "end.txt";

		const fileBegin = fs.readFileSync(pathBegin, "utf8")
		const fileEnd = fs.readFileSync(pathEnd, "utf8")

		let fileContent = `<form method="GET" action="${address}">\n`
		for (let i = 0; i < fields.length; i++) {
			fileContent += `
<h2><p>Введите ${fields[i]}</p>\n\
<input name = "${fields[i]}" spellcheck = "false" autocomplete = "off" class="colortextInput">`
		}

		fileContent += '\<br>\n<br>\n<input type = "submit" value = "Отправить" class="colortextSubmit"><h2>\n\
</form >\n'

		response.end(fileBegin + fileContent + fileEnd);
	});
}

function Task4(app) {
	CreatePage(app, "/interval", "interval.html")

	app.get("/interval/res", (request, response) => {
		const a = request.query.a;
		const b = request.query.b;
		const c = request.query.c;
		const aInt = parseInt(a);
		const bInt = parseInt(b);
		const cInt = parseInt(c);

		if (!aInt || !bInt || !cInt) {
			response.end("Input error!");
			return;
		}

		let arr = [];
		for (let i = aInt; i <= bInt; i++)
			if (!(i % cInt))
				arr.push(i)
		if (!arr[0]) {
			response.end("Array is empty");
			return;
		}

		response.end("Array = " + arr);
	});
}


function Main() {
	// создаем объект приложения
	const app = express();
	//Настройка порта
	const port = 5015;
	app.listen(port);
	console.log("My server on port " + port);

	//app.use(express.static(path.join(__dirname, '..', 'public')));
	CreatePage(app, "/me/page", "main.html")

	Task1(app);
	Task2(app);
	Task3(app);
	Task4(app);

}

Main();