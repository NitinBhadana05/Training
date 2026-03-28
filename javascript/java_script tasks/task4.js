// Array

let arr = [1, 2, 3, 4, 5]
console.log(arr[0]); // Accessing first element
console.log(arr.length); // Length of the array

arr.push(6); // Adding an element to the end
console.log(arr);

arr.pop(); // Removing the last element
console.log(arr);

arr.unshift(0); // Adding an element to the beginning
console.log(arr);

arr.shift(); // Removing the first element
console.log(arr);

arr.splice(2, 1); // Removing element at index 2
console.log(arr);

arr.splice(2, 0, 10); // Adding element at index 2
console.log(arr);   

// Looping through the array

for (let i = 0; i < arr.length; i++) {
    console.log(arr[i]);
}

// Using forEach

arr.forEach((element) => {
    console.log(element);
});

//objects
let person = {
    name: "John",
    age: 30,
    isStudent: true
};
console.log(person.name); // Accessing property
console.log(person["age"]); // Accessing property using bracket notation
person.city = "New York"; // Adding a new property
console.log(person);
delete person.isStudent; // Deleting a property
console.log(person);    
person.name = "Jane"; // Modifying a property
console.log(person);
person["age"] = 25; // Modifying a property using bracket notation
console.log(person);

//loops through object properties
for (let key in person) {
    console.log(`${key}: ${person[key]}`);
}

//foreach loop for objects
Object.keys(person).forEach((key) => {
    console.log(`${key}: ${person[key]}`);
});

person.greet = function() {
    return `Hello, my name is ${this.name}`;
};
console.log(person.greet());

person["introduce"] = function() {
    return `Hi, I'm ${this.name} and I'm ${this.age} years old.`;
}   
console.log(person.introduce());    


//Q1

let numbers = [1, 2, 3, 4, 5];
let total = 0;
numbers.forEach((num) => {
        total += num;
});
console.log(total);

//Q2

numbers.forEach((num) => {
    if (num % 2 === 0) {
        console.log(`${num} is even`);
    }
});

//Q3

let person1 = {
    name: "Alice",
    age: 25,
    city: "Los Angeles"
};
console.log(`${person1.name} is ${person1.age} old and lives in ${person1.city}`);

//Q4

let product = [
    { name: "Laptop", price: 9999.99 },
    { name: "Smartphone", price: 499.99 },
    { name: "Tablet", price: 299.99 }
]

product.forEach((item) => {
    console.log(`${item.name} costs $${item.price}`);
});

//Q5

product.forEach((item) => {
    if (item.price > 2000) {
        console.log(item.name);
    }
});
