"use client"

import { useEffect, useState } from "react"

export default function HuntersPage() {
  const [hunters, setHunters] = useState([])

  const [alias, setAlias] = useState("")
  const [rank, setRank] = useState("")
  const [loading, setLoading] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [editRank, setEditRank] = useState("")
  const [editAlias, setEditAlias] = useState("")
  const [editRegion, setEditRegion] = useState("")

  useEffect(() => {
    fetchHunters()
  }, [])

  const fetchHunters = async () => {
    const response = await fetch("/api/hunters")
    const data = await response.json()

    setHunters(data)
  }

  const createHunter = async () => {
  setLoading(true)

  await fetch("/api/hunters", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      alias,
      rank,
    }),
  })

  setAlias("")
  setRank("")

  fetchHunters()

  setLoading(false)
}

const deleteHunter = async (id: bigint) => {
  await fetch(`/api/hunters/${id}`, {
    method: "DELETE",
  })

  fetchHunters()
}

const updateHunter = async (id: bigint) => {
  await fetch(`/api/hunters/${id}`, {
    method: "PATCH",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      alias: editAlias,
      rank: editRank,
      region: editRegion,
    }),
  })

  setEditingId(null)

  fetchHunters()
}
  return (
    <main className="p-10">

      <div className="mb-8 space-y-4">
        <input
          type="text"
          placeholder="Alias"
          value={alias}
          onChange={(e) => setAlias(e.target.value)}
          className="border p-2   rounded w-full"
        /> <br /><br />

        <input
          type="text"
          placeholder="Rank"
          value={rank}
          onChange={(e) => setRank(e.target.value)}
          className="border p-2 rounded w-full"
        /><br /> <br />

        <button
          onClick={createHunter}
          disabled={loading}
          className="bg-black text-white px-4 py-2 rounded"
        >
          {loading ? "Creating..." : "Create Hunter"}
        </button><br /><br />
      </div>
      <h1 className=" text-4xl font-bold mb-6">
        Hunters
      </h1>

      {hunters.map((hunter: any) => (
        <div
          key={hunter.id.toString()}
          className="border p-4 mb-4 rounded"
        >
          <h2 className="text-2xl font-bold">
            {hunter.alias}
          </h2>

          <p>Rank: {hunter.rank}</p>

          <button
            onClick={() => {
              setEditingId(hunter.id.toString())

              setEditAlias(hunter.alias || "")
              setEditRank(hunter.rank || "")
              setEditRegion(hunter.region || "")
            }}
            className="bg-blue-500 text-white px-3 py-1 rounded mt-2 mr-2"
          >
            Edit
          </button> &nbsp;&nbsp;

          <button
            onClick={() => deleteHunter(hunter.id)}
            className="bg-red-500 text-white px-3 py-1 rounded mt-2"
          >
            Delete
          </button>

          {editingId === String(hunter.id) && (
  <div className="mt-4 border p-4 rounded bg-gray-100">
    <input
      type="text"
      placeholder="Alias"
      value={editAlias}
      onChange={(e) => setEditAlias(e.target.value)}
      className="border p-2 rounded w-full mb-2 text-black"
    />

    <input
      type="text"
      placeholder="Rank"
      value={editRank}
      onChange={(e) => setEditRank(e.target.value)}
      className="border p-2 rounded w-full mb-2 text-black"
    />

    <input
      type="text"
      placeholder="Region"
      value={editRegion}
      onChange={(e) => setEditRegion(e.target.value)}
      className="border p-2 rounded w-full mb-4 text-black"
    />

    <button
      type="button"
      onClick={() => updateHunter(hunter.id)}
      className="bg-blue-600 text-black px-4 py-2 rounded"
    >
      Save
    </button>
  </div>
)}
        </div>
      ))}
    </main>
  )
}