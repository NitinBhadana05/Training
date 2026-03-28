//funcrions

function add(num1, num2) {
    return num1 + num2;
}

console.log(add(10, 20));
console.log(add(5, 15));

//type of function

//normal function
function greet(name) {
    return `Hello, ${name}!`;
}

console.log(greet("Alice"));


//arrow function
const greetArrow = (name) => {
    return `Hello, ${name}!`;
}

console.log(greetArrow("Bob"));

//function Expression
const greetExpression = function(name) {
    return `Hello, ${name}!`;
}

console.log(greetExpression("Charlie"));

//default parameters
function greetDefault(name = "Guest") {
    return `Hello, ${name}!`;
}   
console.log(greetDefault());
console.log(greetDefault("David"));



//Q1

const add = (num1, num2) => {
    return num1 + num2;
}

//Q2

const isEven = (num) => {
    return num % 2 === 0;
}

//Q3

const tempratureConverter = (celsius) => {
    return (celsius * 9) / 5 + 32;
}

//Q4

const greetUser = (name) => {
    return `Hello, ${name}!`;
}

//Q5
function passwordValidator(password) {
    if (password.length > 10) {
        return "Strong";
} else if (password.length >= 6) {
        return "Medium";
} else {
        return "Weak";
}}