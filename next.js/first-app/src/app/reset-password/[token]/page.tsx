"use client"

import { use, useActionState } from "react"

import { resetPassword } from "@/app/actions/auth-actions"

const initialState = {
  success: "",
  error: "",
}

export default function ResetPasswordTokenPage({
  params,
}: {
  params: Promise<{ token: string }>
}) {
  const { token } = use(params)

  const [state, formAction, pending] =
    useActionState(
      resetPassword,
      initialState
    )

  return (
    <main className="p-10 max-w-xl mx-auto">
      <h1 className="text-4xl font-bold mb-6">
        Reset Password
      </h1>

      <form
        action={formAction}
        className="space-y-4"
      >
        <input
          type="hidden"
          name="token"
          value={token}
        />

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
          type="password"
          name="password"
          placeholder="New Password"
          className="border p-2 rounded w-full"
        />

        <button
          type="submit"
          disabled={pending}
          className="bg-black text-white px-4 py-2 rounded"
        >
          {pending
            ? "Resetting..."
            : "Reset Password"}
        </button>
      </form>
    </main>
  )
}
