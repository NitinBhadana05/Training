import { NextResponse } from "next/server"
import type { NextRequest } from "next/server"

import jwt from "jsonwebtoken"

export function middleware(
  request: NextRequest
) {

  const token =
    request.cookies.get("token")?.value

  const pathname =
    request.nextUrl.pathname

  const protectedRoutes = [
    "/dashboard",
    "/missions",
    "/bounties",
    "/admin",
  ]

  const isProtected =
    protectedRoutes.some((route) =>
      pathname.startsWith(route)
    )

  if (!isProtected) {
    return NextResponse.next()
  }

  if (!token) {
    return NextResponse.redirect(
      new URL("/login", request.url)
    )
  }

  try {
    const decoded: any = jwt.verify(
      token,
      process.env.JWT_SECRET!
    )

    // ADMIN CHECK

    if (
      pathname.startsWith("/admin") &&
      decoded.role !== "admin"
    ) {
      return NextResponse.redirect(
        new URL("/dashboard", request.url)
      )
    }

    return NextResponse.next()

  } catch {
    return NextResponse.redirect(
      new URL("/login", request.url)
    )
  }
}
