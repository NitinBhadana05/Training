"use client"

import { useState } from "react"

import {
  updateMission,
  deleteMission,
} from "@/app/actions/mission-actions"

export default function MissionCard({
  mission,
}: any) {
  const [showEdit, setShowEdit] = useState(false)

  return (
    <div className="border p-4 rounded">
      <h2 className="text-2xl font-bold">
        Mission #{mission.id.toString()}
      </h2>

      <p>
        Hunter: {mission.hunters.alias}
      </p>

      <p>
        Target: {mission.bounties.target_name}
      </p>

      <p>
        Notes: {mission.notes}
      </p>

      <div className="flex gap-3 mt-4">

        {/* EDIT BUTTON */}

        <button
          onClick={() => setShowEdit(!showEdit)}
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Edit
        </button>

        {/* DELETE */}

        <form action={deleteMission}>
          <input
            type="hidden"
            name="id"
            value={mission.id.toString()}
          />

          <button
            type="submit"
            className="bg-red-500 text-white px-4 py-2 rounded"
          >
            Delete
          </button>
        </form>
      </div>

      {/* EDIT FORM */}

      {showEdit && (
        <form
          action={updateMission}
          className="mt-4"
        >
          <input
            type="hidden"
            name="id"
            value={mission.id.toString()}
          />

          <input
            type="text"
            name="notes"
            placeholder="Update notes"
            className="border p-2 rounded mr-2"
          />

          <button
            type="submit"
            className="bg-green-500 text-black px-4 py-2 rounded"
          >
            Save
          </button>
        </form>
      )}
    </div>
  )
}