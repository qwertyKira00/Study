//Создать хранилище в оперативной памяти для хранения точек.
//Неоходимо хранить информацию о точке: имя точки, позиция X и позиция Y.
//Необходимо обеспечить уникальность имен точек.
//Реализовать функции:
//CREATE READ UPDATE DELETE для точек в хранилище														+
//Получение двух точек, между которыми наибольшее расстояние											+
//Получение точек, находящихся от заданной точки на расстоянии, не превышающем заданную константу		+
//Получение точек, находящихся выше / ниже / правее / левее заданной оси координат
//Получение точек, входящих внутрь заданной прямоугольной зоны

"use strict";

class Points {
	constructor() {
		this.array = [];
	}
	Add(name, x, y) {
		if (!(this.array.find(x => x.name === name))) {
			this.array.push({ name, x, y });
		}
	}
	Read(name) {
		return (this.array.find(x => x.name === name));
	}
	Update(name, new_x, new_y) {
		let p = this.Read(tname);
		if (p) {
			p.x = new_x;
			p.y = new_y;
		}
		else {
			console.log("Wrong name! (point was not found)\n");
		}
	}
	Delete(name) {
		this.array = this.array.filter(x => x.name !== name);
	}
	PrintAll() {
		console.log("\n");
		for (let i = 0; i < this.array.length; i++)
			console.log("Name: " + this.array[i].name + " X: " + this.array[i].x + " Y: " + this.array[i].y);
	}
	PrintPoint(p) {
		console.log("Name: " + p.name + " X: " + p.x + " Y: " + p.y);
	}
	GetPointsMaxDistance() {
		let max = 0;
		let index1 = 0, index2 = 0;
		let len = this.array.length;
		for (let i = 0; i < len - 1; i++)
			for (let j = i + 1; j < len; j++) {
				let a = this.array[i].x - this.array[j].x;
				let b = this.array[i].y - this.array[j].y;
				let dist = Math.sqrt(a * a + b * b);
				if (dist > max) {
					max = dist;
					index1 = i;
					index2 = j;
				}
			}
		console.log("\nPoints with the maximum distance between them are ");
		this.PrintPoint(this.array[index1]);
		this.PrintPoint(this.array[index2]);
	}

	ConstDistance(x, y, const_dist) {

		let flag = false;
		console.log("\n");
		for (let i = 0; i < this.array.length; i++) {
			let a = this.array[i].x - x;
			let b = this.array[i].y - y;
			let dist = Math.sqrt(a * a + b * b);
			if (dist <= const_dist) {
				flag = true;
				console.log("Point which distance to point [" + x + ";" + y + "] is no more than " + const_dist + " is ");
				this.PrintPoint(this.array[i]);
			}
		}
		if (!(flag)) {
			console.log("\nThere are no points which distance to point [" + x + ";" + y + "] is no more than " + const_dist);
		}
	}

	GetPointsAxis(axis) {
		let func;

		if (!axis) {
			console.log("\nX axis");
			console.log("Above:");
			for (let i = 0; i < this.array.length; i++)
				if (this.array[i].y > 0)
					this.PrintPoint(this.array[i]);
			console.log("Below:");
			for (let i = 0; i < this.array.length; i++)
				if (this.array[i].y < 0)
					this.PrintPoint(this.array[i]);
		}
		else {
			console.log("\nY axis");
			console.log("Left:");
			for (let i = 0; i < this.array.length; i++)
				if (this.array[i].x < 0)
					this.PrintPoint(this.array[i]);
			console.log("Right:");
			for (let i = 0; i < this.array.length; i++)
				if (this.array[i].x > 0)
					this.PrintPoint(this.array[i]);
		}
	}
	GetPointsInsideRectangle(min_x, max_x, min_y, max_y) {
		let arr = this.array.filter(p =>
			p.x > min_x && p.x < max_x &&
			p.y > min_y && p.y < max_y);

		console.log("\nRectangle: -5, 5, -5, 5");
		for (let i = 0; i < arr.length; i++)
			this.PrintPoint(arr[i]);
	}

}


let P = new Points();
P.Add("a", 0, 0);
P.Add("b", 1, 5);
P.Add("c", 2, 4);
P.Add("d", 10, 7);
P.Add("e", 1, -1);
P.Add("f", 0, 3);
P.Add("g", 8, -5.5);
P.PrintAll()

P.Delete("f");
P.PrintAll()

P.GetPointsMaxDistance();
P.ConstDistance(0, 0, 5);
P.GetPointsAxis(0);
P.GetPointsAxis(1);
P.GetPointsInsideRectangle(-5, 5, -5, 5);
