"use client"

import { useActionState } from "react"

import { createBounty } from "@/app/actions/bounty-actions"

const initialState = {
  success: "",
  error: "",
}

export default function CreateBountyForm() {

  const [state, formAction, pending] =
    useActionState(
      createBounty,
      initialState
    )

  return (
    <form
      action={formAction}
      className="space-y-4 border p-4 rounded"
    >

      {state.success && (
        <p className="text-green-500">
          {state.success}
        </p>
      )}

      {state.error && (
        <p className="text-red-500">
          {state.error}
        </p>
      )}

      <input
        type="text"
        name="targetName"
        placeholder="Target Name"
        className="border p-2 rounded w-full"
      />

      <input
        type="number"
        name="rewardAmount"
        placeholder="Reward Amount"
        className="border p-2 rounded w-full"
      />

      <input
        type="number"
        name="threatLevel"
        placeholder="Threat Level"
        className="border p-2 rounded w-full"
      />

      <button
        type="submit"
        disabled={pending}
        className="bg-black text-white px-4 py-2 rounded"
      >
        {pending
          ? "Creating..."
          : "Create Bounty"}
      </button>
    </form>
  )
}