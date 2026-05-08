import {prisma} from "@/lib/prisma"

import CreateBountyForm from "@/app/components/CreateBountyForm"

export default async function BountiesPage() {

  const bounties =
    await prisma.bounties.findMany()

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold mb-6">
        Bounties
      </h1>

      <CreateBountyForm />

      <div className="space-y-4 mt-10">
        {bounties.map((bounty) => (
          <div
            key={bounty.id.toString()}
            className="border p-4 rounded"
          >
            <h2 className="text-2xl font-bold">
              {bounty.target_name}
            </h2>

            <p>
              Reward:
              {" "}
              {bounty.reward_amount}
            </p>

            <p>
              Threat Level:
              {" "}
              {bounty.threat_level}
            </p>

            <p>
              Status:
              {" "}
              {bounty.status}
            </p>
          </div>
        ))}
      </div>
    </main>
  )
}