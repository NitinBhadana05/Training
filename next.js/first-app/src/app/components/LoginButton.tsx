"use client"

import Link from "next/link"

export default function LoginButton() {
  return (
    <div className="flex gap-3">
      <Link
        href="/login"
        className="bg-black text-white px-4 py-2 rounded"
      >
        Login
      </Link>

      <Link
        href="/signup"
        className="border border-black px-4 py-2 rounded"
      >
        Sign up
      </Link>
    </div>
  )
}
