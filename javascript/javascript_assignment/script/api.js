

async function loadPosts() {
  const table = document.getElementById("tableBody");

  // show loading
  table.innerHTML = "<tr><td colspan='4'>Loading...</td></tr>";

  try {
    const res = await fetch("https://jsonplaceholder.typicode.com/posts");
    const data = await res.json();

    table.innerHTML = ""; // clear

    data.forEach(post => {
      const row = `
        <tr>
          <td>${post.id}</td>
          <td>${post.userId}</td>
          <td>${post.title}</td>
          <td>${post.body}</td>
        </tr>
      `;
      table.innerHTML += row;
    });

  } catch (err) {
    console.log(err);
    table.innerHTML = "<tr><td colspan='4'>Error loading data</td></tr>";
  }
}