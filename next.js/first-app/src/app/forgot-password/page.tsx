"use client"

import { useActionState }
from "react"

import {
  forgotPassword
} from "@/actions/auth-actions"

const initialState = {
  success: "",
  error: "",
}

export default function ForgotPasswordPage() {

  const [state, formAction, pending] =
    useActionState(
      forgotPassword,
      initialState
    )

  return (
    <main className="p-10 max-w-xl mx-auto">

      <h1 className="text-4xl font-bold mb-6">
        Forgot Password
      </h1>

      <form
        action={formAction}
        className="space-y-4"
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
          type="email"
          name="email"
          placeholder="Email"
          className="border p-2 rounded w-full"
        />

        <button
          type="submit"
          disabled={pending}
          className="bg-black text-white px-4 py-2 rounded"
        >
          {pending
            ? "Sending..."
            : "Send Reset Link"}
        </button>
      </form>
    </main>
  )
}