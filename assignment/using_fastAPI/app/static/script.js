function openmodal(id) {
  document.getElementById(id).style.display = "block";
}

function closemodal(id) {
  document.getElementById(id).style.display = "none";
}


// Select all forms
const allForms = document.querySelectorAll('form');
const result = document.getElementById('result');

allForms.forEach((form) => {
    form.addEventListener('submit', function(event) {
       
     
        const inputs = Array.from(this.querySelectorAll('input'));
        const isAllEmpty = inputs.some(input => input.value.trim() === "");
        if (isAllEmpty) {
            event.preventDefault(); // Stop the form
            result.textContent = ("Please enter something!");
        } 
    });
});


