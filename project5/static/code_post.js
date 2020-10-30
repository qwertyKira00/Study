"use strict";

window.onload = function () {
	// input fields
	const f1 = document.getElementById("field-first");
	const f2 = document.getElementById("field-second");
	const f3 = document.getElementById("field-third");

	// button
	const btn = document.getElementById("add-contact-btn");

	// label (результат добавления (добавлено/не добавлено))
	const label = document.getElementById("result-label");

	// ajax post
	function ajaxPost(urlString, body, callback) {
		let r = new XMLHttpRequest();
		//Инициализация соединения
		r.open("POST", urlString, true);
		r.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
		r.send(body);
		r.onload = function () {
			callback(r.response);
		};
	};

	// click event
	btn.onclick = function () {
		const mail = f1.value;
		const lastname = f2.value;
		const number = f3.value;

		//Создание POST запроса

		ajaxPost("/save/info", JSON.stringify({
			mail, lastname, number
		}), function (stringAnswer) {
			const objectAnswer = JSON.parse(stringAnswer);
			const result = objectAnswer.result;
			label.innerHTML = result;
		});
	};
};