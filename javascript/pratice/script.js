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

//