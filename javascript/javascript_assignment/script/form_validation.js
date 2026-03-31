const form = document.querySelector("#form");

const firstname = document.querySelector("#firstname");
const lastname = document.querySelector("#lastname");
const contact = document.querySelector("#contact");
const email = document.querySelector("#email");
const password = document.querySelector("#password");

form.addEventListener("submit", (e) => {
  e.preventDefault();

  validateInput(firstname, "First name is required");
  validateInput(lastname, "Last name is required");
  validateContact();
  validateEmail();
  validatePassword();
});

function showError(input, message) {
  const small = input.nextElementSibling;
  small.innerText = message;
  input.classList.add("input-error");
}

function showSuccess(input) {
  const small = input.nextElementSibling;
  small.innerText = "";
  input.classList.remove("input-error");
}

function validateInput(input, message) {
  if (input.value.trim() === "") {
    showError(input, message);
  } else {
    showSuccess(input);
  }
}

function validateContact() {
  const value = contact.value.trim();

  if (value === "") {
    showError(contact, "Contact is required");
  } else if (!/^\d{10}$/.test(value)) {
    showError(contact, "Enter valid 10-digit number");
  } else {
    showSuccess(contact);
  }
}

function validateEmail() {
  const value = email.value.trim();

  if (value === "") {
    showError(email, "Email is required");
  } else if (!value.includes("@") || !value.includes(".")) {
    showError(email, "Enter valid email");
  } else {
    showSuccess(email);
  }
}

function validatePassword() {
  const value = password.value.trim();

  if (value === "") {
    showError(password, "Password is required");
  } else if (value.length < 8) {
    showError(password, "Minimum 8 characters required");
  } else {
    showSuccess(password);
  }
}