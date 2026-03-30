//1
const greet = (name) => `Hello ${name}`;
console.log(greet('nitin'))


//2
const user = {
  name: "John",
  age: 25,
  city: "Delhi"
};

const {name,city}=user
console.log(`${name} lives in ${city}`);

//3
const numbers = [10, 20, 30, 40];

const [first,...rest]= numbers
console.log(`first: ${first}\nrest: [${rest}]`)


//4

const arr1 = [1, 2];
const arr2 = [3, 4];

const mergedArray = [...arr1, ...arr2];
console.log(mergedArray)

//5

const sum = (...nums) => nums.reduce((a, b) => a + b, 0);
console.log(sum(1, 2, 3));


//6 

const greetUser = (name = "Guest") => `Hello ${name}`;
console.log(greetUser('nitin'))
console.log(greetUser())


//7
const user1 = {};

console.log(user1?.address?.city)

//8

let username ="" ;
console.log(username??'Guest')

//9

const users = [
  { name: "John", age: 25 },
  { name: "Alice", age: 30 }
];

const result = users.map(({ name, age }) => {
  return `${name} is ${age}`;
});

console.log(result);

//10
const product = {
  name: "Laptop",
  price: 50000
};

const newProduct = {
  ...product,
  discount: "10%",
  finalPrice: product.price - (product.price * 10 / 100)
};

console.log(newProduct);
