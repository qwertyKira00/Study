//Создать хранилище в оперативной памяти для хранения информации о студентах.
//Необходимо хранить информацию о студенте: название группы, номер студенческого билета, оценки по программированию.
//Необходимо обеспечить уникальность номеров студенческих билетов.					+
//Реализовать функции:
//CREATE READ UPDATE DELETE для студентов в хранилище								+
//Получение средней оценки заданного студента										+
//Получение информации о студентах в заданной группе								+
//Получение студента, у которого наибольшее количество оценок в заданной группе		+
//Получение студента, у которого нет оценок											+

"use strict";

class Students {
	constructor() {
		this.array = [];
	}
	Add(group, number, grades) {
		if (!(this.array.find(x => x.number === number))) {
			this.array.push({ group, number, grades });
		}
	}
	Read(number) {
		return (this.array.find(x => x.number === number));
	}
	Update(number, new_group, new_grades) {
		let student = this.Read(number);
		if (student) {
			student.group = new_group;
			student.grades = new_grades;
		}
		else {
			console.log("Wrong student number!");
		}
	}
	Delete(number) {
		this.array = this.array.filter(x => x.number !== number);
	}
	PrintAll() {
		for (let i = 0; i < this.array.length; i++)
			console.log("Group: " + this.array[i].group + " Stud.Number: "
				+ this.array[i].number + " Grades: "
				+ this.array[i].grades);
	}
	PrintStudent(student) {
		console.log("Group: " + student.group + " Stud.Number: "
			+ student.number + " Grades: "
			+ student.grades);
	}
	GetAverage(number) {
		function avg(arr) {
			let s = 0;
			let len = arr.length;
			for (let i = 0; i < len; i++) {
				s += arr[i];
			}
			return (s / len);
		}
		let student = this.array.find(x => x.number === number)
		if (student) {
			console.log("Average grades of student #" + number + ": " + avg(student.grades))
		}
		else {
			console.log("Wrong student number!");
		}
	}
	GetStudentsFromGroup(group) {

		let flag = false;
		for (let i = 0; i < this.array.length; i++) {
			if (this.array[i].group === group) {
				flag = true;
				this.PrintStudent(this.array[i]);
			}
		}
		if (!(flag)) {
			console.log("No students in group #" + group + "!");
		}
	}
	GetStudentMaxGrades(group) {
		function sum(arr) {
			let s = 0;
			for (let i = 0; i < arr.length; i++) {
				s += arr[i];
			}
			return s;
		}

		let flag = false;
		let index = 0;
		let max = 0;
		let s = 0;

		for (let i = 0; i < this.array.length; i++) {
			if (this.array[i].group === group) {
				flag = true;
				s = sum(this.array[i].grades)
				if (s > max) {
					max = s;
					index = i;
				}
			}
		}
		if (!(flag)) {
			console.log("No students in group #" + group + "!");
		}
		else {
			this.PrintStudent(this.array[index]);
		}
	}
	GetStudentNoGrades() {

		let flag = false;
		for (let i = 0; i < this.array.length; i++) {
			if (this.array[i].grades.length === 0) {
				flag = true;
				this.PrintStudent(this.array[i]);
			}
		}
		if (!(flag)) {
			console.log("All the students have grades!");
		}
	}

}

let S = new Students();
S.Add(3, 1, [5, 4, 5]);
S.Add(3, 2, [5, 5, 5]);
S.Add(3, 3, [4, 5, 3, 5]);
S.Add(1, 4, [4, 5, 3, 5, 4]);
S.Add(1, 5, []);

S.Delete(5);
S.PrintAll()