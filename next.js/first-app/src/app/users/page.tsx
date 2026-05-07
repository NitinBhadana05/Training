"use client"

import { useState, useEffect } from "react"
import Link from "next/link"


export default function Users() {
  const [users, setUsers] = useState([])

  
  useEffect(() => {
    const fetchUsers = async () => {
    try {
      const response = await fetch("https://jsonplaceholder.typicode.com/users")
      const data = await response.json()
      setUsers(data)
    } catch (error) {
      console.error("Error fetching users:", error)
    }
  } 
    fetchUsers()

  }, [])

  

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold mb-4">
        Users
      </h1>
      {users.map((user: { id: number; name: string; email: string }) => (
        <div key={user.id} className="mb-4 border p-4 rounded-lg shadow">
          <Link href={`/users/${user.id}?name=${user.name}`} className="hover:underline">
            <h2 className="text-xl font-bold">{user.name}</h2>
          </Link>
          <p className="text-gray-600">{user.email}</p>
        </div>
      ))}


    </main>
     
  )
}