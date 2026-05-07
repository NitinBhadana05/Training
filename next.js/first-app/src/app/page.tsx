import Navbar from "./components/Navbar"

const name = "Next.js"
const age = 30
export default function Home() {
  return (
    <div>
      
      <Navbar title="Next Learning App" />
      <main className="p-10">
        <h1 className="text-4xl font-bold">
          Hello Next.js 🚀
        </h1>

      
          <h1>My age is {age}</h1>
          <h1>My name is {name}</h1>

          <div className="p-10">
            <button className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-500 hover:text-black">
              Click Me
            </button>
          </div>
        
      </main>
    </div>
  )
}