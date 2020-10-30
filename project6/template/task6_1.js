//Создать сервер.В оперативной памяти на стороне сервера создать массив,
//в котором хранится информация о компьютерных играх(название игры, описание игры, возрастные ограничения).
//Создать страницу с помощью шаблонизатора.В url передаётся параметр возраст(целое число).
//Необходимо отображать на этой странице только те игры, у которых возрастное ограничение меньше, чем переданное в url значение.


//В Node js для генерации и отдачи HTML - страниц используются шаблонизаторы.
//Node js шаблонизатор представляет собой специальный модуль, использующий 
//более удобный синтаксис для формирования HTML на основе динамических данных и позволяющий разделять представление от контроллер

"use strict";

// импорт библиотек
const express = require("express");
const fs = require("fs");

// запускаем сервер
const app = express();
const port = 5000;
app.listen(port);
console.log(`Server on port ${port}`);

// активируем шаблонизатор
app.set("view engine", "hbs");

// заголовки в ответ клиенту
app.use(function (req, res, next) {
	res.header("Cache-Control", "no-cache, no-store, must-revalidate");
	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
	res.header("Access-Control-Allow-Origin", "*");
	next();
});

// выдача страницы с информацией о кафедре
app.get("/page/department", function (request, response) {
	const infoObject = {
		facultyValue: "Информатика и системы управления",
		departmentValue: "Компьютерные системы и сети",
		indexValue: 6
	};
	response.render("pageDepartment.hbs", infoObject);
});



// выдача страницы с массивом игр
app.get("/page/games", function (request, response) {
	//__dirname - возвращает путь к каталогу текущего исполняемого файла
	//(__dirname использует локацию выполняемого скрипта(файла))
	let age = request.query.age;
	console.log(age);
	age = parseInt(age);

	//Проверка на корректность параметра URL-адреса
	if (!age) {
		response.end("Input Error!");
		return
	}

	const file = "games.json";
	const path = __dirname + "/" + file;
	if (!fs.existsSync(path)) {
		console.log("\nThe file" + file + "does not exist!")
	};
	const fileContent = fs.readFileSync(path, "utf-8");
	const GamesArray = JSON.parse(fileContent);

	//Массив игр, возрастное ограничение которых будет меньше переданного в URL-адресе
	const ResultArray = []

	for (let i = 0; i < GamesArray.length; i++)
		if (GamesArray[i].restriction < age)
			ResultArray.push(GamesArray[i]);

	//Формирование объекта для передачи в шаблон
	const infoObject = {
		descriptionValue: "Список компьютерных игр",
		gamesArray: ResultArray
	};
	response.render("pageGames.hbs", infoObject);
});

