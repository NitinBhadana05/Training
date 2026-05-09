import jwt from "jsonwebtoken"

import prisma from "@/lib/prisma"

import { cookies } from "next/headers"

import { NextResponse }
from "next/server"

export async function POST() {

  const cookieStore = await cookies()

  const refreshToken =
    cookieStore.get("refreshToken")?.value

  if (!refreshToken) {
    return NextResponse.json(
      {
        error: "Unauthorized",
      },
      {
        status: 401,
      }
    )
  }

  try {
    const decoded: any = jwt.verify(
      refreshToken,
      process.env.JWT_REFRESH_SECRET!
    )

    const user =
      await prisma.user.findUnique({
        where: {
          id: decoded.userId,
        },
      })

    if (
      !user ||
      user.refreshToken !== refreshToken
    ) {
      return NextResponse.json(
        {
          error: "Invalid refresh token",
        },
        {
          status: 401,
        }
      )
    }

    const newAccessToken = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      process.env.JWT_SECRET!,
      {
        expiresIn: "15m",
      }
    )

    cookieStore.set(
      "token",
      newAccessToken,
      {
        httpOnly: true,
        secure: false,
        path: "/",
      }
    )

    return NextResponse.json({
      success: true,
    })

  } catch {
    return NextResponse.json(
      {
        error: "Invalid token",
      },
      {
        status: 401,
      }
    )
  }
}