const API_KEY = "EA8KYBRRKE9ZXY23"; 

// ✅ 5 default stocks
const defaultStocks = [
  { name: "Apple", symbol: "AAPL" },
  { name: "Microsoft", symbol: "MSFT" },
  { name: "Google", symbol: "GOOGL" },
  { name: "Amazon", symbol: "AMZN" },
  { name: "Tesla", symbol: "TSLA" }
];

// 📋 Sidebar company list (more companies)
const allCompanies = [
  ...defaultStocks,
  { name: "Meta", symbol: "META" },
  { name: "Netflix", symbol: "NFLX" },
  { name: "Nvidia", symbol: "NVDA" },
  { name: "Intel", symbol: "INTC" },
  { name: "IBM", symbol: "IBM" },
  { name: "Adobe", symbol: "ADBE" },
  { name: "Oracle", symbol: "ORCL" },
  { name: "PayPal", symbol: "PYPL" },
  { name: "Uber", symbol: "UBER" },
  { name: "Spotify", symbol: "SPOT" },
  { name: "Salesforce", symbol: "CRM" },
  { name: "Zoom", symbol: "ZM" },
  { name: "Snap", symbol: "SNAP" },
  { name: "Shopify", symbol: "SHOP" },
  { name: "AMD", symbol: "AMD" }
];

// 📊 Load default stocks
window.onload = () => {
  loadDefaultStocks();
  loadSidebar();
};

// 📊 Default 5 stocks
async function loadDefaultStocks() {
  const table = document.getElementById("stockTable");
  table.innerHTML = "";

  for (let stock of defaultStocks) {
    await fetchAndAddRow(stock.symbol, stock.name);
    await new Promise(r => setTimeout(r, 12000)); // avoid limit
  }
}

// 📋 Sidebar
function loadSidebar() {
  const list = document.getElementById("companyList");

  allCompanies.forEach(c => {
    const li = document.createElement("li");
    li.textContent = c.name;

    li.onclick = () => fetchAndAddRow(c.symbol, c.name);

    list.appendChild(li);
  });
}

// 🔍 Search
async function searchStock() {
  const query = document.getElementById("search").value;

  if (!query) return;

  const url = `https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=${query}&apikey=${API_KEY}`;

  const res = await fetch(url);
  const data = await res.json();

  const match = data.bestMatches?.[0];

  if (!match) {
    alert("No company found");
    return;
  }

  const symbol = match["1. symbol"];
  const name = match["2. name"];

  fetchAndAddRow(symbol, name);
}

// 📡 Fetch + Add Row
async function fetchAndAddRow(symbol, name) {
  const table = document.getElementById("stockTable");

  const url = `https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=${symbol}&apikey=${API_KEY}`;

  try {
    const res = await fetch(url);
    const data = await res.json();

    if (data.Note) {
      alert("API limit reached. Wait 1 min.");
      return;
    }

    const stock = data["Global Quote"];

    if (!stock || Object.keys(stock).length === 0) return;

    const row = `
      <tr>
        <td>${name}</td>
        <td>${symbol}</td>
        <td>${stock["05. price"]}</td>
        <td>${stock["03. high"]}</td>
        <td>${stock["04. low"]}</td>
        <td>${stock["06. volume"]}</td>
      </tr>
    `;

    table.innerHTML += row;

  } catch (err) {
    console.log(err);
  }
}