//1
console.log('start')
setTimeout(() => {
    console.log('Done')
},2000)

//2
const promise = new Promise((resolve) =>{
    resolve("Success")
});

promise.then(res => console.log(res))
//3

const promise1 = new Promise((resolve,reject) =>{
    reject("Error happened")
});

promise1.catch((res) => console.log(res))

//4

let isWorking = true;
const promise3 = new Promise((resolve, reject) =>{
if (isWorking){
    resolve("Working")
}else{
    reject('not working')
}});

promise3.then(res => console.log(res)).catch(res => conosole.log(res))


//5
const getData = async () => {
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, 2000);
  });

  console.log("Data received");
};

getData();