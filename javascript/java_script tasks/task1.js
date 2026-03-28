//Data Types and Variables

//if-else statement

let isLoggedIn = true;

if (isLoggedIn) {
  console.log("Welcome back!");
} else {
  console.log("Please log in.");
}


let username1 = "";

if (username1) {
  console.log("Valid user");
} else {
  console.log("Empty username is not allowed");
}



//Q1
let name = "John";
let age = 30;
let isStudent = true;

console.log(`My name is ${name}, age is ${age}, student: ${isStudent}`);

//Q2
let num1 = 5;
let num2 = 10;

console.log(`Sum: ${num1 + num2}`);
console.log(`Product: ${num1 * num2}`);
console.log(`Difference: ${num2 - num1}`);
console.log(`Division: ${num2 / num1}`);

//Q3
let num3 = 5;
let text1 = "Hello";
let bool1 = true;

console.log(`num1 type: ${typeof num3}`);
console.log(`text1 type: ${typeof text1}`);
console.log(`bool1 type: ${typeof bool1}`);


//Q4
let celsius = 45;
let fahrenheit = (celsius * 9) / 5 + 32;

console.log(`Temperature: ${celsius}°C = ${fahrenheit}°F`);


//Q5
let price = 19.99;
let quantity = 3;
let totalCost = price * quantity;
console.log(`The total cost is $${totalCost.toFixed(2)}`);


