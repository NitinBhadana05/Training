import { redirect }
from "next/navigation"

import { getCurrentUser }
from "@/lib/auth"

export default async function DashboardPage() {

  const user =
    await getCurrentUser()

  if (!user) {
    redirect("/login")
  }

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold">
        Dashboard
      </h1>

      <p className="mt-4">
        Logged in successfully
      </p>
    </main>
  )
}