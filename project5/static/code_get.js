"use strict";

window.onload = function () {

	// Ссылка на поля.
	const field = document.getElementById("field-get-info");

	// Получаем кнопку, при нажатии на которую должна выдаваться информация.
	const btn = document.getElementById("get-info-btn");

	// ajax get
	function ajaxGet(urlString, callback) {
		let r = new XMLHttpRequest();
		//Инициализация соединения
		r.open("GET", urlString, true);
		r.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
		r.send(null);
		r.onload = function () {
			callback(r.response);
		};
	};

	// click event
	btn.onclick = function () {
		const mail = field.value;

		const url = `/find?mail=${mail}`;

		//Создание GET запроса

		ajaxGet(url, function (stringAnswer) {
			const objectAnswer = JSON.parse(stringAnswer);
			const result = objectAnswer.result;
			alert(result);
		});
	};
};