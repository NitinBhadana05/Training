const increment = document.querySelector("#increase");
const decrement = document.querySelector("#decrease");
const reset = document.querySelector("#reset");
const counter = document.querySelector("#count");

let count = 0;

increment.addEventListener("click", () => {
  count++;
  counter.textContent = count;
});

decrement.addEventListener("click", () => {
  if (count <= 0) {
    return;
  }
  count--;
  counter.textContent = count;
});

reset.addEventListener("click", () => {
  count = 0;
  counter.textContent = count;
});