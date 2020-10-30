//Task #2.1
"use strict";

class Point {

	constructor(x, y, z) {
		this.init(x, y, z);
	}

	init(x, y, z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	renderFields() {
		let messageX = "coordinate X = " + this.x;
		let messageY = "coordinate Y = " + this.y;
		let messageZ = "coordinate Z = " + this.z;
		let fullMessage = messageX + " " + messageY + " " + messageZ;
		console.log(fullMessage);
	}
}

class Offcut {
	constructor(x1, y1, z1, x2, y2, z2) {
		this.x1 = x1;
		this.y1 = y1;
		this.z1 = z1;
		this.x2 = x2;
		this.y2 = y2;
		this.z2 = z2;
		this.firstPoint = new Point();
		this.secondPoint = new Point();
	}

	getSquareDiff(a, b) {
		return Math.pow((a - b), 2);
	}

	getSum(a, b, c) {
		return a + b + c;
	}

	renderFields(a) {
		let message = "Length of the offcut is " + a;
		console.log(message);
	}

	getLength() {
		this.firstPoint.init(this.x1, this.y1, this.z1);
		this.secondPoint.init(this.x2, this.y2, this.z2);

		let l = Math.sqrt(this.getSum(this.getSquareDiff(this.firstPoint.x, this.secondPoint.x),
			this.getSquareDiff(this.firstPoint.y, this.secondPoint.y),
			this.getSquareDiff(this.firstPoint.z, this.secondPoint.z)));

		this.renderFields(l);

	}
}

//Task #2
class Triangle {
	constructor(a, b, c) {			//1: Initialization
		this.a = a;
		this.b = b;
		this.c = c;
	}

	checkExist() {
		let message = "This triangle does not exist";
		if (this.a + this.b > this.c && this.b + this.c > this.a && this.a + this.c > this.b) {
			message = "This triangle exists";
		}
		console.log(message);
		//2: Check if exists
	}

	getPerimeter() {
		let p = this.a + this.b + this.c;
		return p;
		//3: Perimeter
	}

	getSquare() {
		let p = this.getPerimeter() / 2;
		let S = Math.sqrt(p * (p - this.a) * (p - this.b) * (p - this.c));
		console.log(S);
		//4: Square
	}

	checkRightTriangle() {
		let message = "This triangle is not right";
		const eps = 1e-2;

		if (Math.abs(this.a * this.a + this.b * this.b - this.c * this.c) < eps ||
			Math.abs(this.b * this.b + this.c * this.c - this.a * this.a) < eps ||
			Math.abs(this.a * this.a + this.c * this.c - this.b * this.b) < eps) {
			message = "This triangle is right";
		}
		console.log(message);
		//5: Check if right
	}

}

let a = new Triangle(3.01, 4, 5);

a.checkRightTriangle();
