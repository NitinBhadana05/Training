const form = document.querySelector("form");
const nameInput = document.querySelector("#input_name");
const email = document.querySelector("#input_email");
const password = document.querySelector("#input_password");
const confirmPassword = document.querySelector("#input_confirm_password");

const nameError = document.querySelector("#result");
const emailError = document.querySelector("#result1");
const passwordError = document.querySelector("#result2");
const confirmPasswordError = document.querySelector("#result4");
const finalMessage = document.querySelector("#result3");

form.addEventListener("submit", (e) => {
  e.preventDefault();

  // reset errors
  nameError.textContent = "";
  emailError.textContent = "";
  passwordError.textContent = "";
  confirmPasswordError.textContent = "";
  finalMessage.textContent = "";

  let isValid = true;

  const nameValue = nameInput.value.trim();
  const emailValue = email.value.trim();
  const passwordValue = password.value.trim();
  const confirmPasswordValue = confirmPassword.value.trim();

  if (!nameValue) {
    nameError.textContent = "Please enter your name";
    isValid = false;
  }

  if (!emailValue) {
    emailError.textContent = "Please enter your email";
    isValid = false;
  } else if (!emailValue.includes("@") || !emailValue.includes(".")) {
    emailError.textContent = "Please enter a valid email";
    isValid = false;
  }

  if (!passwordValue) {
    passwordError.textContent = "Please enter your password";
    isValid = false;
  } else if (passwordValue.length < 6) {
    passwordError.textContent = "Password must be at least 6 characters";
    isValid = false;
  }

  if (!confirmPasswordValue) {
    confirmPasswordError.textContent = "Please confirm your password";
    isValid = false;
  } else if (passwordValue !== confirmPasswordValue) {
    confirmPasswordError.textContent = "Password does not match";
    isValid = false;
  }

  if (isValid) {
    finalMessage.textContent = "Form submitted successfully";
    nameInput.value = "";
    email.value = "";
    password.value = "";
    confirmPassword.value = "";
  }
});