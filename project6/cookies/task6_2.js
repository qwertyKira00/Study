//Cookie - это набор переменных, передающихся при каждом HTTP запросе в формате ключ - значение
//Мы будем выставлять Cookie на стороне сервера
//Проверять Cookie мы тоже будем на стороне сервера
//При этом Cookie хранятся на стороне клиента(браузера)

//Создаем файл с зависимостями
//npm init --yes

//Устанавливаем фреймворк express
//npm install express --save

//Устанавливаем библиотеку для работы с cookie
//npm install cookie-session --save

//Создать сервер.В оперативной памяти на стороне сервера создать массив,
//в котором хранится информация о пользователях(логин, пароль, хобби, возраст).
//На основе cookie реализовать авторизацию пользователей.Реализовать возможность для 
//авторизованного пользователя просматривать информацию о себе.

"use strict";

// импортируем библиотеки
const express = require("express");
const cookieSession = require("cookie-session");
//npm install fs --save
const fs = require("fs");

// запускаем сервер
const app = express();
const port = 5000;
app.listen(port);
console.log(`Server on port ${port}`);

// работа с сессией
app.use(cookieSession({
	name: 'session',
	keys: ['hhh', 'qqq', 'vvv'],
	maxAge: 24 * 60 * 60 * 1000 * 365
}));

// // заголовки в ответ клиенту
// app.use(function (req, res, next) {
// 	res.header("Cache-Control", "no-cache, no-store, must-revalidate");
// 	res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
// 	next();
// }); 

// сохранить cookie
//Пример: http://localhost:5000/api/save?login=KiraSan&password=qwerty
app.get("/api/save", function (request, response) {
	// Если пользователь уже авторизован,
	//выдаем сообщение об этом
	console.log(request.session);
	if (request.session.login) {
		response.end("You are signed in.");
	}

	//console.log(request.session);
	// получаем параметры запроса
	const login = request.query.login;
	console.log(login)
	const password = request.query.password;

	// контролируем существование параметров
	if (!login) return response.end("Login not set");
	if (!password) return response.end("Password not set");

	const file = "DB_users.json";
	const path = __dirname + "/" + file;
	const fileContent = fs.readFileSync(path, "utf-8");
	const UsersArray = JSON.parse(fileContent);

	//Если пользователь зарегистрирован (информация о нем находится в файле),
	//при авторизации выставляем Cookie на стороне сервера
	for (let i = 0; i < UsersArray.length; i++) {
		if (UsersArray[i].login === login && UsersArray[i].password === password) {
			// выставляем cookie
			request.session.login = login;
			request.session.password = password;
			// отправляем ответ об успехе операции
			response.end("Set cookie ok");
		}
	}
	response.end("Authorization fail: invalid login or password");

});

//Проверка на то, авторизован ли пользователь (проверка на существование Cookie),
//и выдача информации о нем (если да) или сообщения о том, что его Cookie не существуют
// http://localhost:5000/api/get

app.get("/api/get", function (request, response) {
	// контролируем существование cookie
	if (!request.session.login) return response.end("Not exists");
	if (!request.session.password) return response.end("Not exists");

	//Если Cookie существуют (пользователь авторизован),
	//получаем информацию о нем из файла с зарегистрированными пользователями
	const file = "DB_users.json";
	const path = __dirname + "/" + file;
	const fileContent = fs.readFileSync(path, "utf-8");
	const UsersArray = JSON.parse(fileContent);

	const login = request.session.login;
	const password = request.session.password;
	for (let i = 0; i < UsersArray.length; i++) {
		if (UsersArray[i].login === login && UsersArray[i].password === password) {

			return response.end("Info:\nLogin: " + UsersArray[i].login +
				"\nAge : " + UsersArray[i].age + "\nHobby: " + UsersArray[i].hobby);
		}
	}
});

// удалить все cookie
// http://localhost:5000/api/delete
app.get("/api/delete", function (request, response) {
	request.session = null;
	console.log(request.session);
	response.end("Delete cookie ok");
});

//Зайдем не под своим паролем:
// http://localhost:5000/api/save?login=KiraSan&password=123
//Получим сообщение об этом: Authorization fail: invalid login or password
//Пробуем зайти с неверным логином
//http://localhost:5000/api/save?login=123Wol&password=1234567
//Получим сообщение об этом: Authorization fail: invalid login or password

//Зайдем под своим паролем:
// http://localhost:5000/api/save?login=KiraSan&password=qwerty
//Успех: сообщение "You are signed in"
//Получим информацию о пользователе:
// http://localhost:5000/api/get
//Успех
//Пробуем авторизоваться еще раз
// http://localhost:5000/api/save?login=123Wolf&password=1234567
//Неуспех (так как пользователь уже авторизован)
//Удалим Cookies и зайдем снова
//Успех
