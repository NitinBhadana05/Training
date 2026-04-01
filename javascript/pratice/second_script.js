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