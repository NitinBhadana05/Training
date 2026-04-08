// ===== Modal =====
function openModal(id) {
  document.getElementById(id).style.display = "block";
}

function closeModal(id) {
  document.getElementById(id).style.display = "none";
}

// ===== Slider =====
function openSlider(id) {
  document.getElementById(id).classList.add("active");
}

function closeSlider(id) {
  document.getElementById(id).classList.remove("active");
}

// ===== Result =====

const clearButton = document.querySelector("#clearButton");
const result_section = document.querySelector("#reslt_section");
function addResult(result) {
  let resultList = document.getElementById("result-list");
  let li = document.createElement("li");
  li.innerText = result;
  resultList.appendChild(li);
  clearButton.style.display = "block";
  result_section.style.display = "block";
  
}

function clearResult() {
  let resultList = document.getElementById("result-list");
  resultList.innerHTML = "";
  clearButton.style.display = "none";
  result_section.style.display = "none";
}


// ===================== PRIME =====================
const primeButton = document.querySelector("#primeButton");
const primeStart = document.querySelector("#prime-start");
const primeEnd = document.querySelector("#prime-end");
const primeError = document.querySelector("#prime-error");

primeButton.addEventListener("click", () => {
  let start = parseInt(primeStart.value);
  let end = parseInt(primeEnd.value);

  if (!start || !end) {
    primeEnd.textContent = "Please enter valid numbers.";
    return;
  }

  if (start < 0 || end < 0) {
    primeError.textContent = "Range cannot be negative.";
    return;
  }

  if (start > end || end === start) {
    primeError.textContent = "Invalid range.";
    return;
  }

  let result = [];

  for (let i = start; i <= end; i++) {
    if (isPrime(i)) result.push(i);
  }

  if (result.length === 0) {
    addResult(`No prime numbers found between ${start} and ${end}`);
  } else {
    addResult(`Prime numbers between ${start} and ${end}: ${result.join(", ")}`);
  }
  primeStart.value = "";
  primeEnd.value = "";

  closeModal('modal-prime');
});

function isPrime(num) {
  if (num <= 1) return false;

  for (let i = 2; i <= Math.sqrt(num); i++) {
    if (num % i === 0) return false;
  }

  return true;
}


// ===================== FIBONACCI =====================
const fibonacciButton = document.querySelector("#fibonacciButton");
const fibonacciValue = document.querySelector("#fibonacci-value");
const fibonacciError = document.querySelector("#fibonacci-error");

fibonacciButton.addEventListener("click", () => {
  let n = parseInt(fibonacciValue.value);

  if (!n) {
    fibonacciError.textContent = "Please enter a number.";
    return;
  }

  if (n < 0) {
    fibonacciError.textContent = "Value cannot be negative.";
    return;
  }
  

  let result = fibonacciSeries(n);

  addResult(`Fibonacci series (${n} terms): ${result.join(", ")}`);
  factorialValue.value = "";
  closeSlider('slider-fibonacci');
});

function fibonacciSeries(n) {
  let result = [];
  let a = 0, b = 1;

  for (let i = 0; i < n; i++) {
    result.push(a);
    [a, b] = [b, a + b];
  }

  return result;
}


// ===================== ARMSTRONG =====================
const armstrongButton = document.querySelector("#armstrongButton");
const armstrongValue = document.querySelector("#armstrong-value");
const armstrongError = document.querySelector("#armstrong-error");

armstrongButton.addEventListener("click", () => {
  let n = parseInt(armstrongValue.value);

  if (!n) {
    armstrongError.textContent = "Please enter a number.";
    return;
  }

  let result = isArmstrong(n);

  addResult(`${n} is ${result ? "an Armstrong number" : "not an Armstrong number"}`);
  armstrongValue.value = "";
  closeModal('modal-armstrong');
});

function isArmstrong(num) {
  let digits = num.toString().length;
  let sum = 0;
  let temp = num;

  while (temp > 0) {
    let digit = temp % 10;
    sum += digit ** digits;
    temp = Math.floor(temp / 10);
  }

  return sum === num;
}


// ===================== FACTORIAL =====================
const factorialButton = document.querySelector("#factorialButton");
const factorialValue = document.querySelector("#factorial-value");
const factorialError = document.querySelector("#factorial-error");

factorialButton.addEventListener("click", () => {
  let n = parseInt(factorialValue.value);

  if (!n) {
    factorialError.textContent = "Please enter a number.";
    return;
  }

  if (n < 0) {
    factorialError.textContent="Value cannot be negative.";
    return;
  }

  let result = factorial(n);

  addResult(`Factorial of ${n}: ${result}`);
  factorialValue.value = "";
  closeSlider('slider-factorial');
});

function factorial(num) {
  let result = 1;

  for (let i = 2; i <= num; i++) {
    result *= i;
  }

  return result;
}


// ===================== ODD / EVEN =====================
const oddevenButton = document.querySelector("#oddevenButton");
const oddevenValue = document.querySelector("#oddeven-value");
const oddevenError = document.querySelector("#oddeven-error");

oddevenButton.addEventListener("click", () => {
  let n = parseInt(oddevenValue.value);

  if (!n) {
    oddevenError.textContent = "Please enter a number.";
    return;
  }

  let result = (n % 2 === 0) ? "even" : "odd";

  addResult(`${n} is ${result}`);
  oddevenValue.value = "";
  closeModal('modal-odd-even');
});