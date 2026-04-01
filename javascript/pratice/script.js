const click = document.querySelector("#click");

click.addEventListener('click', () => {
    alert("Button clicked")
});






const toggle = document.querySelector("#tog");
const heading = document.querySelector("#heading");

toggle.addEventListener("click", () => {
  heading.textContent = heading.textContent === "Hello" ? "Goodbye" : "Hello";
});

heading.addEventListener("dblclick", () => {
  heading.style.color = "red";
});







const list = document.querySelector("#list");
const input = document.querySelector("#input");
const addButton = document.querySelector("#addbtn");


addButton.addEventListener('click', () => {
  const item = document.createElement('li');
  item.textContent = input.value;
  list.appendChild(item);
  input.value = '';
});

const removebtn = document.querySelector  ("#removebtn");

removebtn.addEventListener('click', () => {
  list.removeChild(list.lastElementChild);
});
//1


const hideBtn = document.getElementById("hide_btn");

const text = document.querySelector("#box");

let isVisible = true;
hideBtn.addEventListener("click", () => {
  isVisible = !isVisible;
  hideBtn.textContent = isVisible ? "Hide" : "Show";
  text.style.display = isVisible ? "block" : "none";  
  
});

//2

const counter = document.querySelector("#counter");
const decrementBtn = document.querySelector("#decrement");
const incrementBtn = document.querySelector("#increment");
const resetBtn = document.querySelector("#reset");

let count = 0;

decrementBtn.addEventListener("click", () => {
  if (count <= 0) {
    return;
  }

  count--;
  counter.textContent = count;
});

incrementBtn.addEventListener("click", () => {
  count++;
  counter.textContent = count;
});

resetBtn.addEventListener("click", () => {
  count = 0;
  counter.textContent = count;
});


//3

const taskInput = document.querySelector("#task_input");
const addTaskBtn = document.querySelector("#add_task");
const taskList = document.querySelector("#task_list");

addTaskBtn.addEventListener("click", () => {
  const taskText = taskInput.value.trim();
  if (!taskText) return;

  // create li
  const listItem = document.createElement("li");
  listItem.textContent = taskText;

  // create delete button
  const deleteBtn = document.createElement("button");
  deleteBtn.textContent = "Delete";

  // attach delete logic
  deleteBtn.addEventListener("click", () => {
    listItem.remove();
  });

  // append button to li
  listItem.appendChild(deleteBtn);

  // add li to list
  taskList.appendChild(listItem);

  // clear input
  taskInput.value = "";
});



const inp = document.querySelector("#inp");
const output = document.querySelector("#output");

inp.addEventListener("input", () => {
  output.value = inp.value;
});



const form = document.querySelector("#form");
const name = document.querySelector("#name");
const message = document.querySelector("#message");
const message1 = document.querySelector("#message1");
const emailInput = document.querySelector("#email");

form.addEventListener("submit", (e) => {
  e.preventDefault();
  const emailValue = emailInput.value.trim();

  if (!name.value.trim()) {
    message.textContent = "please enter your name";
    return;
  }else {
  message.textContent = "Success";
  }


  if (!emailValue) {
    message.textContent = "Please enter your email";
    return; 
  }

  if (!emailValue.includes("@") || !emailValue.includes("."))  {
    message1.textContent = "Please enter a valid email";
    return;
  }

  message.textContent = "Success";
});
