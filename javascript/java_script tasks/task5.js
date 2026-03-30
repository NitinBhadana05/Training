//1

const changeTitleBtn = document.querySelector("#change_title");
const title = document.querySelector("#title");

let isWelcome = true;
let isGreen = true;

changeTitleBtn.addEventListener("click", () => {
  isWelcome = !isWelcome;
  title.textContent = isWelcome ? "Welcome" : "Goodbye";
});

//2

const changeColorBtn = document.querySelector("#change_color");

changeColorBtn.addEventListener("click", () => {

 isGreen = !isGreen;
  title.style.color = isWelcome ? "green" : "red";
})


//3

const productList = document.querySelector("#product-list");
const addItemBtn = document.querySelector("#add_product");
const removeItemBtn = document.querySelector("#remove_product");
const addItemInput = document.querySelector("#add_item");
const removeItemInput = document.querySelector("#remove_item");

// Add Item
addItemBtn.addEventListener("click", () => {
  const value = addItemInput.value.trim();
  if (!value) return;

  const newItem = document.createElement("li");
  newItem.textContent = value;

  productList.appendChild(newItem);
  addItemInput.value = "";
});
//4
// Remove Item
removeItemBtn.addEventListener("click", () => {
  const value = removeItemInput.value.trim();
  const items = productList.children;

  for (let i = 0; i < items.length; i++) {
    if (items[i].textContent === value) {
      items[i].remove();
      break;
    }
  }

  removeItemInput.value = "";
});

//5

const inputField = document.querySelector("#input");
const outputText = document.querySelector("#output");
const printValueBtn = document.querySelector("#print_output");

printValueBtn.addEventListener("click", () => {
  const value = inputField.value.trim();

  if (!value) {
    outputText.textContent = "Please enter something";
    return;
  }

  outputText.textContent = value;
  inputField.value = "";
});