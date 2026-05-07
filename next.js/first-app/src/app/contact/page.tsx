"use client"

import { useState } from "react"

export default function Contact() {
  const [name, setName] = useState("")

  return (
    
    <main className="p-10">
      <input
        type="text"
        placeholder="Enter name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        className="border p-2 rounded"
      />

      <h1 className="text-3xl mt-4">
        Hello {name}
      </h1>
    </main>
  )
}