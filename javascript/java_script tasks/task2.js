// for loop

for (let i = 1; i <= 5; i++) {
  console.log(`Iteration ${i}`);
}

let fruits = ["Apple", "Banana", "Cherry"];

for (let i = 0; i < fruits.length; i++) {
  console.log(fruits[i]);
}

// while loop

let count = 1;

while (count <= 5) {
  console.log(`Count: ${count}`);
  count++;
}

//Q1
let number = 10;

if ((number & 1) === 0){
    console.log(`${number} is even`);
} else {
    console.log(`${number} is odd`);
}


//Q2

let username = "admin";
let password = "1234";

if (username === "admin" && password === "1234") {
    console.log("Login successful");
} else {
    console.log("Invalid credentials");
}

//Q3

let marks = 85;

if (marks >= 90) {
    console.log("Grade: A");
} else if (marks >= 70) {
    console.log("Grade: B");    
} else if (marks >= 50) {
    console.log("Grade: C");
} else {
    console.log("Fail");
}


//Q4

for (let i = 1; i <= 10; i++) {
    console.log(i);
}


//Q5

let sum = 0;

for (let i = 1; i <= 5; i++) {
    sum += i;
}
console.log(`Sum of numbers from 1 to 5: ${sum}`);


//Q6

for (let i = 1; i <= 20; i++) {

    if (i % 5 === 0 && i % 3 === 0) {
        console.log("FizzBuzz");
    } else if (i % 5 === 0) {
        console.log("Buzz");
    } else if (i % 3 === 0) {
        console.log("Fizz");
    } else {
        console.log(i);
    }

}

//Q7
let password3  = "abc123";

if (password3.length > 10) {
    console.log("Password is strong");
} else if (password3.length >= 6) {
    console.log("Password is moderate");
} else {
    console.log("Password is weak");
}