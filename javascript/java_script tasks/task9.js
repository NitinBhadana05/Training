//1
const usersContainer = document.querySelector("#print_box");

const getUsers = async () => {
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/users");
    const users = await res.json();

    users.forEach(user => {
      const p = document.createElement("p");
      p.textContent = user.name;
      usersContainer.appendChild(p);
    });

  } catch (err) {
    console.log("Error:", err);
  }
};

getUsers();

//2
const userContainer1 = document.querySelector("#print_box1");

const getTitles = async () => {
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/posts");
    const posts = await res.json();

    posts.forEach((post) => {
      const p = document.createElement("p");
      p.textContent = post.title;
      userContainer1.appendChild(p);
    });

  } catch (err) {
    console.log("Error", err);
  }
};

getTitles();

//3

const list = document.querySelector("#list");

const getTitleList = async () => {
  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/posts");
    const posts = await res.json();

    posts.forEach((post) => {
      const li = document.createElement("li");
      li.textContent = post.title;
      list.appendChild(li);
    });

  } catch (err) {
    console.log(`Error: ${err}`);
  }
};

getTitleList();



