"use client"




import { useState, useEffect } from "react"


export default function Home() {
  const name = "Next.js"
  const age = 30
  const [click, setClick] = useState(false)
  const [showFruits, setShowFruits] = useState(false)
  const toggleFruits = () => setShowFruits(prev => !prev)

  useEffect(() => {
    console.log("Page loaded successfully...................")
  }, [])
  return (


    <div>
      
      
      <main className="p-10">
        <h1 className="text-4xl font-bold">
          Hello Next.js 🚀
        </h1>

      
          <h1>My age is {age}</h1>
          <h1>My name is {name}</h1>

          <div className="p-10">
            <button onClick={() => setClick(prev => !prev)} className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-yellow-500 hover:text-black">
              {click ? 'Clicked' : 'Click Me'}
              
            </button>&nbsp;&nbsp;&nbsp;
            
            <h1 className="text-2xl mt-4">
              {click}
              {click ? 'Button has been clicked!' : 'Button has not been clicked yet.'}
            </h1>

            <button 
              onClick={toggleFruits}
              className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
              {showFruits ? 'Hide Fruits' : 'Show Fruits'}
            </button>

            
            {showFruits && <Fruits />}
          </div>
          
      </main>
    </div>
  ) 
}

export function Fruits() {
  const fruits = ["Apple", "Banana", "Mango"]

  return (
    <main className="p-10">
      <ul>
        {fruits.map((fruit) => (
          <li key={fruit} className="text-2xl">
            {fruit}
          </li>
        ))}
      </ul>
    </main>
  )
}
