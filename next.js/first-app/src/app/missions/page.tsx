

import {prisma} from "@/lib/prisma"

import { createMission } from "@/app/actions/mission-actions"

import MissionCard from "@/app/components/MissionCard"

export default async function MissionsPage() {
  const missions = await prisma.missions.findMany({
    include: {
      hunters: true,
      bounties: true,
    },
  })

  const hunters = await prisma.hunters.findMany()

  const bounties = await prisma.bounties.findMany()

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold mb-6">
        Missions
      </h1>

      {/* CREATE MISSION */}

      <form
        action={createMission}
        className="space-y-4 mb-10 border p-4 rounded"
      >
        {/* HUNTERS */}

        <select
          name="hunterId"
          className="border p-2 rounded w-full"
        >
          <option value="">
            Select Hunter
          </option>

          {hunters.map((hunter) => (
            <option
              key={hunter.id.toString()}
              value={hunter.id.toString()}
            >
              {hunter.alias}
            </option>
          ))}
        </select>

        {/* BOUNTIES */}

        <select
          name="bountyId"
          className="border p-2 rounded w-full"
        >
          <option value="">
            Select Bounty
          </option>

          {bounties.map((bounty) => (
            <option
              key={bounty.id.toString()}
              value={bounty.id.toString()}
            >
              {bounty.target_name}
            </option>
          ))}
        </select>

        {/* NOTES */}

        <textarea
          name="notes"
          placeholder="Mission Notes"
          className="border p-2 rounded w-full"
        />

        <button
          type="submit"
          className="bg-black text-white px-4 py-2 rounded"
        >
          Create Mission
        </button>
      </form>

      {/* MISSIONS */}

      <div className="space-y-6">
        {missions.map((mission) => (
          <MissionCard
            key={mission.id.toString()}
            mission={mission}
          />
        ))}
      </div>
    </main>
  )
}