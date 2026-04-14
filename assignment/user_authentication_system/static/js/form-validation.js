document.addEventListener("DOMContentLoaded", () => {
    const forms = document.querySelectorAll("form[data-validate]");

    forms.forEach((form) => {
        form.addEventListener("submit", (event) => {
            const password = form.querySelector("[name='password']");
            const confirmPassword = form.querySelector("[name='confirm_password']");

            if (password && !isStrongPassword(password.value)) {
                password.setCustomValidity(
                    "Password must be at least 8 characters and include a special character."
                );
            } else if (password) {
                password.setCustomValidity("");
            }

            if (password && confirmPassword && password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Passwords do not match.");
            } else if (confirmPassword) {
                confirmPassword.setCustomValidity("");
            }

            if (!form.checkValidity()) {
                event.preventDefault();
                form.reportValidity();
            }
        });

        form.querySelectorAll("input").forEach((input) => {
            input.addEventListener("input", () => input.setCustomValidity(""));
        });
    });
});

function isStrongPassword(value) {
    return value.length >= 8 && /[!@#$%^&*(),.?":{}|<>_\-+=/\\[\];']/.test(value);
}
