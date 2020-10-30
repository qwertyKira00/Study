//Создать хранилище в оперативной памяти для хранения информации о детях.
//Необходимо хранить информацию о ребенке: фамилия и возраст.
//Необходимо обеспечить уникальность фамилий детей.											+
//Реализовать функции:
//CREATE READ UPDATE DELETE для детей в хранилище											+
//Получение среднего возраста детей															+
//Получение информации о самом старшем ребенке												
//Получение информации о детях, возраст которых входит в заданный отрезок					+
//Получение информации о детях, фамилия которых начинается с заданной буквы					+
//Получение информации о детях, фамилия которых длиннее заданного количества символов		+
//Получение информации о детях, фамилия которых начинается с гласной буквы					+

"use strict";

class Children {
	constructor() {
		this.array = [];
	}
	Add(lastname, age) {
		if (!(this.array.find(x => x.lastname === lastname))) {
			this.array.push({ lastname, age });
		}
	}
	Read(lastname) {
		return (this.array.find(x => x.lastname === lastname));
	}
	Update(lastname, new_age) {
		let child = this.Read(lastname);
		if (child) {
			child.age = new_age;
		}
		else {
			console.log("Wrong lastname! (child was not found)\n");
		}
	}
	Delete(lastname) {
		this.array = this.array.filter(x => x.lastname !== lastname);
	}
	PrintAll() {
		console.log("\n");
		for (let i = 0; i < this.array.length; i++)
			console.log("Lastname: " + this.array[i].lastname + " Age: " + this.array[i].age);
	}
	PrintChild(child) {
		console.log("Lastname: " + child.lastname + " Age: " + child.age);
	}
	GetAverage() {
		let avg = 0;
		let len = this.array.length;
		for (let i = 0; i < len; i++) avg += this.array[i].age;
		avg /= len;

		console.log("\nAverage age is " + avg);
	}

	GetOldestChild() {
		let max = 0;
		let index = 0;
		for (let i = 0; i < this.array.length; i++)
			if (this.array[i].age > max) {
				max = this.array[i].age;
				index = i;
			}
		console.log("\nThe oldest child is ") + this.PrintChild(this.array[index]);
	}
	GetChildAgeIntervel(x, y) {

		let flag = false;
		console.log("\n");
		for (let i = 0; i < this.array.length; i++) {
			if (this.array[i].age >= x && this.array[i].age <= y) {
				flag = true;
				console.log("Child at age within the interval [" + x + ";" + y + "] is");
				this.PrintChild(this.array[i]);
			}
		}
		if (!(flag)) {
			console.log("There are no children at age within the interval [" + x + ";" + y + "]!");
		}
	}
	GetChildByLetter(letter) {

		let flag = false;
		console.log("\n");
		for (let i = 0; i < this.array.length; i++)
			if (this.array[i].lastname[0].toLowerCase() === letter.toLowerCase()) {
				flag = true;
				console.log("Child whose lastname starts with letter " + letter + " is");
				this.PrintChild(this.array[i]);
			}

		if (!(flag)) {
			console.log("\nThere are no children whose lastname starts with letter " + letter);
		}
	}
	GetChildByLastnameLength(x) {

		let flag = false;
		console.log("\n");
		for (let i = 0; i < this.array.length; i++)
			if (this.array[i].lastname.length > x) {
				flag = true;
				console.log("Child whose lastname is more than " + x + " is");
				this.PrintChild(this.array[i]);
			}

		if (!(flag)) {
			console.log("\nThere are no children whose lastname is more than " + x);
		}
	}
	GetChildVowel() {
		function isVowel(letter) {
			return ['a', 'e', 'i', 'o', 'u'].indexOf(letter.toLowerCase()) !== -1
		}

		let flag = false;
		console.log("\n");
		for (let i = 0; i < this.array.length; i++)
			if (isVowel(this.array[i].lastname[0])) {
				flag = true;
				console.log("Child whose lastname starts with a vowel letter is");
				this.PrintChild(this.array[i]);
			}
		if (!(flag)) {
			console.log("\nThere are no children whose lastname starts with a vowel letter");
		}
	}
}


let C = new Children();
C.Add("Kim", 12);
C.Add("Ripson", 13);
C.Add("Bronx", 15);
C.Add("Grace", 12);
C.Add("Kim", 14);
C.Add("Owen", 10);
C.Add("Uris", 16);
C.PrintAll()

C.Delete("Bronx");
C.PrintAll()
C.GetAverage()
C.GetOldestChild()
C.GetChildAgeIntervel(5, 10);
C.GetChildByLetter("g");
C.GetChildByLastnameLength(4);
C.GetChildVowel();