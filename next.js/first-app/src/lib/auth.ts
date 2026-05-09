import jwt from "jsonwebtoken"

import { cookies } from "next/headers"

import prisma from "@/lib/prisma"

export async function getCurrentUser() {

  const cookieStore = await cookies()

  const token =
    cookieStore.get("token")?.value

  if (!token) {
    return null
  }

  try {
    const decoded: any = jwt.verify(
      token,
      process.env.JWT_SECRET!
    )

    const user =
      await prisma.user.findUnique({
        where: {
          id: decoded.userId,
        },
      })

    return user

  } catch {
    return null
  }
}