//1



const input = document.querySelector("#input");
const output = document.querySelector("#output");
const btn = document.querySelector("#btn");
let isSeen = true;
btn.addEventListener('click', () =>{
isSeen = !isSeen;
if (isSeen){
  
  output.textContent = input.value.trim();
  btn.textContent = "Hide";
}else{
  
  btn.textContent = "Show";
  output.innerHTML = "";
}

});

//2.1

let users = [
  { name: "Nitin", age: 20 },
  { name: "Aman", age: 17 },
  { name: "Rahul", age: 25 }
];

let adult = users.filter(user => user.age >= 18);

let name = adult.map(user => user.name);

console.log(name);


//2.2

let products = [
  { name: "Laptop", price: 50000 },
  { name: "Mouse", price: 500 },
  { name: "Phone", price: 20000 },
  { name: "Keyboard", price: 800 }
];

let price = products.filter(p => p.price > 1000);
let name1 = price.map(n => n.name);

console.log(name1);
//2.3
let students = [
  { name: "Nitin", marks: 85 },
  { name: "Aman", marks: 40 },
  { name: "Rahul", marks: 60 },
  { name: "Priya", marks: 30 }
];

let marks = students.filter(s=> s.marks >= 50);
let res = marks.map(m=>m.name+"-"+m.marks);
console.log(res);


//3.1

async function placeHolder() {
  try {
    const row = await fetch("https://jsonplaceholder.typicode.com/users");
    const res = await row.json();

    const data = document.querySelector("#data");

    res.forEach(element => {
      const tr = document.createElement("tr");

      const nameTd = document.createElement("td");
      nameTd.textContent = element.name;

      const emailTd = document.createElement("td");
      emailTd.textContent = element.email;

      tr.appendChild(nameTd);
      tr.appendChild(emailTd);

      data.appendChild(tr);
    });

  } catch (er) {
    console.log(er);
  }
}

placeHolder();

//3.2
async function getData() {
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/posts");
    const res = await response.json();

    const container = document.querySelector("#container");

    res.slice(0, 5).forEach(data => {
      const card = document.createElement("div");
      card.className = "card";

      const title = document.createElement("h3");
      title.textContent = data.title;

      const body = document.createElement("p");
      body.textContent = data.body;

      card.appendChild(title);
      card.appendChild(body);

      container.appendChild(card);
    });

  } catch (err) {
    console.log(err);
  }
}

getData();

//3.3



const search = document.querySelector("#search");
const list = document.querySelector("#list");

let logs = [];

async function getValues() {
  try{
    const response = await fetch("https://jsonplaceholder.typicode.com/users");
    const res = await response.json();
    logs = res;
    display(logs);
  }catch (err){
    console.log(err);
  }
}

function display(data){
  

  list.textContent ="";
  data.forEach(user => {
    const li = document.createElement('li');
    li.textContent = user.name;
    list.appendChild(li);
  });
  
}

search.addEventListener('input', () => {
  const value = search.value.toLowerCase();

  const filtered = logs.filter(user => user.name.toLowerCase().includes(value));
  display(filtered);
})
getValues();

//4

const fname = document.querySelector("#name");
const email = document.querySelector("#email");
const password = document.querySelector("#password");
const form = document.querySelector("#form");


form.addEventListener('submit', (e) => {
  e.preventDefault();
  
  nameValue = fname.value.trim();
  emailValue = email.value.trim();
  passValue = password.value.trim();


  nameValidator(nameValue);
  emailValidator(emailValue);
  passValidator(passValue);

  if (nameValidator && emailValidator && passValidator){
    fname.value = "";
    email.value = "";
    password.value = "";
    alert("your form submit succedfully");
    
  }
  
});

const nameValidator= (name) =>{
  if (!name){
    alert("Name not be empty");
  }
}

const emailValidator= (email) =>{
  if (!email){
    alert("email not be empty");
  }else if (!email.includes('@') || !email.includes('.')){
    alert('email must include @ and .')
  }
}
const passValidator= (pass) =>{
  if (!pass){
    alert("password not be empty");
  }
}


//5

/*const taskInput = document.querySelector("#taskInput");
const taskList = document.querySelector("#taskList");
const taskError = document.querySelector("#taskError");
const addBtn = document.querySelector("#addBtn");

addBtn.addEventListener('click', () =>{

if (!taskInput.value.trim()){
  taskError.textContent = "Task cannot be empty.";
  return;
}
taskError.textContent = "";

const li = document.createElement('li');

li.textContent = taskInput.value.trim();

 li.addEventListener('click', () => {
    li.classList.toggle("completed");
  });

li.addEventListener('dblclick', () => {
  li.remove();

})

taskList.appendChild(li)
taskInput.value = "";


})*/

const taskInput = document.querySelector("#taskInput");
const taskList = document.querySelector("#taskList");
const taskError = document.querySelector("#taskError");
const addBtn = document.querySelector("#addBtn");

let tasks = JSON.parse(localStorage.getItem("tasks")) || [];

// render tasks on load
function renderTasks() {
  taskList.innerHTML = "";

  tasks.forEach((task, index) => {
    const li = document.createElement('li');
    li.textContent = task.text;

    if (task.completed) {
      li.classList.add("completed");
    }

    // mark complete
    li.addEventListener('click', () => {
      tasks[index].completed = !tasks[index].completed;
      saveTasks();
      renderTasks();
    });

    // delete
    li.addEventListener('dblclick', () => {
      tasks.splice(index, 1);
      saveTasks();
      renderTasks();
    });

    taskList.appendChild(li);
  });
}

// save to localStorage
function saveTasks() {
  localStorage.setItem("tasks", JSON.stringify(tasks));
}

//  add task
addBtn.addEventListener('click', () => {
  const value = taskInput.value.trim();

  if (!value) {
    taskError.textContent = "Task cannot be empty.";
    return;
  }

  taskError.textContent = "";

  tasks.push({
    text: value,
    completed: false
  });

  saveTasks();
  renderTasks();

  taskInput.value = "";
});

//  initial load
renderTasks();










//event  loop

console.log('start');
setTimeout (() => {
  console.log('end');
},0);

Promise.resolve().then (() => {
  console.log('Data Recive');
});

console.log('loading...');

// Clouser

function createCounter() {
  let count = 0;

  return function inner(){
    count ++;
    console.log(count);
  };
};

const counter = createCounter();
counter(); // 1
counter(); // 2
counter(); // 3