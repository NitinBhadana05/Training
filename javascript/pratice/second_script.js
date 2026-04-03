const click = document.querySelector("#click");
const msg = document.querySelector("#msg");


const getData = async () => {
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, 2000);
    
  } );
  msg.textContent = "Data received";
};

click.addEventListener('click', () => {
    getData();
    msg.textContent = "Data Loading.....";
    

});

const btn = document.querySelector("#btn");
const msge = document.querySelector("#msge");

// Fake API
const fakeAPI = () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      const success = Math.random() > 0.5;

      if (success) {
        resolve("Data received");
      } else {
        reject("Something went wrong");
      }
    }, 2000);
  });
};

// Handle API
btn.addEventListener("click", async () => {
  msge.textContent = "Loading...";

  try {
    const result = await fakeAPI();
    msge.textContent = `Success: ${result}`;
  } catch (error) {
    msge.textContent = `Error: ${error}`;
  }
});