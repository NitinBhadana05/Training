"use client"

import { useState } from "react"

export default function About() {
  const [count, setCount] = useState(0)

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold mb-4">
        Count: {count}
      </h1>

      <button
        onClick={() => setCount(count + 1)}
        className="bg-blue-500 text-white px-4 py-2 rounded-lg"
      >
        Increase
      </button>
        &nbsp;&nbsp;&nbsp;
      <button
        onClick={() => setCount(count - 1)}
        className="bg-blue-500 text-white px-4 py-2 rounded-lg"
      >
        Decrease
      </button>

      &nbsp;&nbsp;&nbsp;

      <button
        onClick={() => setCount(0)}
        className="bg-blue-500 text-white px-4 py-2 rounded-lg"
      >
        Reset
      </button>

    </main>
  )
}