const taskInput = document.querySelector("#taskInput");
const addTaskBtn = document.querySelector("#addTask");
const taskList = document.querySelector("#taskList");

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