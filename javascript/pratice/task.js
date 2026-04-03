
/*.........................Task 1..................*/
const msg = document.querySelector("#msg");
const btn = document.querySelector("#btn");

let isVisible = true;
btn.addEventListener("click", () => {
  isVisible = !isVisible;
  btn.textContent = isVisible ? "Hide" : "Show";
  msg.style.display = isVisible ? "" : "none";
  
});



/*.........................Task 2..................*/
const text = document.querySelector("#text");
const count = document.querySelector("#count");

text.addEventListener('input', () => {
  
  count.textContent = text.value.length;
});



/*.........................Task 3..................*/

const num1 = document.querySelector("#num1");
const num2 = document.querySelector("#num2");
const add1 = document.querySelector("#adds");
const sub = document.querySelector("#sub");
const res = document.querySelector("#result");



add1.addEventListener("click", () => {
  const number1 = num1.value.trim();
  const number2 = num2.value.trim();
  res.textContent = Number(number1) + Number(number2);
  num1.value = "";
  num2.value = "";
});

sub.addEventListener("click", () => {
  const number1 = num1.value.trim();
  const number2 = num2.value.trim();
  res.textContent = Number(number1) - Number(number2);
  num1.value = "";
  num2.value = "";
});

/*.........................Task 4..................*/

const task = document.querySelector("#task");
const item = document.querySelector("#item");
const tbtn = document.querySelector("#tbtn");

tbtn.addEventListener('click', () => {
  const li = document.createElement('li');
  li.innerHTML = item.value.trim();

  const dtn = document.createElement('button');
  dtn.textContent = "X";

  dtn.addEventListener('click', () => {
    task.remove()
  });

  li.appendChild(dtn);
  task.appendChild(li);

});


/*.........................Task 5..................*/

const change = document.querySelector("#change");

change.addEventListener('click', () => {
  let colorBox = ['red', 'blue', 'green', 'yellow', 'white', 'pink'];
  let num = Math.floor(Math.random() * colorBox.length); 
  document.body.style.background = colorBox[num];
});


/*.........................Task 6..................*/


const search = document.getElementById("search");
const list = document.getElementById("list");

// sample data
const items = ["apple", "banana", "grapes", "orange", "mango", "pineapple"];

let timer;

search.addEventListener("input", () => {
  clearTimeout(timer); // clear previous timer

  timer = setTimeout(() => {
    filterData(search.value);
  }, 300); // debounce delay
});

// filter function
function filterData(value) {
  list.innerHTML = "";

  const filtered = items.filter(item =>
    item.toLowerCase().includes(value.toLowerCase())
  );

  filtered.forEach(item => {
    const li = document.createElement("li");
    li.textContent = item;
    list.appendChild(li);
  });
}



/*.........................Task 7..................*/

/*.........................Task 8..................*/
/*.........................Task 9..................*/
/*.........................Task 10..................*/